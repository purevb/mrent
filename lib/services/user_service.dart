// import 'package:http/http.dart' as http;
// import 'package:survey/models/user_model.dart';

// class UserRemoteService {
//   final String baseUrl = 'http://10.0.2.2:3106/api';

//   Future<List<User>?> getAllUsers() async {
//     var client = http.Client();
//     var uri = Uri.parse('$baseUrl/user');
//     try {
//       var response = await client.get(uri);
//       if (response.statusCode == 200) {
//         var json = response.body;
//         return userFromJson(json);
//       } else {
//         print('Server error: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Network error: $e');
//     } finally {
//       client.close();
//     }
//     return null;
//   }
// }