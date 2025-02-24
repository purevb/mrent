import 'package:flutter/material.dart';
import 'package:mrent/model/property_model.dart';

class PropertyProvider extends ChangeNotifier {
  final List<PropertyModel> _propertyData = [];
  List<PropertyModel>? get userFavoriteProperties => _propertyData;

  bool Authorized = false;
  void toggleFavorite(PropertyModel propertyData) {
    final isExist = _propertyData.contains(propertyData);
    if (isExist) {
      _propertyData.remove(propertyData);
    } else {
      _propertyData.add(propertyData);
    }
    notifyListeners();
  }

  bool isExist(PropertyModel id) {
    return _propertyData.contains(id);
  }
}
