import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mrent/core/services/api.dart';
import 'package:mrent/model/favorite_model.dart';
import 'package:mrent/model/property_model.dart';
import 'package:mrent/model/property_type.dart';
import 'package:mrent/model/province_model.dart';

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
