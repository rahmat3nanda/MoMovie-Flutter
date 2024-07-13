/*
 * *
 *  * main.dart - MoMovie
 *  * Created by Rahmat Trinanda (rahmat3nanda@gmail.com) on 07/13/2024, 16:09
 *  * Copyright (c) 2024 . All rights reserved.
 *  * Last modified 07/13/2024, 16:08
 *
 */

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:momovie/app.dart';
import 'package:momovie/bloc/observer.dart';
import 'package:momovie/common/configs/app_config.dart';
import 'package:momovie/common/constants.dart';
import 'package:momovie/model/app/app_version_model.dart';
import 'package:momovie/model/app/scheme_model.dart';
import 'package:momovie/model/app/singleton_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterError.onError = (errorDetails) {
    AppLog.print(errorDetails);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    AppLog.print(error);
    return true;
  };
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  AppLog.debugMode = false;
  AppConfig.shared.initialize(
    scheme: AppScheme.prod,
    baseUrlApi: "https://api.themoviedb.org/3/",
    baseUrlImage: "https://image.tmdb.org/t/p/w1280",
    version: AppVersionModel.empty(),
  );
  Bloc.observer = Observer();
  SingletonModel.shared.token =
      "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJhMTM5ZmJiNGE1ODIxMTdjNDRiMjljZjFhODUwYzI2YyIsIm5iZiI6MTcyMDg2MzEzMC43NzYyMjksInN1YiI6IjY2OTI0MjMyYWZlNDhhYTY1MzYzYTI5NiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.PcTEjQMH6gJAc6bKES-XdUBcIO9DpG6PgulBAWYuW54";
  runApp(const App());
}
