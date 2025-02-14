//
// import 'package:dio/dio.dart';
//
// class DioHelper {
//   static Dio? dio;
//
//   static init() {
//     dio = Dio(
//       BaseOptions(
//         baseUrl: 'http://192.168.1.22:8080/', //Change to your IP address but make sure to use the same port
//         receiveDataWhenStatusError: true,
//         connectTimeout: const Duration(seconds: 30),
//         receiveTimeout: const Duration(seconds: 30),
//       ),
//     );
//   }
//
//   static Future<Response> getData({
//     required String url,
//     Map<String, dynamic>? query,
//     String lang = 'en',
//     String? token,
//   }) async {
//     dio!.options.headers = {
//       'lang': lang,
//       'Content-Type': 'application/json',
//       'Authorization': token ?? '',
//     };
//
//     return await dio!.get(
//       url,
//       queryParameters: query,
//     );
//   }
//
//   static Future<Response> postData({
//     required String url,
//     required Map<String, dynamic> data,
//     Map<String, dynamic>? query,
//     String lang = 'en',
//     String? token,
//   }) async {
//     dio!.options.headers = {
//       'lang': lang,
//       'Content-Type': 'application/json',
//       'Authorization': token ?? '',
//     };
//
//     return await dio!.post(
//       url,
//       queryParameters: query,
//       data: data,
//     );
//   }
//
//   static Future<Response> putData({
//     required String url,
//     Map<String, dynamic>? data,
//     Map<String, dynamic>? query,
//     String lang = 'en',
//     String? token,
//   }) async {
//     dio!.options.headers = {
//       'lang': lang,
//       'Content-Type': 'application/json',
//       'Authorization': token ?? '',
//     };
//
//     return await dio!.put(
//       url,
//       queryParameters: query,
//       data: data,
//     );
//   }
// }
