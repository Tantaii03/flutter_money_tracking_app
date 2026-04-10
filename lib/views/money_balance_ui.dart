import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter_money_tracking_app/services/supabase_service.dart';
import 'package:flutter_money_tracking_app/models/user_model.dart';

class MoneyBalanceUI extends StatefulWidget {
  const MoneyBalanceUI({super.key});

  @override
  State<MoneyBalanceUI> createState() => _MoneyBalanceUIState();
}

class _MoneyBalanceUIState extends State<MoneyBalanceUI> {
  final SupabaseService _supabaseService = SupabaseService();

  @override
  Widget build(BuildContext context) {
    // ดึงค่าความสูงของแถบ Status Bar (นาฬิกา/แบตเตอรี่)
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // 1. ส่วนหัวและบัตรยอดเงิน
          _buildHeader(statusBarHeight),

          const SizedBox(height: 10), // ระยะห่างหลังบัตร

          Text(
            'เงินเข้า/เงินออก',
            style: GoogleFonts.kanit(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF2D2D2D),
            ),
          ),

          const SizedBox(height: 10),

          // 2. ส่วนรายการธุรกรรม
          Expanded(
            child: _buildTransactionList(),
          ),
        ],
      ),
    );
  }

  // ==========================
  // Header + Balance Card
  // ==========================
  Widget _buildHeader(double statusBarHeight) {
    // ปรับความสูงเพื่อให้ชื่ออยู่ด้านบนและบัตรลอยตรงกลางพอดี
    double headerHeight = 160;
    double cardTopPosition = 95;

    return SizedBox(
      // จองพื้นที่ความสูงรวมของ Stack เพื่อไม่ให้รายการด้านล่างวิ่งขึ้นมาทับ
      height: 260 + statusBarHeight,
      child: Stack(
        children: [
          // พื้นหลังสีเขียว (ถมขึ้นไปชิดขอบบนสุดของหน้าจอ)
          Container(
            width: double.infinity,
            height: headerHeight + statusBarHeight,
            padding: EdgeInsets.only(
              top: statusBarHeight + 10, // ขยับเนื้อหาลงมาเล็กน้อยให้พ้นนาฬิกา
              left: 25,
              right: 25,
            ),
            decoration: const BoxDecoration(
              color: Color(0xFF458F8B),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              ),
            ),
            child: Row(
              crossAxisAlignment:
                  CrossAxisAlignment.start, // บังคับให้ชื่อ/รูป อยู่ด้านบน
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Matilda Nicrolus',
                  style: GoogleFonts.kanit(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 26,
                    backgroundImage: AssetImage(
                      'assets/images/user_profile.png',
                    ),
                  ),
                ),
              ],
            ),
          ),

          // บัตรยอดเงินคงเหลือ (ลอยทับส่วนเขียว)
          Positioned(
            top: cardTopPosition + statusBarHeight,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.88,
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: const Color(0xFF3E837E),
                  borderRadius: BorderRadius.circular(35),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    )
                  ],
                ),
                child: _buildBalanceCardContent(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ส่วนเนื้อหาในบัตรยอดเงิน
  Widget _buildBalanceCardContent() {
    return FutureBuilder<Map<String, double>>(
      future: _supabaseService.getTransactionSummary(),
      builder: (context, snapshot) {
        final summary =
            snapshot.data ?? {'totalIn': 0, 'totalOut': 0, 'balance': 0};

        return Column(
          children: [
            Text(
              'ยอดเงินคงเหลือ',
              style: GoogleFonts.kanit(color: Colors.white70, fontSize: 15),
            ),
            const SizedBox(height: 5),
            Text(
              NumberFormat('#,###.00').format(summary['balance']),
              style: GoogleFonts.kanit(
                color: Colors.white,
                fontSize: 38,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSummaryItem(
                  Icons.arrow_downward,
                  'ยอดเงินเข้ารวม',
                  NumberFormat('#,###').format(summary['totalIn']),
                ),
                _buildSummaryItem(
                  Icons.arrow_upward,
                  'ยอดเงินออกรวม',
                  NumberFormat('#,###').format(summary['totalOut']),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  // รายการธุรกรรม
  Widget _buildTransactionList() {
    return FutureBuilder<List<UserModel>>(
      future: _supabaseService.getAllPayments(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(color: Color(0xFF458F8B)));
        }
        if (snapshot.hasError) {
          return Center(
              child:
                  Text('Error: ${snapshot.error}', style: GoogleFonts.kanit()));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
              child: Text('ยังไม่มีรายการบันทึก', style: GoogleFonts.kanit()));
        }

        final items = snapshot.data!;
        return ListView.builder(
          padding: const EdgeInsets.only(top: 10, bottom: 20),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final data = items[index];
            bool isIncome = data.type == 'IN';
            return _buildTransactionItem(data, isIncome);
          },
        );
      },
    );
  }

  Widget _buildTransactionItem(UserModel data, bool isIncome) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFF1F1F1))),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 25),
        leading: CircleAvatar(
          radius: 25,
          backgroundColor: isIncome
              ? Colors.green.withValues(alpha: 0.1)
              : Colors.red.withValues(alpha: 0.1),
          child: Icon(
            isIncome ? Icons.arrow_downward : Icons.arrow_upward,
            color: isIncome ? Colors.green : Colors.red,
          ),
        ),
        title: Text(
          data.name ?? 'ไม่ระบุรายการ',
          style: GoogleFonts.kanit(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          data.createdAt != null
              ? DateFormat('d MMMM yyyy', 'th').format(data.createdAt!)
              : '-',
          style: GoogleFonts.kanit(fontSize: 12, color: Colors.grey),
        ),
        trailing: Text(
          NumberFormat('#,###.00').format(data.amount ?? 0),
          style: GoogleFonts.kanit(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isIncome ? const Color(0xFF4CAF50) : const Color(0xFFFF5252),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryItem(IconData icon, String label, String amount) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: const BoxDecoration(
              color: Colors.white24, shape: BoxShape.circle),
          child: Icon(icon, color: Colors.white, size: 14),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: GoogleFonts.kanit(color: Colors.white70, fontSize: 10)),
            Text(amount,
                style: GoogleFonts.kanit(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14)),
          ],
        )
      ],
    );
  }
}
