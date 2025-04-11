class PropertyType {
  final String? id;
  final String? typeName;
  final int? v;

  PropertyType({
    this.id,
    this.typeName,
    this.v,
  });

  PropertyType.fromJson(Map<String, dynamic> json)
      : id = json['_id'] as String?,
        typeName = json['type_name'] as String?,
        v = json['__v'] as int?;

  Map<String, dynamic> toJson() => {'_id': id, 'type_name': typeName, '__v': v};
}
