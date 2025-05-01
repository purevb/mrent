import 'package:mrent/model/order_model.dart';

class EarningsModel {
  final BookingModel? bookingId;
  final String? userId;

  EarningsModel({
    this.bookingId,
    this.userId,
  });

  EarningsModel.fromJson(Map<String, dynamic> json)
      : bookingId = (json['booking_id'] as Map<String, dynamic>?) != null
            ? BookingModel.fromJson(json['booking_id'] as Map<String, dynamic>)
            : null,
        userId = json['user_id'] as String?;

  Map<String, dynamic> toJson() => {
        'booking_id': bookingId?.toJson(),
        'user_id': userId,
      };
}
