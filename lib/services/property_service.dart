import 'dart:convert'; // Needed for jsonDecode
import 'package:http/http.dart' as http;
import 'package:mrent/model/properties.dart';

class PropertyService {
  Future<List<PropertyData>> getSurvey() async {
    var client = http.Client();
    var uri = Uri.parse('http://10.0.2.2:3106/api/properties');

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
        print('Server error. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Network error: $e');
    } finally {
      client.close();
    }

    return [];
  }
}
