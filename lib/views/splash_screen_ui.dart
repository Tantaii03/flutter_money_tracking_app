import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreenUI extends StatefulWidget {
  const SplashScreenUI({super.key});

  @override
  State<SplashScreenUI> createState() => _SplashScreenUIState();
}

class _SplashScreenUIState extends State<SplashScreenUI>
    with SingleTickerProviderStateMixin {
  // 🔹 Controller สำหรับควบคุม Animation ทั้งหมด
  late AnimationController _controller;

  // 🔹 Animation ไอคอนพื้นหลังลอยขึ้นลง
  late Animation<double> _floatAnimation;

  // 🔹 Animation โลโก้ลอยขึ้นลง
  late Animation<double> _logoFloatAnimation;

  // 🔹 Animation โลโก้เอียงซ้ายขวา
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();

    // 🔹 สร้าง Animation Controller (3 วินาที)
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 5))
          ..repeat(reverse: true);

    // 🔹 Animation ไอคอนเงินลอย
    _floatAnimation = Tween<double>(begin: -10, end: 10).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    // 🔹 Animation โลโก้ลอย
    _logoFloatAnimation = Tween<double>(begin: -8, end: 8).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    // 🔹 Animation โลโก้เอียง
    _rotateAnimation = Tween<double>(begin: -0.05, end: 0.05).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    // 🔹 แสดง Splash 3 วินาที แล้วไปหน้า Welcome
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/welcome');
      }
    });
  }

  @override
  void dispose() {
    // 🔹 ปิด Animation Controller เพื่อป้องกัน memory leak
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // 🎨 Gradient Background (ปรับสีได้ตรงนี้)
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF458F8B), // สีหลัก
              Color(0xFF2D6F6B), // สีเข้ม
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

        child: Stack(
          children: [
            /// ================================
            /// 🔹 Background Animation (ไอคอนเงินลอย)
            /// ================================
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Stack(
                  children: [
                    Positioned(
                      top: 100 + _floatAnimation.value,
                      left: 40,
                      child: Icon(
                        Icons.attach_money,
                        size: 40,
                        color: Colors.white.withAlpha(40),
                      ),
                    ),
                    Positioned(
                      top: 200 - _floatAnimation.value,
                      right: 60,
                      child: Icon(
                        Icons.account_balance_wallet,
                        size: 35,
                        color: Colors.white.withAlpha(40),
                      ),
                    ),
                    Positioned(
                      bottom: 150 + _floatAnimation.value,
                      left: 80,
                      child: Icon(
                        Icons.payments,
                        size: 30,
                        color: Colors.white.withAlpha(40),
                      ),
                    ),
                  ],
                );
              },
            ),

            /// ================================
            /// 🔹 Main Content
            /// ================================
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /// =========================
                  /// 🖼 LOGO (แก้รูปตรงนี้)
                  /// =========================
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, _logoFloatAnimation.value),
                        child: Transform.rotate(
                          angle: _rotateAnimation.value,
                          child: Image.asset(
                            'assets/images/Teddycoins.png',
                            height: 120,

                            /// 🔹 เปลี่ยน path รูปตรงนี้ได้
                            /// assets/images/your_logo.png
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  /// =========================
                  /// 🧾 Title
                  /// =========================
                  Text(
                    'Money Tracking',
                    style: GoogleFonts.kanit(
                      textStyle: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.5,

                        /// 🔹 เงาตัวอักษร
                        shadows: [
                          Shadow(
                            blurRadius: 10,
                            color: Colors.black.withAlpha(120),
                            offset: const Offset(3, 3),
                          ),
                          Shadow(
                            blurRadius: 20,
                            color: Colors.tealAccent.withAlpha(80),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// =========================
                  /// 🧾 Subtitle
                  /// =========================
                  Text(
                    'รายรับรายจ่ายของฉัน',
                    style: GoogleFonts.kanit(
                      textStyle: TextStyle(
                        fontSize: 20,
                        color: Colors.white.withAlpha(230),
                        shadows: [
                          Shadow(
                            blurRadius: 10,
                            color: Colors.black.withAlpha(100),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            /// ================================
            /// 🔹 Footer
            /// ================================
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Created by 6619410001',

                      /// 🔹 แก้รหัสนักศึกษาตรงนี้
                      style: GoogleFonts.kanit(
                        textStyle: TextStyle(
                          fontSize: 16,
                          color: Colors.yellow.withAlpha(230),
                          shadows: [
                            Shadow(
                              blurRadius: 10,
                              color: Colors.black.withAlpha(100),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '- SAU -',
                      style: GoogleFonts.kanit(
                        textStyle: TextStyle(
                          fontSize: 16,
                          color: Colors.yellow.withAlpha(230),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
