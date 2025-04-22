import 'package:mrent/model/mongo_user_model.dart';
import 'package:mrent/model/property_model.dart';

class OrderModel {
  final String? id;
  final PropertyModel? propertyId;
  final MongoUserModel? userId;
  final String? hostId;
  final String? additionalRequest;
  final String? checkinDate;
  final String? checkoutDate;
  final int? totalPrice;
  final int? v;

  OrderModel({
    this.id,
    this.propertyId,
    this.userId,
    this.hostId,
    this.additionalRequest,
    this.checkinDate,
    this.checkoutDate,
    this.totalPrice,
    this.v,
  });

  OrderModel.fromJson(Map<String, dynamic> json)
      : id = json['_id'] as String?,
        propertyId = (json['property_id'] as Map<String, dynamic>?) != null
            ? PropertyModel.fromJson(
                json['property_id'] as Map<String, dynamic>)
            : null,
        userId = (json['user_id'] as Map<String, dynamic>?) != null
            ? MongoUserModel.fromJson(json['user_id'] as Map<String, dynamic>)
            : null,
        hostId = json['host_id'] as String?,
        additionalRequest = json['additional_request'] as String?,
        checkinDate = json['checkin_date'] as String?,
        checkoutDate = json['checkout_date'] as String?,
        totalPrice = json['total_price'] as int?,
        v = json['__v'] as int?;

  Map<String, dynamic> toJson() => {
        '_id': id,
        'property_id': propertyId?.toJson(),
        'user_id': userId?.toJson(),
        'host_id': hostId,
        'additional_request': additionalRequest,
        'checkin_date': checkinDate,
        'checkout_date': checkoutDate,
        'total_price': totalPrice,
        '__v': v
      };
}
