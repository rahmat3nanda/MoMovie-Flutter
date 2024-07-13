/*
 * *
 *  * helper.dart - MoMovie
 *  * Created by Rahmat Trinanda (rahmat3nanda@gmail.com) on 07/13/2024, 18:32
 *  * Copyright (c) 2024 . All rights reserved.
 *  * Last modified 07/13/2024, 18:12
 *
 */

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:momovie/common/configs.dart';
import 'package:momovie/data/sp_data.dart';
import 'package:momovie/model/app/app_version_model.dart';
import 'package:momovie/model/app/singleton_model.dart';
import 'package:momovie/model/response_model.dart';
import 'package:momovie/model/store_version_model.dart';

class Helper {
  Future exitApp() {
    return Platform.isIOS ? exit(0) : SystemNavigator.pop(animated: true);
  }

  Future jumpToPage(BuildContext context, {required Widget page}) {
    return Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => page))
        .then((_) {
      SingletonModel.shared.context = context;
    });
  }

  Future moveToPage(BuildContext context, {required Widget page}) {
    return Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (_) => page));
  }

  Future jumpToPageWithoutAnim(BuildContext context, {required Widget page}) {
    return Navigator.of(context).push(PageRouteBuilder(
      pageBuilder: (c, a1, a2) => page,
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
    ));
  }

  Future moveToPageWithoutAnim(BuildContext context, {required Widget page}) {
    return Navigator.of(context).pushReplacement(PageRouteBuilder(
      pageBuilder: (c, a1, a2) => page,
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
    ));
  }

  void backToRootPage(BuildContext context) async {
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  bool isNumeric(String? s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  void showToast(
    String msg, {
    Toast? length,
    ToastGravity? gravity,
    Color? bgColor,
    Color? textColor,
    double? size,
  }) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: length ?? Toast.LENGTH_SHORT,
      gravity: gravity ?? ToastGravity.BOTTOM,
      backgroundColor: bgColor ?? Colors.black,
      textColor: textColor ?? Colors.white,
      fontSize: size ?? 16.0,
    );
  }

  ResponseModel dioErrorHandler(dynamic e) {
    ResponseModel response = ResponseModel(
      code: 0,
      success: false,
      message: "Unknown Error",
    );
    if (e == null) return response;
    if (e is DioException) {
      if (e.response == null) {
        response.message = "Error : ${e.message}";
        return response;
      }
      response.code = e.response?.statusCode ?? 0;
      response.message = e.response?.statusMessage ?? "Unknown Error";
      if (e.response?.data != null) {
        if (e.response?.data is Map) {
          Map<String, dynamic>? data = e.response?.data;
          if (data != null) {
            if (data["detail"] != null) {
              if (data["detail"] is String) {
                response.code = e.response?.statusCode ?? 0;
                response.message = data["detail"];
              } else {
                response = ResponseModel.fromJson(data);
              }
            } else {
              response = ResponseModel.fromJson(data);
            }
          }
        } else {
          response.message = "\n${e.response?.data}";
        }
      }
      return response;
    }
    if (e is String) {
      response.message = e;
    } else if (e is! String) {
      response.message = "$e";
    } else {
      response.message = "Unknown Error";
    }
    return response;
  }

  Future destroySession() async {
    await SPData.reset();
    SingletonModel.shared.destroy();
  }

  void copyClipboard(String data, {required Function() onCopied}) {
    Clipboard.setData(ClipboardData(text: data)).then((_) {
      onCopied();
    });
  }

  bool updateAvailable(StoreVersionModel storeVersion) {
    AppVersionModel appVersion = AppConfig.shared.version;
    String appVersionName = appVersion.name;
    int appVersionNumber = appVersion.number;

    String storeVersionName = storeVersion.versionName ?? "";
    int storeVersionNumber = storeVersion.versionNumber ?? 0;

    if (RegExp(r'\d+\.\d+\.\d+').hasMatch(storeVersionName)) {
      List<String> currentV = appVersionName.split(".");
      List<String> newV = storeVersionName.split(".");

      bool updateAvailByName = false;
      for (int i = 0; i <= 2; i++) {
        updateAvailByName = int.parse(newV[i]) > int.parse(currentV[i]);
        if (int.parse(newV[i]) != int.parse(currentV[i])) break;
      }

      if (updateAvailByName) {
        return updateAvailByName;
      }
    }

    if (storeVersionName == appVersionName) {
      return storeVersionNumber > appVersionNumber;
    }

    return false;
  }
}

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
            r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
            r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
            r"{0,253}[a-zA-Z0-9])?)*$")
        .hasMatch(this);
  }
}

extension StateHelper on State {
  String className() {
    return toString().split("#").first;
  }
}


extension StringHelper on String? {
  bool isNullOrEmpty() {
    return (this ?? "").isEmpty;
  }

  bool isNotNullOrEmpty() {
    return (this ?? "").isNotEmpty;
  }

  bool isChanged({required String? from, bool allowEmpty = false}) {
    if (this == from) {
      return false;
    }

    // String different
    if (allowEmpty) {
      return true;
    }

    // not allow empty
    if (isNullOrEmpty()) {
      return false;
    }

    // not null or empty
    return true;
  }
}

extension DateFormatter on DateFormat {
  String? tryFormat(DateTime? date) {
    if (date == null) {
      return null;
    }

    return format(date);
  }
}

extension FirstWhereExt<T> on List<T> {
  /// The first element satisfying [test], or `null` if there are none.
  T? firstWhereOrNull(bool Function(T element) test) {
    for (final element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}
