import 'package:dio/dio.dart';

import 'api_constants.dart';


/*class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://freawork.com/freawork/index.php/UserController/', // Replace with your API
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  // Example GET call
  Future<List<dynamic>> fetchPosts() async {
    try {
      final response = await _dio.get('/posts');
      return response.data;
    } on DioException catch (e) {
      print('Dio Error: ${e.response?.statusCode} - ${e.message}');
      throw Exception('Failed to load posts');
    }
  }
}*/

class ApiClient {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: BaseURl.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  static Future<Response> post(String path, Map<String, dynamic> data) async {
    return await dio.post(path, data: data);
  }
  
}
