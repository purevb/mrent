import 'package:mrent/model/mongo_user_model.dart';
import 'package:mrent/model/order_model.dart';

class EarningsModel {
  final String? id;
  final BookingModel? bookingId;
  final MongoUserModel? userId;
  final String? createdAt;
  final String? updatedAt;

  EarningsModel({
    this.id,
    this.bookingId,
    this.userId,
    this.createdAt,
    this.updatedAt,
  });

  EarningsModel.fromJson(Map<String, dynamic> json)
      : id = json['_id'] as String?,
        bookingId = (json['booking_id'] as Map<String, dynamic>?) != null
            ? BookingModel.fromJson(json['booking_id'] as Map<String, dynamic>)
            : null,
        userId = (json['user_id'] as Map<String, dynamic>?) != null
            ? MongoUserModel.fromJson(json['user_id'] as Map<String, dynamic>)
            : null,
        createdAt = json['createdAt'] as String?,
        updatedAt = json['updatedAt'] as String?;

  Map<String, dynamic> toJson() => {
        '_id': id,
        'booking_id': bookingId?.toJson(),
        'user_id': userId,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };
}
