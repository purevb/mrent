import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:mrent/core/services/api_dio.dart';
import 'package:mrent/model/favorite_model.dart';
import 'package:mrent/model/mongo_user_model.dart';
import 'package:mrent/model/order_model.dart';
import 'package:mrent/model/property_model.dart';
import 'package:mrent/model/property_type.dart';
import 'package:mrent/model/province_model.dart';

class Api {
  final api = ApiDio();

  Future<List<PropertyModel>> getProperties() async {
    final res = await api.get("/api/properties");

    final List<dynamic> data = res.data;
    return data.map((json) {
      return PropertyModel.fromJson(json);
    }).toList();
  }

  Future<List<PropertyModel>> getUserProperties(String userId) async {
    final res = await api.get("/api/properties/user/$userId");
    final List<dynamic> data = res.data;
    return data.map((json) {
      return PropertyModel.fromJson(json);
    }).toList();
  }

  Future<List<PropertyType>> getPropertyTypes() async {
    try {
      final res = await api.get("/api/property_types");
      final List data = res.data;
      return data.map((e) => PropertyType.fromJson(e)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<FavoriteModel>> getFavorites(String userId) async {
    try {
      final res = await api.get("/api/favorites/user/$userId");
      final List data = res.data;
      return data.map((e) => FavoriteModel.fromJson(e)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<String> postFavorites(String userId, String propertyId) async {
    final response = await api.post(
      "/api/favorites",
      {
        "property_id": propertyId,
        "user_id": userId,
      },
    );
    log("${response.statusCode} post favorite");
    return response.statusCode.toString();
  }

  Future<String> deleteFavorites(String userId, String propertyId) async {
    final response = await api.delete(
      "/api/favorites",
      {
        "user_id": userId,
        "property_id": propertyId,
      },
    );
    return response.statusCode.toString();
  }

  Future<List<ProvinceModel>> getProvinces() async {
    final res = await api.get("/api/province");
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
      final res = await api.get("/api/users/firebase/$firebaseId");
      return MongoUserModel.fromJson(
        res.data,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<MongoUserModel> updateMongoUsersDetail(
    String mongoId, {
    String? userName,
    String? phoneNumber,
    String? userProfile,
  }) async {
    try {
      final Map<String, dynamic> updateData = {};

      if (userName != null && userName.isNotEmpty)
        updateData['name'] = userName;
      if (phoneNumber != null && phoneNumber.isNotEmpty)
        updateData['phone'] = phoneNumber;
      if (userProfile != null && userProfile.isNotEmpty)
        updateData['profileImage'] = userProfile;

      if (updateData.isEmpty) {
        throw Exception('No valid fields provided for update');
      }

      final res = await api.putData("/api/users/$mongoId", updateData);
      log("Update status: ${res.statusCode}");
      return MongoUserModel.fromJson(res.data);
    } on DioException catch (e) {
      log("DioError: ${e.response?.data}");
      rethrow;
    } catch (e) {
      log("Error: $e");
      rethrow;
    }
  }

  Future<int> postBookingRequest({
    required String propertyId,
    required String userId,
    required String hostId,
    required String additionalRequest,
    required DateTime checkInDate,
    required DateTime checkoutDate,
    required int totalPrice,
  }) async {
    try {
      final response = await api.post("/api/bookings", {
        "property_id": propertyId,
        "user_id": userId,
        "host_id": hostId,
        "additional_request": additionalRequest,
        "checkin_date": checkInDate.toIso8601String(),
        "checkout_date": checkoutDate.toIso8601String(),
        "total_price": totalPrice,
      });

      if (response.statusCode == 201) {
        log("Booking successful: ${response.data}");
      } else {
        log("Failed to book: ${response.statusCode}");
      }
      return response.statusCode!.toInt();
    } catch (e) {
      log("Error posting booking: $e");
      return 400;
    }
  }

  Future<List<OrderModel>> getHostsOrdersData(String hostId) async {
    final res = await api.get("/api/bookings/host/$hostId");
    final List data = res.data;
    return data.map((e) => OrderModel.fromJson(e)).toList();
  }

  Future<void> postSyncUserFromFirebase() async {
    await api.post("/sync-users", {});
  }

  Future<PropertyModel> updatePropertyData({
    required String propertyId,
    String? propertyTypeId,
    String? placeTypeId,
    String? nightlyPrice,
    String? propertyName,
    String? description,
    int? numGuests,
    int? numBeds,
    int? numBedrooms,
    int? numBathrooms,
    double? longtitude,
    double? lattitude,
    DateTime? startDate,
    DateTime? endDate,
    List<String>? images,
  }) async {
    try {
      final Map<String, dynamic> data = {};

      if (propertyTypeId != null) data['propertyTypeId'] = propertyTypeId;
      if (placeTypeId != null) data['placeTypeId'] = placeTypeId;

      if (nightlyPrice != null && nightlyPrice.isNotEmpty) {
        data['nightlyPrice'] = double.tryParse(nightlyPrice);
      }

      if (propertyName != null && propertyName.isNotEmpty) {
        data['propertyName'] = propertyName;
      }

      if (description != null && description.isNotEmpty) {
        data['description'] = description;
      }

      if (numGuests != null) data['numGuests'] = numGuests;
      if (numBeds != null) data['numBeds'] = numBeds;
      if (numBedrooms != null) data['numBedrooms'] = numBedrooms;
      if (numBathrooms != null) data['numBathrooms'] = numBathrooms;

      if (longtitude != null) data['longitude'] = longtitude;
      if (lattitude != null) data['latitude'] = lattitude;

      if (startDate != null) data['start_date'] = startDate.toIso8601String();
      if (endDate != null) data['end_date'] = endDate.toIso8601String();

      if (images != null && images.isNotEmpty) {
        data['images'] = images;
      }
      log("Sending update data: $data");

      final res = await api.putData("/api/properties/$propertyId", data);
      return PropertyModel.fromJson(res.data);
    } catch (e) {
      log("Error updating property: $e");
      if (e is DioException && e.response?.statusCode == 500) {
        log("Server error details: ${e.response?.data}");
        throw "Server error occurred. Please try again with fewer changes.";
      }
      rethrow;
    }
  }

  Future<void> postReview() async {}
}
