import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter_money_tracking_app/services/supabase_service.dart';
import 'package:flutter_money_tracking_app/models/user_model.dart';

class MoneyInUI extends StatefulWidget {
  const MoneyInUI({super.key});

  @override
  State<MoneyInUI> createState() => _MoneyInUIState();
}

class _MoneyInUIState extends State<MoneyInUI> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final SupabaseService _supabaseService = SupabaseService();
  bool _isLoading = false;

  void _showFeedback(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.kanit()),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Future<void> _handleSave() async {
    if (_nameController.text.trim().isEmpty ||
        _amountController.text.trim().isEmpty) {
      _showFeedback('❌ กรุณากรอกข้อมูลให้ครบถ้วน!', Colors.redAccent);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final newData = UserModel(
        name: _nameController.text.trim(),
        amount: int.parse(_amountController.text.trim()),
        type: 'IN',
      );

      await _supabaseService.insertPayment(newData);

      if (!mounted) return;
      _showFeedback('✅ บันทึกรายรับเรียบร้อยแล้ว', Colors.green);
      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    } catch (e) {
      _showFeedback('เกิดข้อผิดพลาด: $e', Colors.red);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    String formattedDate =
        DateFormat('วันที่ d MMMM yyyy', 'th').format(DateTime.now());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. Header แบบเดียวกับหน้า Balance (ชิดขอบบน + บัตรลอย)
            _buildHeader(statusBarHeight),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  Text(formattedDate,
                      style: GoogleFonts.kanit(
                          fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text('บันทึกเงินเข้า',
                      style: GoogleFonts.kanit(
                          fontSize: 18, color: Colors.grey[600])),
                  const SizedBox(height: 35),

                  _buildInputField(
                      label: 'รายการเงินเข้า',
                      hint: 'เช่น เงินเดือน, ค่าจ้าง',
                      controller: _nameController),
                  const SizedBox(height: 25),
                  _buildInputField(
                      label: 'จำนวนเงินเข้า',
                      hint: '0.00',
                      controller: _amountController,
                      isNumber: true),

                  const SizedBox(height: 50),

                  // ปุ่มบันทึกสไตล์เดียวกับหน้าอื่น
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleSave,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF458F8B),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(35))),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text('บันทึกเงินเข้า',
                              style: GoogleFonts.kanit(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ปรับ Header ให้เป็นโครงสร้างเดียวกับ Balance_ui
  Widget _buildHeader(double statusBarHeight) {
    double headerHeight = 160;
    double cardTopPosition = 95;

    return SizedBox(
      height: 240 + statusBarHeight,
      child: Stack(
        children: [
          // พื้นหลังเขียวชิดขอบบน
          Container(
            width: double.infinity,
            height: headerHeight + statusBarHeight,
            padding: EdgeInsets.only(
              top: statusBarHeight + 10,
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
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Nicel Mubatri',
                  style: GoogleFonts.kanit(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.white24,
                  child: CircleAvatar(
                    radius: 23,
                    backgroundImage:
                        AssetImage('assets/images/user_profile2.png'),
                  ),
                ),
              ],
            ),
          ),

          // บัตรยอดเงินคงเหลือ (ลอย)
          Positioned(
            top: cardTopPosition + statusBarHeight,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.88,
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                decoration: BoxDecoration(
                  color: const Color(0xFF3E837E),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    )
                  ],
                ),
                child: _buildBalanceBoxContent(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceBoxContent() {
    return FutureBuilder<Map<String, double>>(
      future: _supabaseService.getTransactionSummary(),
      builder: (context, snapshot) {
        final summary =
            snapshot.data ?? {'totalIn': 0, 'totalOut': 0, 'balance': 0};
        return Column(
          children: [
            Text('ยอดเงินคงเหลือปัจจุบัน',
                style: GoogleFonts.kanit(color: Colors.white70, fontSize: 14)),
            const SizedBox(height: 5),
            Text(NumberFormat('#,###.00').format(summary['balance']),
                style: GoogleFonts.kanit(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold)),
          ],
        );
      },
    );
  }

  Widget _buildInputField(
      {required String label,
      required String hint,
      required TextEditingController controller,
      bool isNumber = false}) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      style: GoogleFonts.kanit(),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.kanit(color: const Color(0xFF458F8B)),
        hintText: hint,
        hintStyle: GoogleFonts.kanit(color: Colors.grey[400]),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Color(0xFFE0E0E0))),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Color(0xFF458F8B), width: 2)),
      ),
    );
  }
}
