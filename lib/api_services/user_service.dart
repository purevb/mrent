import 'dart:convert';
import 'dart:developer';

// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:mrent/model/user.dart';

class UserRemoteService {
  Future<UserModel?> getUser(String id) async {
    var client = http.Client();
    var uri = Uri.parse('http://localhost:3106/api/user/$id');
    // http://10.0.2.2:3106/api/user/$id');
    try {
      var response = await client.get(uri);
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        return UserModel.fromJson(json);
      } else {
        log('Server error: ${response.statusCode}');
      }
    } catch (e) {
      log('Network error: $e');
    } finally {
      client.close();
    }
    return null;
  }
}
