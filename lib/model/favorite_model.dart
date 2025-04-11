import 'package:dio/src/response.dart';

class FavoriteModel {
  final String? propertyId;
  final String? userId;

  FavoriteModel({
    this.propertyId,
    this.userId,
  });

  FavoriteModel.fromJson(Map<String, dynamic> json)
      : propertyId = json['property_id'] as String?,
        userId = json['user_id'] as String?;

  Map<String, dynamic> toJson(Response res) =>
      {'property_id': propertyId, 'user_id': userId};
}
