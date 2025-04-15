import 'package:mrent/model/property_model.dart';

class FavoriteModel {
  final String? id;
  final PropertyModel? propertyId;
  final String? userId;
  final int? v;

  FavoriteModel({
    this.id,
    this.propertyId,
    this.userId,
    this.v,
  });

  FavoriteModel.fromJson(Map<String, dynamic> json)
      : id = json['_id'] as String?,
        propertyId = (json['property_id'] as Map<String, dynamic>?) != null
            ? PropertyModel.fromJson(
                json['property_id'] as Map<String, dynamic>)
            : null,
        userId = json['user_id'] as String?,
        v = json['__v'] as int?;

  Map<String, dynamic> toJson() => {
        '_id': id,
        'property_id': propertyId?.toJson(),
        'user_id': userId,
        '__v': v
      };
}
