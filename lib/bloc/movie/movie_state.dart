/*
 * *
 *  * movie_state.dart - MoMovie
 *  * Created by Rahmat Trinanda (rahmat3nanda@gmail.com) on 07/13/2024, 18:27
 *  * Copyright (c) 2024 . All rights reserved.
 *  * Last modified 07/13/2024, 14:55
 *
 */

import 'package:equatable/equatable.dart';
import 'package:momovie/model/movie_model.dart';
import 'package:momovie/model/response_model.dart';

abstract class MovieState extends Equatable {
  const MovieState();

  @override
  List<Object> get props => [];
}

class MovieInitialState extends MovieState {}

class MovieNowPlayingSuccessState extends MovieState {
  const MovieNowPlayingSuccessState();
}

class MovieNowPlayingFailedState extends MovieState {
  final ResponseModel data;

  const MovieNowPlayingFailedState(this.data);
}

class MoviePopularSuccessState extends MovieState {
  const MoviePopularSuccessState();
}

class MoviePopularFailedState extends MovieState {
  final ResponseModel data;

  const MoviePopularFailedState(this.data);
}

class MovieTopRatedSuccessState extends MovieState {
  const MovieTopRatedSuccessState();
}

class MovieTopRatedFailedState extends MovieState {
  final ResponseModel data;

  const MovieTopRatedFailedState(this.data);
}

class MovieUpcomingSuccessState extends MovieState {
  const MovieUpcomingSuccessState();
}

class MovieUpcomingFailedState extends MovieState {
  final ResponseModel data;

  const MovieUpcomingFailedState(this.data);
}

class MovieSearchSuccessState extends MovieState {
  final List<MovieModel> data;

  const MovieSearchSuccessState(this.data);
}

class MovieSearchFailedState extends MovieState {
  final ResponseModel data;

  const MovieSearchFailedState(this.data);
}
