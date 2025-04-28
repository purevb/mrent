import 'package:mrent/model/order_model.dart';

class RentedPropertiesModel {
  final String? hostId;
  final BookingModel? bookingId;
  final String? userId;

  RentedPropertiesModel({
    this.hostId,
    this.bookingId,
    this.userId,
  });

  RentedPropertiesModel.fromJson(Map<String, dynamic> json)
      : hostId = json['host_id'] as String?,
        bookingId = (json['booking_id'] as Map<String, dynamic>?) != null
            ? BookingModel.fromJson(json['booking_id'] as Map<String, dynamic>)
            : null,
        userId = json['user_id'] as String?;

  Map<String, dynamic> toJson() => {
        'host_id': hostId,
        'booking_id': bookingId?.toJson(),
        'user_id': userId,
      };
}
