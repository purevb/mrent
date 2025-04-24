import 'package:mrent/model/order_model.dart';
import 'package:mrent/model/property_model.dart';

class RentedPropertiesModel {
  final String? hostId;
  final OrderModel? booking;
  final String? userId;

  RentedPropertiesModel({
    this.hostId,
    this.booking,
    this.userId,
  });

  RentedPropertiesModel.fromJson(Map<String, dynamic> json)
      : hostId = json['host_id'] as String?,
        booking = (json['booking_id'] as Map<String, dynamic>?) != null
            ? OrderModel.fromJson(json['booking_id'] as Map<String, dynamic>)
            : null,
        userId = json['user_id'] as String?;

  Map<String, dynamic> toJson() =>
      {'host_id': hostId, 'booking_id': booking, 'user_id': userId};
}
