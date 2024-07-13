/*
 * *
 *  * request.dart - Siadin Mobile
 *  * Created by Rahmat Trinanda (rahmat3nanda@gmail.com) on 07/11/2024, 10:38
 *  * Copyright (c) 2024 . All rights reserved.
 *  * Last modified 07/11/2024, 10:38
 *
 */

import 'package:dio/dio.dart' as dio;
import 'package:momovie/data/repo.dart';

late Repo _repo;

class Request {
  late RequestGenre genre;

  Request() {
    _repo = Repo();
    genre = RequestGenre();
  }
}

class RequestGenre {
  Future<dio.Response> movie() {
    return _repo.genre.movie();
  }
}
