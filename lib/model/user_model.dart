import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final DateTime createdAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.createdAt,
  });

  // Factory constructor to create a User from a Firestore document
  factory User.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return User(
      id: doc.id, // The document ID is the user ID
      name: data['name'] ?? '',
      email: data['gmail'] ??
          '', // Assuming 'gmail' is the field name in Firestore
      phone: data['phone'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  // Convert the User object to a Map (optional, useful for Firestore writes)
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'gmail': email,
      'phone': phone,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
