import 'package:flutter/material.dart';
import 'package:mrent/core/services/api.dart';
import 'package:mrent/model/mongo_user_model.dart';
import 'package:mrent/model/property_model.dart';

class PropertyProvider extends ChangeNotifier {
  List<PropertyModel> propertyData = [];
  Api api = Api();
  List<PropertyModel> get userFavoriteProperties => propertyData;

  MongoUserModel? fbUser;
  MongoUserModel? get getUser => fbUser;

  void authenticatedUser(MongoUserModel? user) {
    fbUser = user;
    notifyListeners();
  }

  void toggleFavorite(PropertyModel propertyDatas) {
    final propertyExists = isFavorite(propertyDatas);
    if (propertyExists) {
      api.deleteFavorites(
        getUser!.id!,
        propertyDatas.id!,
      );
      propertyData.removeWhere((property) => property.id == propertyDatas.id);
    } else {
      api.postFavorites(
        getUser!.id!,
        propertyDatas.id!,
      );
      propertyData.add(propertyDatas);
    }
    notifyListeners();
  }

  void addAllFavoriteProperties(List<PropertyModel> favoriteProperty) {
    propertyData.addAll(favoriteProperty);
    notifyListeners();
  }

  bool isFavorite(PropertyModel propertyDatas) {
    return propertyData.any((property) => property.id == propertyDatas.id);
  }
}
