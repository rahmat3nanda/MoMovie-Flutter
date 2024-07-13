/*
 * *
 *  * genre_model.dart - MoMovie
 *  * Created by Rahmat Trinanda (rahmat3nanda@gmail.com) on 07/13/2024, 18:30
 *  * Copyright (c) 2024 . All rights reserved.
 *  * Last modified 07/13/2024, 18:30
 *
 */

class GenreModel {
  final int? id;
  final String? name;

  GenreModel({
    this.id,
    this.name,
  });

  factory GenreModel.fromJson(Map<String, dynamic> json) => GenreModel(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
