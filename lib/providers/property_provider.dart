import 'package:flutter/material.dart';
import 'package:mrent/core/services/api.dart';
import 'package:mrent/model/mongo_user_model.dart';
import 'package:mrent/model/property_model.dart';

class PropertyProvider extends ChangeNotifier {
  Api api = Api();

  MongoUserModel? fbUser;
  MongoUserModel? get getUser => fbUser;

  void authenticatedUser(MongoUserModel? user) {
    fbUser = user;
    notifyListeners();
  }
}
