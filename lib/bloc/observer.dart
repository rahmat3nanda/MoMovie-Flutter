/*
 * *
 *  * observer.dart - MoMovie
 *  * Created by Rahmat Trinanda (rahmat3nanda@gmail.com) on 07/13/2024, 17:58
 *  * Copyright (c) 2024 . All rights reserved.
 *  * Last modified 04/27/2024, 20:42
 *
 */

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:momovie/common/constants.dart';

class Observer extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    AppLog.print("$bloc $event");
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    AppLog.print(transition);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    AppLog.print("$bloc $error");
    AppLog.print(stackTrace.toString());
    super.onError(bloc, error, stackTrace);
  }
}
