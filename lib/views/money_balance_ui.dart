import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MoneyBalanceUI extends StatefulWidget {
  const MoneyBalanceUI({super.key});

  @override
  State<MoneyBalanceUI> createState() => _MoneyBalanceUIState();
}

class _MoneyBalanceUIState extends State<MoneyBalanceUI> {
  final supabase = Supabase.instance.client;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF458F8B),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pushReplacementNamed(
              context, '/home'), // เชื่อมกลับหน้า Home
        ),
        title: const Text(
          "Firstname Lastname",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 15),
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/images/user_profile.png'),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // ส่วน Card แสดงยอดเงินคงเหลือรวม (Mini Header)
          _buildBalanceSummary(),

          const SizedBox(height: 20),

          Text(
            "เงินเข้า/เงินออก",
            style: GoogleFonts.kanit(
              textStyle:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10),

          // รายการธุรกรรม เรียงจากวันที่ล่าสุด
          Expanded(
            child: _buildTransactionStream(),
          ),
        ],
      ),
    );
  }

  // Widget ส่วนหัวแสดงยอดเงินรวม
  Widget _buildBalanceSummary() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
      decoration: const BoxDecoration(
        color: Color(0xFF458F8B),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: Column(
        children: [
          const Text("ยอดเงินคงเหลือ", style: TextStyle(color: Colors.white70)),
          const Text(
            "2,500.00",
            style: TextStyle(
                color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _summaryItem("ยอดเงินเข้ารวม", "5,700.00", Icons.arrow_downward,
                  Colors.white),
              _summaryItem("ยอดเงินออกรวม", "2,200.00", Icons.arrow_upward,
                  Colors.white),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryItem(String label, String amount, IconData icon, Color color) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.white54, size: 14),
            Text(" $label",
                style: const TextStyle(color: Colors.white70, fontSize: 11)),
          ],
        ),
        Text(amount,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold)),
      ],
    );
  }

  // ดึงข้อมูล Real-time จาก Supabase เรียงตามวันที่ล่าสุด
  Widget _buildTransactionStream() {
    return StreamBuilder<List<Map<String, dynamic>>>(
      // ดึงข้อมูลและสั่งเรียงลำดับตาม 'created_at' หรือ 'date' จากฐานข้อมูล
      stream: supabase
          .from('transactions')
          .stream(primaryKey: ['id']).order('created_at', ascending: false),
      builder: (context, snapshot) {
        if (snapshot.hasError)
          return Center(child: Text("Error: ${snapshot.error}"));
        if (!snapshot.hasData)
          return const Center(child: CircularProgressIndicator());

        final transactions = snapshot.data!;

        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          itemCount: transactions.length,
          separatorBuilder: (context, index) =>
              const Divider(height: 1, color: Colors.black12),
          itemBuilder: (context, index) {
            final item = transactions[index];
            final bool isIncome = item['type'] == 'income';

            return ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              leading: CircleAvatar(
                backgroundColor: isIncome ? Colors.green : Colors.red,
                child: Icon(
                  isIncome ? Icons.arrow_downward : Icons.arrow_upward,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              title: Text(
                item['detail'] ?? '',
                style: GoogleFonts.kanit(
                    textStyle: const TextStyle(fontWeight: FontWeight.w500)),
              ),
              subtitle: Text(
                item['date'] ?? '',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              trailing: Text(
                (item['amount'] ?? 0.0).toStringAsFixed(2),
                style: GoogleFonts.kanit(
                  textStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isIncome ? Colors.green : Colors.red,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
