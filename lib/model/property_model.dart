import 'package:mrent/model/fb_user_model.dart';
import 'package:mrent/model/property_type.dart';
import 'package:mrent/model/province_model.dart';

class PropertyModel {
  final String? id;
  final ProvinceModel? placeTypeId;
  final PropertyType? propertyTypeId;
  final String? userId;
  final int? nightlyPrice;
  final String? propertyName;
  final int? numGuests;
  final int? numBeds;
  final int? numBedrooms;
  final int? numBathrooms;
  final int? isGuestFavourite;
  final String? description;
  final double? latitude;
  final double? longitude;
  final String? startDate;
  final String? endDate;
  final List<String>? images;
  final int? v;
  final String? createdAt;
  final String? updatedAt;

  PropertyModel({
    this.id,
    this.placeTypeId,
    this.propertyTypeId,
    this.userId,
    this.nightlyPrice,
    this.propertyName,
    this.numGuests,
    this.numBeds,
    this.numBedrooms,
    this.numBathrooms,
    this.isGuestFavourite,
    this.description,
    this.latitude,
    this.longitude,
    this.startDate,
    this.endDate,
    this.images,
    this.v,
    this.createdAt,
    this.updatedAt,
  });

  PropertyModel.fromJson(Map<String, dynamic> json)
      : id = json['_id'] as String?,
        placeTypeId = (json['placeTypeId'] as Map<String, dynamic>?) != null
            ? ProvinceModel.fromJson(
                json['placeTypeId'] as Map<String, dynamic>)
            : null,
        propertyTypeId =
            (json['propertyTypeId'] as Map<String, dynamic>?) != null
                ? PropertyType.fromJson(
                    json['propertyTypeId'] as Map<String, dynamic>)
                : null,
        userId = json['userId'] as String,
        nightlyPrice = json['nightlyPrice'] as int?,
        propertyName = json['propertyName'] as String?,
        numGuests = json['numGuests'] as int?,
        numBeds = json['numBeds'] as int?,
        numBedrooms = json['numBedrooms'] as int?,
        numBathrooms = json['numBathrooms'] as int?,
        isGuestFavourite = json['isGuestFavourite'] as int?,
        description = json['description'] as String?,
        latitude = json['latitude'] as double?,
        longitude = json['longitude'] as double?,
        startDate = json['start_date'] as String?,
        endDate = json['end_date'] as String?,
        images =
            (json['images'] as List?)?.map((dynamic e) => e as String).toList(),
        v = json['__v'] as int?,
        createdAt = json['createdAt'] as String?,
        updatedAt = json['updatedAt'] as String?;

  Map<String, dynamic> toJson() => {
        '_id': id,
        'placeType': placeTypeId?.toJson(),
        'propertyTypeId': propertyTypeId?.toJson(),
        'userId': userId,
        'nightlyPrice': nightlyPrice,
        'propertyName': propertyName,
        'numGuests': numGuests,
        'numBeds': numBeds,
        'numBedrooms': numBedrooms,
        'numBathrooms': numBathrooms,
        'isGuestFavourite': isGuestFavourite,
        'description': description,
        'latitude': latitude,
        'longitude': longitude,
        'start_date': startDate,
        'end_date': endDate,
        'images': images,
        '__v': v,
        'createdAt': createdAt,
        'updatedAt': updatedAt
      };
}
