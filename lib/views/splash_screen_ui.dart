import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreenUI extends StatefulWidget {
  const SplashScreenUI({super.key});

  @override
  State<SplashScreenUI> createState() => _SplashScreenUIState();
}

class _SplashScreenUIState extends State<SplashScreenUI> {
  @override
  void initState() {
    super.initState();
    // ตั้งค่าให้หน้านี้แสดงค้างไว้ 3 วินาที แล้วค่อยไปหน้าถัดไป
    Future.delayed(const Duration(seconds: 3), () {
      // ตรวจสอบว่า Widget ยังอยู่บนหน้าจอหรือไม่ก่อนสั่งเปลี่ยนหน้า
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/welcome');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ใช้สีพื้นหลังโทน Teal/Turquoise จากรูปภาพ
      backgroundColor: const Color(0xFF458F8B),
      body: Center(
        child: Stack(
          children: [
            // ส่วนข้อความหลักตรงกลางหน้าจอ
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Money Tracking',
                    style: GoogleFonts.kanit(
                      textStyle: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10), // เว้นระยะห่างเล็กน้อย
                  Text(
                    'รายรับรายจ่ายของฉัน',
                    style: GoogleFonts.kanit(
                      textStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ส่วนข้อความ Footer ด้านล่างสุดของหน้าจอ
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(30.0), // ดันขึ้นมาจากขอบล่าง
                child: Column(
                  mainAxisSize: MainAxisSize
                      .min, // ให้ Column กินพื้นที่แค่เท่ากับข้อความ
                  children: [
                    Text(
                      'Created by 6XXXXXXXXXX',
                      style: GoogleFonts.kanit(
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: Colors.yellow, // สีเหลืองตามภาพ
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '- SAU -',
                      style: GoogleFonts.kanit(
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: Colors.yellow,
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
