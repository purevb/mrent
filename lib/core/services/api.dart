import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:mrent/core/services/api_dio.dart';
import 'package:mrent/model/favorite_model.dart';
import 'package:mrent/model/mongo_user_model.dart';
import 'package:mrent/model/property_model.dart';
import 'package:mrent/model/property_type.dart';
import 'package:mrent/model/province_model.dart';

class Api {
  final api = ApiDio();

  Future<List<PropertyModel>> getProperties() async {
    final res = await api.get("/properties");

    final List<dynamic> data = res.data;
    return data.map((json) {
      return PropertyModel.fromJson(json);
    }).toList();
  }

  Future<List<PropertyType>> getPropertyTypes() async {
    try {
      final res = await api.get("/property_types");
      final List data = res.data;
      return data.map((e) => PropertyType.fromJson(e)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<FavoriteModel>> getFavorites(String userId) async {
    try {
      final res = await api.get("/favorites/user/$userId");
      final List data = res.data;
      return data.map((e) => FavoriteModel.fromJson(e)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> postFavorites(String userId, String propertyId) async {
    final response = await api.post(
      "/favorites",
      {
        "property_id": propertyId,
        "user_id": userId,
      },
    );
  }

  Future<void> deleteFavorites(String userId, String propertyId) async {
    final response = await api.delete(
      "/favorites",
      {
        "user_id": userId,
        "property_id": propertyId,
      },
    );
  }

  Future<List<ProvinceModel>> getProvinces() async {
    final res = await api.get("/province");
    final List data = res.data;
    return data.map((json) => ProvinceModel.fromJson(json)).toList();
  }

  Future<void> postProperties({
    required String provinceId,
    required String propertyTypeId,
    required String userId,
    required int nightlyPrice,
    required String propertyName,
    required int numGuests,
    required int numBeds,
    required int numBedrooms,
    required int numBathrooms,
    int isGuestFavourite = 0,
    required String description,
    required double latitude,
    required double longitude,
    required DateTime startDate,
    required DateTime endDate,
    required List<String> images,
  }) async {
    try {
      if (images.isEmpty) {
        throw ArgumentError('At least one image is required');
      }
      if (startDate.isAfter(endDate)) {
        throw ArgumentError('Start date must be before end date');
      }

      final requestData = {
        "placeTypeId": provinceId,
        "propertyTypeId": propertyTypeId,
        "userId": userId,
        "nightlyPrice": nightlyPrice,
        "propertyName": propertyName.trim(),
        "numGuests": numGuests,
        "numBeds": numBeds,
        "numBedrooms": numBedrooms,
        "numBathrooms": numBathrooms,
        "isGuestFavourite": isGuestFavourite,
        "description": description.trim(),
        "latitude": latitude,
        "longitude": longitude,
        "start_date": startDate.toIso8601String(),
        "end_date": endDate.toIso8601String(),
        "images": images,
      };

      final response = await api.post(
        "/properties",
        requestData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Ajillsn"); // ✅ success
      } else {
        throw Exception('Failed to post property: ${response.statusCode}');
      }
    } on DioError catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Failed to post property: $e');
    }
  }

  Future<MongoUserModel> getMongoUser(String firebaseId) async {
    try {
      final res = await api.get("users/firebase/$firebaseId");
      return MongoUserModel.fromJson(
        res.data,
      );
    } catch (e) {
      rethrow;
    }
  }
}
