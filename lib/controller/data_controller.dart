import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mrent/core/services/api.dart';
import 'package:mrent/model/property_model.dart';
import 'package:mrent/model/property_type.dart';

class DataController with ChangeNotifier {
  var api = Api();
  final ValueNotifier<List<PropertyModel>?> propertyDataNotifier =
      ValueNotifier(null);
  final ValueNotifier<List<PropertyType>?> propertyTypeNotifier =
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

  Future<void> getPropertiesData() async {
    try {
      var res = await api.getProperties();

      propertyDataNotifier.value = res;
      notifyListeners();
    } catch (e) {
      log(e.toString());
    }
  }
}
