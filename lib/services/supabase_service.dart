import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/payment_model.dart';

class SupabaseService {
  final _supabase = Supabase.instance.client;

  // =========================================================
  // 🔹 ดึงข้อมูลทั้งหมดจาก Payment_tb
  // =========================================================
  Future<List<PaymentModel>> getAllPayments() async {
    try {
      final response = await _supabase
          .from('Payment_tb')
          .select()
          .order('created_at', ascending: false);

      final List data = response as List;

      return data.map((item) => PaymentModel.fromJson(item)).toList();
    } catch (e) {
      throw Exception('Error fetching payments: $e');
    }
  }

  // =========================================================
  // 🔹 ดึงข้อมูลล่าสุด (ใช้แสดง Profile หน้า Home)
  // =========================================================
  Future<PaymentModel?> getLatestProfile() async {
    try {
      final response = await _supabase
          .from('Payment_tb')
          .select()
          .order('created_at', ascending: false)
          .limit(1)
          .maybeSingle();

      if (response == null) return null;

      return PaymentModel.fromJson(response);
    } catch (e) {
      throw Exception('Error getting profile: $e');
    }
  }

  // =========================================================
  // 🔹 เพิ่มข้อมูลใหม่
  // =========================================================
  Future<void> insertPayment(PaymentModel payment) async {
    try {
      await _supabase.from('Payment_tb').insert(payment.toJson());
    } catch (e) {
      throw Exception('Insert error: $e');
    }
  }

  // =========================================================
  // 🔹 อัปเดตข้อมูล
  // =========================================================
  Future<void> updatePayment(PaymentModel payment) async {
    try {
      await _supabase
          .from('Payment_tb')
          .update(payment.toJson())
          .eq('id', payment.id!);
    } catch (e) {
      throw Exception('Update error: $e');
    }
  }

  // =========================================================
  // 🔹 ลบข้อมูล
  // =========================================================
  Future<void> deletePayment(String id) async {
    try {
      await _supabase.from('Payment_tb').delete().eq('id', id);
    } catch (e) {
      throw Exception('Delete error: $e');
    }
  }
}
