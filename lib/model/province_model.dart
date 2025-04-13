class ProvinceModel {
  final String? id;
  final String? provinceName;
  final int? v;

  ProvinceModel({
    this.id,
    this.provinceName,
    this.v,
  });

  ProvinceModel.fromJson(Map<String, dynamic> json)
      : id = json['_id'] as String?,
        provinceName = json['province_name'] as String?,
        v = json['__v'] as int?;

  Map<String, dynamic> toJson() =>
      {'_id': id, 'province_name': provinceName, '__v': v};
}
