/*
 * *
 *  * dio.dart - MoMovie
 *  * Created by Rahmat Trinanda (rahmat3nanda@gmail.com) on 07/13/2024, 18:22
 *  * Copyright (c) 2024 . All rights reserved.
 *  * Last modified 07/13/2024, 18:21
 *
 */

import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart' as d;
import 'package:momovie/common/configs.dart';
import 'package:momovie/common/constants.dart';
import 'package:momovie/model/app/singleton_model.dart';

class Dio {
  late d.Dio _dio;

  late SingletonModel _model;

  Dio({Map<String, dynamic>? headers}) {
    _dio = d.Dio();
    _model = SingletonModel.shared;
    _dio.options = d.BaseOptions(
      baseUrl: AppConfig.shared.baseUrlApi,
      headers: headers ??
          {
            "Accept": "application/json",
            "Content-Type": "application/json",
            if (_model.token != null) "Authorization": "Bearer ${_model.token}",
          },
    );
    _dio.interceptors.add(
      d.InterceptorsWrapper(
          onRequest: (d.RequestOptions o, d.RequestInterceptorHandler h) {
        AppLog.print("URL request : ${o.uri}");
        return h.next(o);
      }, onResponse: (d.Response r, d.ResponseInterceptorHandler h) {
        return h.next(r);
      }, onError: (d.DioException e, d.ErrorInterceptorHandler h) async {
        AppLog.print("URL error : ${e.requestOptions.path}");
        AppLog.print("Message error : ${e.message}");
        AppLog.print("Response error : ${e.response}");

        return h.next(e);
      }),
    );
  }

  Future post({
    required String url,
    dynamic body,
    Map<String, dynamic>? param,
  }) async {
    try {
      return await _dio.post(
        url,
        queryParameters: param,
        data: body,
      );
    } on TimeoutException catch (e) {
      return Future.error(e);
    } on SocketException catch (e) {
      return Future.error(e);
    } on d.DioException catch (e) {
      return Future.error(e);
    }
  }

  Future patch({
    required String url,
    required dynamic body,
    Map<String, dynamic>? param,
  }) async {
    try {
      return await _dio.patch(
        url,
        queryParameters: param,
        data: body,
      );
    } on TimeoutException catch (e) {
      return Future.error(e);
    } on SocketException catch (e) {
      return Future.error(e);
    } on d.DioException catch (e) {
      return Future.error(e);
    }
  }

  Future get({
    required String url,
    Map<String, dynamic>? param,
  }) async {
    try {
      return await _dio.get(
        url,
        queryParameters: param,
      );
    } on TimeoutException catch (e) {
      return Future.error(e);
    } on SocketException catch (e) {
      return Future.error(e);
    } on d.DioException catch (e) {
      return Future.error(e);
    }
  }

  Future delete({
    required String url,
    dynamic body,
    Map<String, dynamic>? param,
  }) async {
    try {
      return await _dio.delete(
        url,
        queryParameters: param,
        data: body,
      );
    } on TimeoutException catch (e) {
      return Future.error(e);
    } on SocketException catch (e) {
      return Future.error(e);
    } on d.DioException catch (e) {
      return Future.error(e);
    }
  }
}
