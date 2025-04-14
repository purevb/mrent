import 'package:cloud_firestore/cloud_firestore.dart';

class FbUserModel {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final DateTime createdAt;
  final String? photoUrl;
  final String authProvider;

  FbUserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    required this.createdAt,
    this.photoUrl,
    required this.authProvider,
  });

  factory FbUserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return FbUserModel(
      id: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? data['gmail'] ?? '',
      phone: data['phone'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      photoUrl: data['photoUrl'],
      authProvider: data['authProvider'] ?? 'google',
    );
  }

  Map<String, dynamic> toFirestoreMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'createdAt': Timestamp.fromDate(createdAt),
      'photoUrl': photoUrl,
      'authProvider': authProvider,
    };
  }

  Map<String, dynamic> toMongoDBMap() {
    return {
      'firebaseId': id,
      'email': email,
      'name': name,
      'phone': phone ?? 'Unknown',
      'createdAt': createdAt.toIso8601String(),
      'profileImage': photoUrl,
      'authProvider': authProvider,
      'isActive': true,
    };
  }
}
