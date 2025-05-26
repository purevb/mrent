import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:mrent/core/services/api.dart';
import 'package:mrent/model/mongo_user_model.dart';
import 'package:mrent/model/property_model.dart';
import 'package:mrent/services/auth_service.dart';

class PropertyProvider extends ChangeNotifier {
  Api api = Api();
  AuthService authService = AuthService();
  List<String> favoritePropertyIds = [];
  List<PropertyModel> favoriteProperties = [];

  List<PropertyModel> get getUserfavoriteProperties => favoriteProperties;

  MongoUserModel? fbUser;
  MongoUserModel? get getUser => fbUser;

  void authenticatedUser(MongoUserModel? user) {
    fbUser = user;
    notifyListeners();
  }

  void addFavoriteProperties(List<PropertyModel> properties) {
    for (var property in properties) {
      if (!favoriteProperties.any((p) => p.id == property.id)) {
        favoriteProperties.add(property);
      }
    }
    notifyListeners();
  }

  void toggleFavorite(String userId, PropertyModel property) {
    final propertyId = property.id ?? "";
    if (propertyId.isEmpty) {
      log("Id null");
      return;
    }

    if (isExistProperty(property)) {
      api.deleteFavorites(userId, propertyId).then((res) {
        if (res == "200") {
          favoriteProperties.removeWhere((p) => p.id == propertyId);
          favoritePropertyIds.removeWhere((id) => id == propertyId);
          log("removed");
          notifyListeners();
        } else {
          log("aldaa: $res");
        }
      }).catchError((error) {
        log("$error");
      });
    } else {
      api.postFavorites(userId, propertyId).then((res) {
        if (res == "201") {
          favoriteProperties.add(property);
          favoritePropertyIds.add(propertyId);
          log("added");
          notifyListeners();
        } else {
          log("aldaa: $res");
        }
      }).catchError((error) {
        log("$error");
      });
    }
  }

  bool isExistProperty(PropertyModel property) {
    final exists = favoriteProperties.any((p) => p.id == property.id);
    return exists;
  }

  bool isPropertyIdFavorite(String propertyId) {
    return favoritePropertyIds.contains(propertyId) ||
        favoriteProperties.any((p) => p.id == propertyId);
  }

  Future<void> clearFavoriteProperties() async {
    favoriteProperties.clear();
    favoritePropertyIds.clear();
    fbUser = null;
    notifyListeners();
  }

  Future<dynamic> signOut(BuildContext context) async {
    await clearFavoriteProperties();
    // ignore: use_build_context_synchronously
    return await authService.signout(context);
  }
}
