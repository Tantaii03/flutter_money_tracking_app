import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

// Import ไฟล์ UI จากโฟลเดอร์ views
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
    url: 'https://dbilpkpmforjtpeqkill.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRiaWxwa3BtZm9yanRwZXFraWxsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzU2MjQzNzIsImV4cCI6MjA5MTIwMDM3Mn0.FB15crK4eMvZXfCeaSuqJkQYbFPvQusiMgolOuFZcZc',
  );

  runApp(const MyApp());
}

// เปลี่ยน MyApp จาก StatelessWidget เป็น StatefulWidget
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Money Tracking App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF458F8B),
          primary: const Color(0xFF458F8B),
        ),
        textTheme: GoogleFonts.kanitTextTheme(),
      ),
      // กำหนดหน้าเริ่มต้น
      initialRoute: '/',
      routes: {
        '/': (context) => const MainScaffold(), // เรียกใช้ Scaffold หลักที่นี่
        '/welcome': (context) => const WelcomeUI(),
        '/home': (context) => const HomeUI(),
        '/money_in': (context) => const MoneyInUI(),
        '/money_out': (context) => const MoneyOutUI(),
        '/money_balance': (context) => const MoneyBalanceUI(),
      },
    );
  }
}

// สร้าง Widget ที่รีเทิร์น Scaffold เพื่อเป็นโครงสร้างหลักของแอป
class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  @override
  Widget build(BuildContext context) {
    // รีเทิร์นหน้า SplashScreenUI เป็นหน้าแรกภายใน Scaffold
    return const SplashScreenUI();
  }
}
