import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomeUI extends StatefulWidget {
  const WelcomeUI({super.key});

  @override
  State<WelcomeUI> createState() => _WelcomeUIState();
}

class _WelcomeUIState extends State<WelcomeUI> {
  // สียังเป็นสีเขียว Teal ตามธีมหลัก
  final Color primaryColor = const Color(0xFF458F8B);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // พื้นหลังสีขาวสะอาดตามแบบ
      body: SafeArea(
        child: Column(
          children: [
            // ส่วนที่ 1: รูปภาพตัวการ์ตูน (Hero Image)
            // ใช้ Expanded เพื่อให้กินพื้นที่ด้านบนส่วนใหญ่และปรับขนาดตามหน้าจอ
            Expanded(
              flex: 3, // สัดส่วนพื้นที่ 3 ส่วนจาก 4 ส่วน
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Image.asset(
                    'assets/images/welcome_hero.png', // เปลี่ยนชื่อไฟล์ให้ตรง
                    fit: BoxFit
                        .contain, // ปรับรูปให้พอดีกับพื้นที่โดยไม่ผิดเพี้ยน
                  ),
                ),
              ),
            ),

            // ส่วนที่ 2: ข้อความต้อนรับและปุ่มกด
            Expanded(
              flex: 1, // สัดส่วนพื้นที่ 1 ส่วนที่เหลือด้านล่าง
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  // ทำมุมโค้งด้านบนเล็กน้อยเพื่อให้ดูนุ่มนวล
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // ข้อความพาดหัว
                    Text(
                      'บันทึก\nรายรับรายจ่าย',
                      textAlign: TextAlign.center, // จัดกึ่งกลาง
                      style: GoogleFonts.kanit(
                        textStyle: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: primaryColor, // สีเขียวตามแบบ
                          height: 1.2, // ระยะห่างระหว่างบรรทัด
                        ),
                      ),
                    ),
                    const SizedBox(height: 30), // เว้นระยะห่างก่อนถึงปุ่ม

                    // ปุ่ม "เริ่มใช้งานแอปพลิเคชัน"
                    SizedBox(
                      width: double.infinity, // ปุ่มกว้างเต็มหน้าจอ
                      height: 55, // ความสูงปุ่ม
                      child: ElevatedButton(
                        onPressed: () {
                          // เมื่อกดปุ่ม ให้เปลี่ยนไปหน้า Home และล้าง Stack หน้าเก่า
                          Navigator.pushReplacementNamed(context, '/home');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor, // สีพื้นหลังปุ่ม
                          foregroundColor: Colors.white, // สีข้อความบนปุ่ม
                          elevation: 5, // ความลึกของเงา
                          // ทำปุ่มโค้งมนมาก (Stadium Border) ตามแบบ
                          shape: const StadiumBorder(),
                        ),
                        child: Text(
                          'เริ่มใช้งานแอปพลิเคชัน',
                          style: GoogleFonts.kanit(
                            textStyle: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
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
      ),
    );
  }
}
