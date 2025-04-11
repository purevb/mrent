import 'package:mrent/core/services/api_dio.dart';
import 'package:mrent/model/favorite_model.dart';
import 'package:mrent/model/property_model.dart';
import 'package:mrent/model/property_type.dart';

class Api {
  final api = ApiDio();
  Future<List<PropertyModel>> getProperties() async {
    final res = await api.get("/properties");
    final List<dynamic> data = res.data;

    return data.map((json) => PropertyModel.fromJson(json)).toList();
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

  Future<List<FavoriteModel>> getFavorites() async {
    try {
      final res = await api.get("/favorites");
      final List data = res.data;
      return data.map((e) => FavoriteModel.fromJson(e)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<FavoriteModel> postFavorites(String userId, String propertyId) async {
    try {
      final res = await api.post(
        "/favorites",
        {"property_id": propertyId, "user_id": userId},
      );
      return FavoriteModel.fromJson(res.data);
    } catch (e) {
      rethrow;
    }
  }
}
