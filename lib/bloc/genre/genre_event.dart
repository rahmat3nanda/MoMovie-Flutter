/*
 * *
 *  * genre_event.dart - MoMovie
 *  * Created by Rahmat Trinanda (rahmat3nanda@gmail.com) on 07/13/2024, 19:35
 *  * Copyright (c) 2024 . All rights reserved.
 *  * Last modified 07/13/2024, 18:33
 *
 */

import 'package:equatable/equatable.dart';

abstract class GenreEvent extends Equatable {
  const GenreEvent();

  @override
  List<Object> get props => [];
}

class GenreMovieEvent extends GenreEvent {
  const GenreMovieEvent();

  @override
  String toString() {
    return "GenreMovieEvent{}";
  }
}
