import 'dart:io';

import 'package:bookmark/core/api_helper/api_urls_params.dart';
import 'package:bookmark/core/api_helper/app_exception.dart';
import 'package:bookmark/core/api_helper/dio_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ApiService {
  Dio _dio;

  Future<dynamic> getHttp() async {
    Response response;
    try {
      final url = '${ApiUrlsAndParams.baseUrl}';
      _dio = DioHelper.getDio(url);

      response = await _dio.get(
        url,
      );
    } on DioError catch (e) {
      if (e is SocketException) {}
      throw SocketException();
    }

    return _returnResponse(showProgress: false, response: response);
  }

  dynamic _returnResponse(
      {Response response,
      String url,
      int from,
      BuildContext context,
      showProgress,
      Map<String, dynamic> map,
      Map<String, String> staticMap}) {
    switch (response.statusCode) {
      case 200:
        var responseJson = response.data;
        return responseJson != null ? responseJson : '';
      case 201:
        var responseJson = response.data;
        return responseJson != null ? responseJson : '';
      default:
        throw BadRequestException(response.toString());
    }
  }
}
