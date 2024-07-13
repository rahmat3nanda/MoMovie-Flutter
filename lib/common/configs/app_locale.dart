/*
 * *
 *  * app_locale.dart - MoMovie
 *  * Created by Rahmat Trinanda (rahmat3nanda@gmail.com) on 07/13/2024, 17:59
 *  * Copyright (c) 2024 . All rights reserved.
 *  * Last modified 07/04/2023, 21:07
 *
 */

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class AppLocale {
  static AppLocale? _config;

  factory AppLocale() => _config ??= AppLocale._internal();

  AppLocale._internal();

  static AppLocale get shared => _config ??= AppLocale._internal();

  List<LocalizationsDelegate> delegates = [
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  List<Locale> supports = [
    const Locale('en'),
    const Locale('id'),
  ];
}
