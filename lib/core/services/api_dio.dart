import 'package:dio/dio.dart';

class ApiDio {
  final Dio _dio;

  ApiDio()
      : _dio = Dio(
          BaseOptions(
            //'http://localhost:3106
            baseUrl: 'https://backend-for-diplom.vercel.app/',
            contentType: 'application/json',
          ),
        );
  Future<Response> get(String endpoint) async {
    try {
      final response = await _dio.get(endpoint);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> post(String endPoint, Map<String, dynamic> data) async {
    try {
      final response = await _dio.post(endPoint, data: data);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> putData(String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await _dio.put(endpoint, data: data);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> delete(String endPoint, Map<String, dynamic> data) async {
    try {
      return await _dio.delete(endPoint, data: data);
    } catch (e) {
      rethrow;
    }
  }
}
