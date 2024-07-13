/*
 * *
 *  * app_image.dart - MoMovie
 *  * Created by Rahmat Trinanda (rahmat3nanda@gmail.com) on 07/13/2024, 18:02
 *  * Copyright (c) 2024 . All rights reserved.
 *  * Last modified 07/11/2024, 10:27
 *
 */

const _path = "asset/images/";

class AppImage {
  static String momovie = "momovie.png".withImagePath();
  static String momovieFill = "momovie_fill.png".withImagePath();
}

extension AppImageString on String {
  String withImagePath({bool withPrefix = true}) {
    return "$_path${withPrefix ? "img_" : ""}$this";
  }
}
