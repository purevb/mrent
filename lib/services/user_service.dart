import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mrent/model/user.dart';

class UserRemoteService {
  Future<UserModel?> getUser(String id) async {
    var client = http.Client();
    var uri = Uri.parse('http://10.0.2.2:3106/api/user/$id');
    try {
      var response = await client.get(uri);
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        return UserModel.fromJson(json);
      } else {
        print('Server error: ${response.statusCode}');
      }
    } catch (e) {
      print('Network error: $e');
    } finally {
      client.close();
    }
    return null;
  }
}
