class MongoUserModel {
  final String? id;
  final String? firebaseId;
  final String? email;
  final String? name;
  final String? phone;
  final String? firebaseCreatedAt;
  final dynamic profileImage;
  final bool? isActive;
  final String? createdAt;
  final String? updatedAt;
  final int? v;

  MongoUserModel({
    this.id,
    this.firebaseId,
    this.email,
    this.name,
    this.phone,
    this.firebaseCreatedAt,
    this.profileImage,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  MongoUserModel.fromJson(Map<String, dynamic> json)
      : id = json['_id'] as String?,
        firebaseId = json['firebaseId'] as String?,
        email = json['email'] as String?,
        name = json['name'] as String?,
        phone = json['phone'] as String?,
        firebaseCreatedAt = json['firebaseCreatedAt'] as String?,
        profileImage = json['profileImage'],
        isActive = json['isActive'] as bool?,
        createdAt = json['createdAt'] as String?,
        updatedAt = json['updatedAt'] as String?,
        v = json['__v'] as int?;

  Map<String, dynamic> toJson() => {
        '_id': id,
        'firebaseId': firebaseId,
        'email': email,
        'name': name,
        'phone': phone,
        'firebaseCreatedAt': firebaseCreatedAt,
        'profileImage': profileImage,
        'isActive': isActive,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        '__v': v
      };
}
