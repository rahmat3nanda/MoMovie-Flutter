/*
 * *
 *  * movie_event.dart - MoMovie
 *  * Created by Rahmat Trinanda (rahmat3nanda@gmail.com) on 07/13/2024, 19:36
 *  * Copyright (c) 2024 . All rights reserved.
 *  * Last modified 07/13/2024, 18:33
 *
 */

import 'package:equatable/equatable.dart';

abstract class MovieEvent extends Equatable {
  const MovieEvent();

  @override
  List<Object> get props => [];
}

class MovieNowPlayingEvent extends MovieEvent {
  final int page;
  final String language;
  final String region;

  const MovieNowPlayingEvent({
    required this.page,
    this.language = "en-US",
    this.region = "ID",
  });

  @override
  String toString() {
    return 'MovieNowPlayingEvent{page: $page, language: $language, region: $region}';
  }
}

class MoviePopularEvent extends MovieEvent {
  final int page;
  final String language;
  final String region;

  const MoviePopularEvent({
    required this.page,
    this.language = "en-US",
    this.region = "ID",
  });

  @override
  String toString() {
    return 'MoviePopularEvent{page: $page, language: $language, region: $region}';
  }
}

class MovieTopRatedEvent extends MovieEvent {
  final int page;
  final String language;
  final String region;

  const MovieTopRatedEvent({
    required this.page,
    this.language = "en-US",
    this.region = "ID",
  });

  @override
  String toString() {
    return 'MovieTopRatedEvent{page: $page, language: $language, region: $region}';
  }
}

class MovieUpcomingEvent extends MovieEvent {
  final int page;
  final String language;
  final String region;

  const MovieUpcomingEvent({
    required this.page,
    this.language = "en-US",
    this.region = "ID",
  });

  @override
  String toString() {
    return 'MovieUpcomingEvent{page: $page, language: $language, region: $region}';
  }
}

class MovieSearchEvent extends MovieEvent {
  final int page;
  final String query;
  final bool includeAdult;
  final String language;
  final String region;
  final String? primaryReleaseYear;
  final String? year;

  const MovieSearchEvent({
    required this.page,
    required this.query,
    this.includeAdult = false,
    this.language = "en-US",
    this.region = "ID",
    this.primaryReleaseYear,
    this.year,
  });

  @override
  String toString() {
    return 'MovieSearchEvent{page: $page, query: $query, includeAdult: $includeAdult, language: $language, region: $region, primaryReleaseYear: $primaryReleaseYear, year: $year}';
  }
}
