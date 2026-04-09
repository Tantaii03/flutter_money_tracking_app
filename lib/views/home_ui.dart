import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeUI extends StatefulWidget {
  const HomeUI({super.key});

  @override
  State<HomeUI> createState() => _HomeUIState();
}

class _HomeUIState extends State<HomeUI> {
  final supabase = Supabase.instance.client;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // 1. ส่วนหัว (Header) สีเขียว Teal ตามแบบ
      appBar: AppBar(
        backgroundColor: const Color(0xFF458F8B),
        elevation: 0,
        title: const Text(
          "Firstname Lastname", // ชื่อผู้ใช้
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 15),
            child: CircleAvatar(
              backgroundImage:
                  AssetImage('assets/images/user_profile.png'), // รูปโปรไฟล์
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // 2. ส่วน Card แสดงยอดเงินคงเหลือ
          _buildBalanceHeader(),

          const SizedBox(height: 20),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                "เงินเข้า/เงินออก", // หัวข้อรายการ
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          // 3. รายการธุรกรรม (Transaction List) เรียงจากล่าสุด
          Expanded(
            child: _buildTransactionList(),
          ),
        ],
      ),
    );
  }

  // Widget สำหรับ Card ยอดเงิน
  Widget _buildBalanceHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(25, 10, 25, 30),
      decoration: const BoxDecoration(
        color: Color(0xFF458F8B),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(35)),
      ),
      child: Column(
        children: [
          const Text("ยอดเงินคงเหลือ", style: TextStyle(color: Colors.white70)),
          const Text(
            "2,500.00", // ยอดคงเหลือหลัก
            style: TextStyle(
                color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSummaryInfo(
                  "ยอดเงินเข้ารวม", "5,700.00", Icons.arrow_downward),
              _buildSummaryInfo(
                  "ยอดเงินออกรวม", "2,200.00", Icons.arrow_upward),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryInfo(String label, String amount, IconData icon) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.white54, size: 16),
            Text(" $label",
                style: const TextStyle(color: Colors.white70, fontSize: 12)),
          ],
        ),
        Text(amount,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold)),
      ],
    );
  }

  // Widget ดึงข้อมูลจาก Supabase มาแสดงผล
  Widget _buildTransactionList() {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: supabase
          .from('transactions')
          .stream(primaryKey: ['id']).order('created_at'),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return const Center(child: CircularProgressIndicator());
        final data = snapshot.data!;

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          itemCount: data.length,
          itemBuilder: (context, index) {
            final item = data[index];
            bool isIncome =
                item['type'] == 'income'; // เช็คประเภทเงินเข้าหรือออก

            return ListTile(
              leading: CircleAvatar(
                backgroundColor: isIncome ? Colors.green : Colors.red,
                child: Icon(
                    isIncome ? Icons.arrow_downward : Icons.arrow_upward,
                    color: Colors.white,
                    size: 20),
              ),
              title: Text(item['detail'],
                  style: const TextStyle(fontWeight: FontWeight.w500)),
              subtitle: Text(item['date'],
                  style: const TextStyle(color: Colors.grey, fontSize: 12)),
              trailing: Text(
                "${item['amount'].toStringAsFixed(2)}",
                style: TextStyle(
                  color: isIncome ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
