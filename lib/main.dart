// 1. Flutter และ Library ภายนอก
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

// 2. Import ไฟล์ UI จากโฟลเดอร์ views (ใช้ชื่อโปรเจกต์ตามที่คุณตั้งใน pubspec.yaml)
import 'package:flutter_money_tracking_app/views/home_ui.dart';
import 'package:flutter_money_tracking_app/views/money_balance_ui.dart';
import 'package:flutter_money_tracking_app/views/money_in_ui.dart';
import 'package:flutter_money_tracking_app/views/money_out_ui.dart';
import 'package:flutter_money_tracking_app/views/splash_screen_ui.dart';
import 'package:flutter_money_tracking_app/views/welcome_ui.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ตั้งค่า Supabase
  await Supabase.initialize(
    url: 'YOUR_SUPABASE_URL',
    anonKey: 'YOUR_SUPABASE_ANON_KEY',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Money Tracking App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: const Color(0xFF458F8B),
        textTheme: GoogleFonts.kanitTextTheme(),
      ),
      // หน้าแรกที่แอปจะเปิดขึ้นมา
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreenUI(),
        '/welcome': (context) => const WelcomeUI(),
        '/home': (context) => const HomeUI(),
        '/money_in': (context) => const MoneyInUI(),
        '/money_out': (context) => const MoneyOutUI(),
        '/money_balance': (context) => const MoneyBalanceUI(),
      },
    );
  }
}
