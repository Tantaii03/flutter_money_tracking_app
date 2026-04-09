class AddressModel {
  String? district;
  String? province;
  String? zipcode;

  AddressModel({
    this.district,
    this.province,
    this.zipcode,
  });

  // 🔹 แปลง JSON -> Object
  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      district: json['district'],
      province: json['province'],
      zipcode: json['zipcode'],
    );
  }

  // 🔹 แปลง Object -> JSON เพื่อส่งไป Supabase
  Map<String, dynamic> toJson() {
    return {
      'district': district,
      'province': province,
      'zipcode': zipcode,
    };
  }
}
