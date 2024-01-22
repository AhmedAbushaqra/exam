import 'package:dio/dio.dart';
import 'package:exams/constant/end_points.dart';
import 'package:flutter/cupertino.dart';
import '../constant/global_var.dart';

class DioHelper {
  static late Dio dio;

  static init() {
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        receiveDataWhenStatusError: true,
          connectTimeout: const Duration(minutes: 1), // 60 seconds
          receiveTimeout: const Duration(minutes: 1) // 60 seconds
      ),
    );
  }

  static Future<Response> getData({
    required String url,
    Map<String, dynamic>? query,
    String? token,
  }) async {
    dio.options.headers = {
      'Authorization':'Bearer ${prefs.getString('token')}',
      'Connection': 'application/json',
      'Accept': 'application/json'
      // 'Locale': 'en'
    };
    return await dio.get(
      url,
      queryParameters: query,
    );
  }

  static Future<Response> postData({
    required String url,
    Map<String, dynamic>? query,
    required Map<dynamic, dynamic> data,
    String? token,
  }) async {
    debugPrint(data.toString());
    return dio.post(
      url,
      queryParameters: query,
      data: data,
      options: Options(
          followRedirects: false,
          validateStatus: (status) {
            print("status code here${status}");
            return status! < 500;
          }),
    );
  }

  static Future<Response> postDataImage({
    required String url,
    Map<String, dynamic>? query,
    required Map<String, dynamic> data,
    String? token,
  }) async {
    debugPrint(data.toString());
    var formData = FormData.fromMap(data);
    dio.options.headers = {
      'Authorization':'Bearer ${prefs.getString('token')}',
      'Connection': 'application/json',
      'Accept': 'application/json'
    };
    return dio.post(
      url,
      queryParameters: query,
      data: formData,
      options: Options(
          followRedirects: false,
          validateStatus: (status) {
            print("status code here${status}");
            return status! < 500;
          }),
    );
  }
}


