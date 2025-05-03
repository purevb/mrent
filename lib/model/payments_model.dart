import 'package:mrent/model/mongo_user_model.dart';
import 'package:mrent/model/order_model.dart';

class PaymentsModel {
  final BookingModel? bookingId;
  final MongoUserModel? userId;
  final String? createdAt;
  final String? updatedAt;

  PaymentsModel({
    this.bookingId,
    this.userId,
    this.createdAt,
    this.updatedAt,
  });

  PaymentsModel.fromJson(Map<String, dynamic> json)
      : bookingId = (json['booking_id'] as Map<String, dynamic>?) != null
            ? BookingModel.fromJson(json['booking_id'] as Map<String, dynamic>)
            : null,
        userId = (json['user_id'] as Map<String, dynamic>?) != null
            ? MongoUserModel.fromJson(json['user_id'] as Map<String, dynamic>)
            : null,
        createdAt = json['createdAt'] as String?,
        updatedAt = json['updatedAt'] as String?;

  Map<String, dynamic> toJson() => {
        'booking_id': bookingId?.toJson(),
        'user_id': userId,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };
}
