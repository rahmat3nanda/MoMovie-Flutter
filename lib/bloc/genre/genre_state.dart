/*
 * *
 *  * genre_state.dart - MoMovie
 *  * Created by Rahmat Trinanda (rahmat3nanda@gmail.com) on 07/13/2024, 18:27
 *  * Copyright (c) 2024 . All rights reserved.
 *  * Last modified 07/13/2024, 14:55
 *
 */

import 'package:equatable/equatable.dart';
import 'package:momovie/model/genre_model.dart';
import 'package:momovie/model/response_model.dart';

abstract class GenreState extends Equatable {
  const GenreState();

  @override
  List<Object> get props => [];
}

class GenreInitialState extends GenreState {}

class GenreMovieSuccessState extends GenreState {
  final List<GenreModel> data;

  const GenreMovieSuccessState(this.data);
}

class GenreMovieFailedState extends GenreState {
  final ResponseModel data;

  const GenreMovieFailedState(this.data);
}
