/*
 * *
 *  * API.dart - MoMovie
 *  * Created by Rahmat Trinanda (rahmat3nanda@gmail.com) on 07/13/2024, 18:19
 *  * Copyright (c) 2024 . All rights reserved.
 *  * Last modified 07/13/2024, 14:52
 *
 */

class API {
  APIGenre genre = APIGenre();
  APIMovie movie = APIMovie();
}

class APIGenre {
  final String movie = "genre/movie/list";
}

class APIMovie {
  final String nowPlaying = "movie/now_playing";
  final String popular = "movie/popular";
  final String topRated = "movie/top_rated";
  final String upcoming = "movie/upcoming";
  final String search = "search/movie";
   String videos(int id) => "movie/$id/videos";
   String recommendations(int id) => "movie/$id/recommendations";
   String similar(int id) => "movie/$id/similar";
}
