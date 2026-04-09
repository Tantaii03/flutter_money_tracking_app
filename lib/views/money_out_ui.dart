import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

class MoneyOutUI extends StatefulWidget {
  const MoneyOutUI({super.key});

  @override
  State<MoneyOutUI> createState() => _MoneyOutUIState();
}

class _MoneyOutUIState extends State<MoneyOutUI> {
  final _formKey = GlobalKey<FormState>();
  final _detailController = TextEditingController();
  final _amountController = TextEditingController();
  bool _isLoading = false;
  final supabase = Supabase.instance.client;

  Future<void> _saveTransaction() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      await supabase.from('transactions').insert({
        'detail': _detailController.text,
        'amount': double.parse(_amountController.text),
        'type': 'expense', // ระบุเป็นเงินออก
        'date': DateFormat('d MMMM yyyy').format(DateTime.now()),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('บันทึกเงินออกเรียบร้อยแล้ว')),
        );
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      // จัดการ error
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF458F8B),
        title:
            const Text("บันทึกเงินออก", style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _detailController,
                decoration: const InputDecoration(labelText: "รายการเงินออก"),
                validator: (value) =>
                    value!.isEmpty ? 'กรุณากรอกรายละเอียด' : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "จำนวนเงิน"),
                validator: (value) =>
                    value!.isEmpty ? 'กรุณากรอกจำนวนเงิน' : null,
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveTransaction,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text("บันทึกเงินออก",
                      style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
