import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

class MoneyInUI extends StatefulWidget {
  const MoneyInUI({super.key});

  @override
  State<MoneyInUI> createState() => _MoneyInUIState();
}

class _MoneyInUIState extends State<MoneyInUI> {
  // GlobalKey สำหรับจัดการ Form และการตรวจสอบ (Validation)
  final _formKey = GlobalKey<FormState>();
  final _detailController = TextEditingController();
  final _amountController = TextEditingController();

  bool _isLoading = false;
  final supabase = Supabase.instance.client;

  // ฟังก์ชันแจ้งเตือนแบบ Alert Dialog
  void _showAlert(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title:
            Text(title, style: GoogleFonts.kanit(fontWeight: FontWeight.bold)),
        content: Text(message, style: GoogleFonts.kanit()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ตกลง'),
          ),
        ],
      ),
    );
  }

  // ฟังก์ชันบันทึกข้อมูล (Async Function)
  Future<void> _saveTransaction() async {
    // จุดสำคัญ: ตรวจสอบข้อมูลก่อนส่ง
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      // ส่งข้อมูลไปที่ Table 'transactions'
      await supabase.from('transactions').insert({
        'detail': _detailController.text.trim(),
        'amount': double.parse(_amountController.text),
        'type': 'income',
        'date': DateFormat('d MMMM yyyy').format(DateTime.now()),
        'created_at':
            DateTime.now().toIso8601String(), // เก็บเวลาจริงสำหรับการเรียงลำดับ
      });

      // จุดสำคัญ: ตรวจสอบ mounted เพื่อป้องกัน Error "use_build_context_synchronously"
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('บันทึกรายรับสำเร็จ!'),
            backgroundColor: Colors.green),
      );

      // เคลียร์ค่าในช่องกรอก
      _detailController.clear();
      _amountController.clear();

      // หน่วงเวลาเล็กน้อยเพื่อให้คนอ่าน SnackBar ทันก่อนกลับหน้า Home
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      if (mounted) _showAlert('ผิดพลาด', 'ไม่สามารถบันทึกได้ กรุณาลองใหม่');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    String currentDay =
        DateFormat('วันที่ d MMMM yyyy', 'th').format(DateTime.now());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF458F8B),
        elevation: 0,
        title:
            const Text("บันทึกรายรับ", style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildMiniHeader(),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Text(currentDay,
                        style: GoogleFonts.kanit(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 30),

                    // ช่องกรอกรายละเอียด
                    TextFormField(
                      controller: _detailController,
                      decoration: const InputDecoration(
                          labelText: "รายการเงินเข้า",
                          hintText: "เช่น เงินเดือน, ขายของ"),
                      validator: (value) =>
                          value!.isEmpty ? 'กรุณาระบุรายละเอียด' : null,
                    ),
                    const SizedBox(height: 20),

                    // ช่องกรอกจำนวนเงิน (รับเฉพาะตัวเลข)
                    TextFormField(
                      controller: _amountController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                          labelText: "จำนวนเงิน (บาท)", hintText: "0.00"),
                      validator: (value) {
                        if (value!.isEmpty) return 'กรุณาระบุจำนวนเงิน';
                        if (double.tryParse(value) == null)
                          return 'กรุณากรอกเป็นตัวเลขเท่านั้น';
                        return null;
                      },
                    ),
                    const SizedBox(height: 40),

                    // ปุ่มบันทึกพร้อมสถานะ Loading
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _saveTransaction,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF458F8B),
                          shape: const StadiumBorder(),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : const Text("บันทึกเงินเข้า",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18)),
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

  Widget _buildMiniHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: const BoxDecoration(
        color: Color(0xFF458F8B),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: const Column(
        children: [
          Text("ยอดเงินคงเหลือ", style: TextStyle(color: Colors.white70)),
          Text("2,500.00",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
