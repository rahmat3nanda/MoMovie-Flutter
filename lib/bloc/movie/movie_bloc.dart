/*
 * *
 *  * movie_bloc.dart - MoMovie
 *  * Created by Rahmat Trinanda (rahmat3nanda@gmail.com) on 07/13/2024, 18:27
 *  * Copyright (c) 2024 . All rights reserved.
 *  * Last modified 07/13/2024, 14:55
 *
 */

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:momovie/bloc/movie/movie_event.dart';
import 'package:momovie/bloc/movie/movie_state.dart';
import 'package:momovie/common/constants.dart';
import 'package:momovie/data/request.dart';
import 'package:momovie/model/app/singleton_model.dart';
import 'package:momovie/model/movie_model.dart';
import 'package:momovie/model/video_model.dart';
import 'package:momovie/tool/helper.dart';

export 'package:momovie/bloc/movie/movie_event.dart';
export 'package:momovie/bloc/movie/movie_state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  final Helper _helper = Helper();

  MovieBloc(MovieInitialState super.initialState) {
    on<MovieNowPlayingEvent>(_nowPlaying);
    on<MoviePopularEvent>(_popular);
    on<MovieTopRatedEvent>(_topRated);
    on<MovieUpcomingEvent>(_upcoming);
    on<MovieSearchEvent>(_search);
    on<MovieVideosEvent>(_videos);
    on<MovieRecommendationsEvent>(_recommendations);
    on<MovieSimilarEvent>(_similar);
  }

  void _nowPlaying(
      MovieNowPlayingEvent event, Emitter<MovieState> state) async {
    state(MovieInitialState());
    try {
      Response res = await Request().movie.nowPlaying(
            page: event.page,
            language: event.language,
            region: event.region,
          );
      List<MovieModel> data = List<MovieModel>.from(
          res.data["results"].map((x) => MovieModel.fromJson(x)));
      if (event.page == 1) {
        SingletonModel.shared.movie.nowPlaying = data;
      } else {
        SingletonModel.shared.movie.nowPlaying!.addAll(data);
      }
      AppLog.print(jsonEncode(data));
      state(const MovieNowPlayingSuccessState());
    } catch (e) {
      state(
        MovieNowPlayingFailedState(_helper.dioErrorHandler(e)),
      );
    }
  }

  void _popular(MoviePopularEvent event, Emitter<MovieState> state) async {
    state(MovieInitialState());
    try {
      Response res = await Request().movie.popular(
            page: event.page,
            language: event.language,
            region: event.region,
          );
      List<MovieModel> data = List<MovieModel>.from(
          res.data["results"].map((x) => MovieModel.fromJson(x)));
      if (event.page == 1) {
        SingletonModel.shared.movie.popular = data;
      } else {
        SingletonModel.shared.movie.popular!.addAll(data);
      }
      AppLog.print(jsonEncode(data));
      state(const MoviePopularSuccessState());
    } catch (e) {
      state(
        MoviePopularFailedState(_helper.dioErrorHandler(e)),
      );
    }
  }

  void _topRated(MovieTopRatedEvent event, Emitter<MovieState> state) async {
    state(MovieInitialState());
    try {
      Response res = await Request().movie.topRated(
            page: event.page,
            language: event.language,
            region: event.region,
          );
      List<MovieModel> data = List<MovieModel>.from(
          res.data["results"].map((x) => MovieModel.fromJson(x)));
      if (event.page == 1) {
        SingletonModel.shared.movie.topRated = data;
      } else {
        SingletonModel.shared.movie.topRated!.addAll(data);
      }
      AppLog.print(jsonEncode(data));
      state(const MovieTopRatedSuccessState());
    } catch (e) {
      state(
        MovieTopRatedFailedState(_helper.dioErrorHandler(e)),
      );
    }
  }

  void _upcoming(MovieUpcomingEvent event, Emitter<MovieState> state) async {
    state(MovieInitialState());
    try {
      Response res = await Request().movie.upcoming(
            page: event.page,
            language: event.language,
            region: event.region,
          );
      List<MovieModel> data = List<MovieModel>.from(
          res.data["results"].map((x) => MovieModel.fromJson(x)));
      if (event.page == 1) {
        SingletonModel.shared.movie.upcoming = data;
      } else {
        SingletonModel.shared.movie.upcoming!.addAll(data);
      }
      AppLog.print(jsonEncode(data));
      state(const MovieUpcomingSuccessState());
    } catch (e) {
      state(
        MovieUpcomingFailedState(_helper.dioErrorHandler(e)),
      );
    }
  }

  void _search(MovieSearchEvent event, Emitter<MovieState> state) async {
    state(MovieInitialState());
    try {
      Response res = await Request().movie.search(
            page: event.page,
            query: event.query,
            language: event.language,
            region: event.region,
            includeAdult: event.includeAdult,
            primaryReleaseYear: event.primaryReleaseYear,
            year: event.year,
          );
      List<MovieModel> data = List<MovieModel>.from(
          res.data["results"].map((x) => MovieModel.fromJson(x)));
      AppLog.print(jsonEncode(data));
      state(MovieSearchSuccessState(data: data, page: event.page));
    } catch (e) {
      state(
        MovieSearchFailedState(_helper.dioErrorHandler(e)),
      );
    }
  }

  void _videos(MovieVideosEvent event, Emitter<MovieState> state) async {
    state(MovieInitialState());
    try {
      Response res = await Request().movie.videos(
            id: event.id,
            language: event.language,
          );
      List<VideoModel> data = List<VideoModel>.from(
          res.data["results"].map((x) => MovieModel.fromJson(x)));
      AppLog.print(jsonEncode(data));
      state(MovieVideosSuccessState(data));
    } catch (e) {
      state(
        MovieVideosFailedState(_helper.dioErrorHandler(e)),
      );
    }
  }

  void _recommendations(
    MovieRecommendationsEvent event,
    Emitter<MovieState> state,
  ) async {
    state(MovieInitialState());
    try {
      Response res = await Request().movie.recommendations(
            id: event.id,
            page: event.page,
            language: event.language,
          );
      List<MovieModel> data = List<MovieModel>.from(
          res.data["results"].map((x) => MovieModel.fromJson(x)));
      AppLog.print(jsonEncode(data));
      state(MovieRecommendationsSuccessState(data: data, page: event.page));
    } catch (e) {
      state(
        MovieVideosFailedState(_helper.dioErrorHandler(e)),
      );
    }
  }

  void _similar(MovieSimilarEvent event, Emitter<MovieState> state) async {
    state(MovieInitialState());
    try {
      Response res = await Request().movie.similar(
            id: event.id,
            page: event.page,
            language: event.language,
          );
      List<MovieModel> data = List<MovieModel>.from(
          res.data["results"].map((x) => MovieModel.fromJson(x)));
      AppLog.print(jsonEncode(data));
      state(MovieSimilarSuccessState(data: data, page: event.page));
    } catch (e) {
      state(
        MovieSimilarFailedState(_helper.dioErrorHandler(e)),
      );
    }
  }
}
