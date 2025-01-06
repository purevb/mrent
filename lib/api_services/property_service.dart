import 'dart:convert';
import 'dart:developer';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:mrent/model/properties.dart';

class PropertyService {
  Future<List<PropertyData>> getSurvey() async {
    var client = http.Client();
    var uri = Uri.parse('http://localhost:3106/api/properties/');

    // http://10.0.2.2:3106/api/properties

    try {
      var response = await client.get(uri);
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        var propertiesList = jsonResponse['property'] as List;

        return propertiesList
            .map((property) =>
                PropertyData.fromJson(property as Map<String, dynamic>))
            .toList();
      } else {
        log('Server error. Status code: ${response.statusCode}');
        log('Response body: ${response.body}');
      }
    } catch (e) {
      log('Network error: $e');
    } finally {
      client.close();
    }

    return [];
  }

  Future<PropertyData?> searchFavorite(String id) async {
    var client = http.Client();
    var uri = Uri.parse('http://localhost:3106/api/properties/$id');
    //    http:10.0.2.2:3106/api/properties/$id');

    try {
      var response = await client.get(uri);
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);

        // Assuming the `property` key contains a single object
        var propertyJson = jsonResponse['property'] as Map<String, dynamic>;

        return PropertyData.fromJson(propertyJson);
      } else {
        log('Server error. Status code: ${response.statusCode}');
        log('Response body: ${response.body}');
      }
    } catch (e) {
      log('Network error: $e');
    } finally {
      client.close();
    }

    // Return null if an error occurred
    return null;
  }
}
