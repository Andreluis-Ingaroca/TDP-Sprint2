import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:lexp/core/res/app.dart';
import 'package:lexp/services/shared_service.dart';

class RestProvider {
  final Dio _dio = Dio();
  final String _urlAPI = "http://192.168.100.28:8888/lxp-api";
  SharedService sharedServ = SharedService();

  Future<Response> callMethod(String method, [dynamic dataIn]) async {
    dataIn = dataIn ?? {};
    try {
      //headers
      final Map<String, dynamic> headers = {
        "Content-Type": "application/json",
      };
      //authentication bearer
      final String? token = await sharedServ.getKey("sessionKey");
      if (token != "" && token != null) {
        headers["Authorization"] = "Bearer $token";
      }
      //timeout in seconds
      int timeout = AppConstants.timeout;
      //Params
      final String params = jsonEncode(dataIn);
      //options
      final Options options = Options(
        headers: headers,
        receiveTimeout: timeout * 1000,
        sendTimeout: timeout * 1000,
      );
      //request
      final Response response = await _dio.post(
        "$_urlAPI$method",
        data: params,
        options: options,
      );
      if (response.data["responseCode"] == '0') {
        throw Exception(response.data["responseMessage"]);
      }
      return response;
    } on DioError catch (e) {
      String errorMsg;
      if (e.response != null) {
        int statusCode = e.response!.statusCode!;
        String body = e.response!.toString();
        errorMsg = "Error $statusCode: $body";
      } else {
        errorMsg = e.message;
      }
      throw errorMsg;
    }
  }
}
