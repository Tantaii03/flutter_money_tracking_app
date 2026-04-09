import 'address_model.dart';

class PaymentModel {
  String? id;
  String? name;
  int? age;
  String? homeno;
  AddressModel? address;
  DateTime? createdAt;

  PaymentModel({
    this.id,
    this.name,
    this.age,
    this.homeno,
    this.address,
    this.createdAt,
  });

  // 🔹 JSON -> Object
  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'],
      name: json['name'],
      age: json['age'],
      homeno: json['homeno'],

      // ⭐ สำคัญ: อ่าน JSON address
      address: json['address'] != null
          ? AddressModel.fromJson(json['address'])
          : null,

      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }

  // 🔹 Object -> JSON
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'age': age,
      'homeno': homeno,

      // ⭐ ส่ง JSON address ไป Supabase
      'address': address?.toJson(),
    };
  }
}
