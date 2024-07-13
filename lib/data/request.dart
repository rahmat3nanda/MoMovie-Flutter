/*
 * *
 *  * request.dart - MoMovie
 *  * Created by Rahmat Trinanda (rahmat3nanda@gmail.com) on 07/13/2024, 18:27
 *  * Copyright (c) 2024 . All rights reserved.
 *  * Last modified 07/13/2024, 18:26
 *
 */

import 'package:dio/dio.dart' as dio;
import 'package:momovie/data/repo.dart';

late Repo _repo;

class Request {
  late RequestGenre genre;
  late RequestMovie movie;

  Request() {
    _repo = Repo();
    genre = RequestGenre();
    movie = RequestMovie();
  }
}

class RequestGenre {
  Future<dio.Response> movie() {
    return _repo.genre.movie();
  }
}

class RequestMovie {
  Future<dio.Response> nowPlaying({
    required int page,
    String language = "en-US",
    String region = "ID",
  }) {
    return _repo.movie.nowPlaying(
      param: {
        "page": page,
        "language": language,
        "region": region,
      },
    );
  }

  Future<dio.Response> popular({
    required int page,
    String language = "en-US",
    String region = "ID",
  }) {
    return _repo.movie.popular(
      param: {
        "page": page,
        "language": language,
        "region": region,
      },
    );
  }

  Future<dio.Response> topRated({
    required int page,
    String language = "en-US",
    String region = "ID",
  }) {
    return _repo.movie.topRated(
      param: {
        "page": page,
        "language": language,
        "region": region,
      },
    );
  }

  Future<dio.Response> upcoming({
    required int page,
    String language = "en-US",
    String region = "ID",
  }) {
    return _repo.movie.upcoming(
      param: {
        "page": page,
        "language": language,
        "region": region,
      },
    );
  }

  Future<dio.Response> search({
    required int page,
    required String query,
    bool includeAdult = false,
    String language = "en-US",
    String region = "ID",
    String? primaryReleaseYear,
    String? year,
  }) {
    return _repo.movie.search(
      param: {
        "page": page,
        "query": query,
        "include_adult": includeAdult,
        "language": language,
        "region": region,
        "primary_release_year": primaryReleaseYear,
        "year": year,
      },
    );
  }

  Future<dio.Response> videos({required int id, String language = "en-US"}) {
    return _repo.movie.videos(
      id: id,
      param: {"language": language},
    );
  }

  Future<dio.Response> recommendations({
    required int id,
    required int page,
    String language = "en-US",
  }) {
    return _repo.movie.recommendations(
      id: id,
      param: {
        "page": page,
        "language": language,
      },
    );
  }

  Future<dio.Response> similar({
    required int id,
    required int page,
    String language = "en-US",
  }) {
    return _repo.movie.similar(
      id: id,
      param: {
        "page": page,
        "language": language,
      },
    );
  }
}
