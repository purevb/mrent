import 'package:flutter/material.dart';
import 'package:mrent/model/property_model.dart';
import 'package:mrent/model/user_model.dart';

class PropertyProvider extends ChangeNotifier {
  bool _auth = false;
  List<PropertyModel> propertyData = [];
  List<PropertyModel> get userFavoriteProperties => propertyData;
  bool get isAuthenticated => _auth;
  void updateAuthStatus(User? user) {
    _auth = user?.id != null;
    notifyListeners();
  }

  // bool Authorized = false;
  void toggleFavorite(PropertyModel propertyDatas) {
    final isExist = propertyData.contains(propertyDatas);
    if (isExist) {
      propertyData.remove(propertyDatas);
    } else {
      propertyData.add(propertyDatas);
    }
    notifyListeners();
  }

  bool isExist(PropertyModel propertyDatas) {
    return propertyData.contains(propertyDatas);
  }
}
