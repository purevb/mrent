import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mrent/core/services/api.dart';
import 'package:mrent/model/average_rating_model.dart';
import 'package:mrent/model/earnings_model.dart';
import 'package:mrent/model/favorite_model.dart';
import 'package:mrent/model/mongo_user_model.dart';
import 'package:mrent/model/order_model.dart';
import 'package:mrent/model/payments_model.dart';
import 'package:mrent/model/property_model.dart';
import 'package:mrent/model/property_table_calendar.dart';
import 'package:mrent/model/property_type.dart';
import 'package:mrent/model/province_model.dart';
import 'package:mrent/model/rented_properties_model.dart';
import 'package:mrent/model/users_review_model.dart';

class DataController with ChangeNotifier {
  var api = Api();

  final ValueNotifier<List<PropertyModel>?> propertyDataNotifier =
      ValueNotifier(null);

  final ValueNotifier<List<PropertyModel>?> usePropertyDataNotifier =
      ValueNotifier(null);

  final ValueNotifier<List<PropertyType>?> propertyTypeNotifier =
      ValueNotifier(null);

  final ValueNotifier<List<ProvinceModel>?> proviceNotifier =
      ValueNotifier(null);

  final ValueNotifier<List<FavoriteModel>?> favoriteNotifier =
      ValueNotifier(null);

  final ValueNotifier<List<BookingModel>?> ordersNotifier = ValueNotifier(null);

  final ValueNotifier<MongoUserModel?> userNotifier =
      ValueNotifier<MongoUserModel?>(null);

  final ValueNotifier<AverageRatingModel?> propertyRatingNotifier =
      ValueNotifier(null);

  final ValueNotifier<List<UsersReviewModel>?> propertyReviewNotifier =
      ValueNotifier(null);

  ValueNotifier<List<RentedPropertiesModel>?> rentedPropertiesNotifier =
      ValueNotifier<List<RentedPropertiesModel>?>(null);

  final ValueNotifier<List<PropertyTableCalendar>?> tableDateDataNotifier =
      ValueNotifier(null);

  final ValueNotifier<List<EarningsModel>?> earningDataNotifier =
      ValueNotifier(null);

  final ValueNotifier<List<PaymentsModel>?> paymentDataNotifier =
      ValueNotifier(null);

  Future<void> getEarningDateData(String userId) async {
    try {
      var res = await api.getEarningData(userId);

      earningDataNotifier.value = res;
      notifyListeners();
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> getPaymentData(String userId) async {
    try {
      var res = await api.getPaymentData(userId);
      paymentDataNotifier.value = res;
      notifyListeners();
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> getTableDateData(String propertyId) async {
    try {
      var res = await api.getTableDateData(propertyId);
      tableDateDataNotifier.value = res;
      notifyListeners();
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> getRentedPropertiesData(String userId) async {
    try {
      var res = await api.getRentedProperties(userId);
      rentedPropertiesNotifier.value = res;
      notifyListeners();
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> getRatingData(String propertyId) async {
    try {
      var res = await api.getRatings(propertyId);
      propertyRatingNotifier.value = res;
      notifyListeners();
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> getReviewData(String propertyId) async {
    try {
      var res = await api.getReviews(propertyId);
      propertyReviewNotifier.value = res;
      notifyListeners();
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> getUserData(String userId) async {
    try {
      var res = await api.getMongoUser(userId);
      userNotifier.value = res;
      notifyListeners();
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> getOrderDatas(String hostId) async {
    try {
      var res = await api.getHostsOrdersData(hostId);
      ordersNotifier.value = res;
      notifyListeners();
    } catch (e) {
      log(e.toString());
    }
  }
  //getHostsOrdersData

  Future<void> getPropertyTypeDatas() async {
    try {
      var res = await api.getPropertyTypes();
      propertyTypeNotifier.value = res;
      notifyListeners();
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> getUserPropertiesData(String userId) async {
    try {
      var res = await api.getUserProperties(userId);
      usePropertyDataNotifier.value = res;
      notifyListeners();
    } catch (e) {
      log(e.toString());
    }
  }

//
  Future<void> getFavoritesDatas(String userId) async {
    try {
      var res = await api.getFavorites(userId);
      favoriteNotifier.value = res;
      notifyListeners();
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> getPropertiesData() async {
    try {
      var res = await api.getProperties();
      propertyDataNotifier.value = res;
      notifyListeners();
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> getProvinceData() async {
    try {
      var res = await api.getProvinces();
      proviceNotifier.value = res;
      notifyListeners();
    } catch (e) {
      log(e.toString());
    }
  }
}
