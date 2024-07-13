

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
