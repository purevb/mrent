class UserModel {
  final User? user;
  final String? msg;

  UserModel({
    this.user,
    this.msg,
  });

  UserModel.fromJson(Map<String, dynamic> json)
      : user = (json['user'] as Map<String, dynamic>?) != null
            ? User.fromJson(json['user'] as Map<String, dynamic>)
            : null,
        msg = json['msg'] as String?;

  Map<String, dynamic> toJson() => {'user': user?.toJson(), 'msg': msg};
}

class User {
  final String? id;
  final String? email;
  final String? password;

  final String? name;

  User({
    this.id,
    this.email,
    this.password,
    this.name,
  });

  User.fromJson(Map<String, dynamic> json)
      : id = json['_id'] as String?,
        email = json['email'] as String?,
        password = json['password'] as String?,
        name = json['name'] as String?;

  Map<String, dynamic> toJson() =>
      {'_id': id, 'email': email, 'password': password, 'name': name};
}
