import 'dart:developer';

import 'package:dio/dio.dart';

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    log("onRequest URI => ${options.uri}");
    log("onRequest HEADER => ${options.headers}");
    log("onRequest REQUEST DATA => ${options.data}");
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    log("onResponse URI[${response.statusCode}] => ${response.requestOptions.uri}");
    log("onResponse REQUEST DATA => ${response.requestOptions.data}");
    log("onResponse DATA => ${response.data}");
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    log("onError URI[${err.response?.statusCode}] => ${err.response?.requestOptions.uri}");
    log("onError HEADER => ${err.response?.headers}");
    log("onError DATA => ${err.response?.data}");
    log("onError MESSAGE => ${err.message}");
    super.onError(err, handler);
  }
}