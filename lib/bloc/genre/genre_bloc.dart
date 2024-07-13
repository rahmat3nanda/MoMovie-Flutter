/*
 * *
 *  * genre_bloc.dart - MoMovie
 *  * Created by Rahmat Trinanda (rahmat3nanda@gmail.com) on 07/13/2024, 18:27
 *  * Copyright (c) 2024 . All rights reserved.
 *  * Last modified 07/13/2024, 14:55
 *
 */

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:momovie/bloc/genre/genre_event.dart';
import 'package:momovie/bloc/genre/genre_state.dart';
import 'package:momovie/common/constants.dart';
import 'package:momovie/data/request.dart';
import 'package:momovie/model/genre_model.dart';
import 'package:momovie/tool/helper.dart';

export 'package:momovie/bloc/genre/genre_event.dart';
export 'package:momovie/bloc/genre/genre_state.dart';

class GenreBloc extends Bloc<GenreEvent, GenreState> {
  final Helper _helper = Helper();

  GenreBloc(GenreInitialState super.initialState) {
    on<GenreMovieEvent>(_movie);
  }

  void _movie(GenreMovieEvent event, Emitter<GenreState> state) async {
    state(GenreInitialState());
    try {
      Response res = await Request().genre.movie();
      List<GenreModel> data = List<GenreModel>.from(
          res.data["genres"].map((x) => GenreModel.fromJson(x)));
      AppLog.print(jsonEncode(data));
      state(GenreMovieSuccessState(data));
    } catch (e) {
      state(
        GenreMovieFailedState(_helper.dioErrorHandler(e)),
      );
    }
  }
}
