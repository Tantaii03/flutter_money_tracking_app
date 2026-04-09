import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomeUI extends StatefulWidget {
  const WelcomeUI({super.key});

  @override
  State<WelcomeUI> createState() => _WelcomeUIState();
}

class _WelcomeUIState extends State<WelcomeUI>
    with SingleTickerProviderStateMixin {
  final Color primaryColor = const Color(0xFF458F8B);
  late AnimationController _controller;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(begin: -10, end: 10).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF458F8B), Color(0xFF2D6F6B)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              _buildBackgroundIcons(),
              Column(
                children: [
                  Expanded(
                    flex: 5,
                    child: Center(
                      child: AnimatedBuilder(
                        animation: _controller,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0, _floatAnimation.value),
                            child: Container(
                              width: screenWidth * 10.5,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withAlpha(51),
                                    blurRadius: 30,
                                    offset: const Offset(0, 15),
                                  ),
                                ],
                              ),
                              child: Image.asset(
                                'assets/images/paym_wel.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 40),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(242),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(26),
                            blurRadius: 20,
                            offset: const Offset(0, -10),
                          )
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  'บันทึก\nรายรับรายจ่าย',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.kanit(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor,
                                    height: 1.2,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15),
                              Text(
                                'จัดการการเงินของคุณได้ง่ายๆ\nเริ่มต้นสร้างวินัยการออมวันนี้',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.kanit(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: double.infinity,
                            height: 60,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                    context, '/home');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                foregroundColor: Colors.white,
                                elevation: 5,
                                shape: const StadiumBorder(),
                              ),
                              child: Text(
                                'เริ่มใช้งานแอปพลิเคชัน',
                                style: GoogleFonts.kanit(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackgroundIcons() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          children: [
            Positioned(
              top: 50 + _floatAnimation.value,
              left: 30,
              child: Icon(Icons.attach_money,
                  size: 40, color: Colors.white.withAlpha(51)),
            ),
            Positioned(
              top: 120 - _floatAnimation.value,
              right: 40,
              child: Icon(Icons.account_balance_wallet,
                  size: 40, color: Colors.white.withAlpha(51)),
            ),
            Positioned(
              bottom: 250 + _floatAnimation.value,
              left: 50,
              child: Icon(Icons.savings,
                  size: 35, color: Colors.white.withAlpha(51)),
            ),
          ],
        );
      },
    );
  }
}
