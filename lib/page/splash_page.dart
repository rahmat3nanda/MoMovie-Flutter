/*
 * *
 *  * splash_page.dart - MoMovie
 *  * Created by Rahmat Trinanda (rahmat3nanda@gmail.com) on 07/13/2024, 18:13
 *  * Copyright (c) 2024 . All rights reserved.
 *  * Last modified 07/13/2024, 18:13
 *
 */

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:momovie/common/constants.dart';
import 'package:momovie/model/app/singleton_model.dart';
import 'package:momovie/page/dev_page.dart';
import 'package:momovie/tool/helper.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late SingletonModel _model;
  late Helper _helper;

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _model = SingletonModel.withContext(context);
    _helper = Helper();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _setup();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _setup() async {
    await _controller.forward();
    _helper.moveToPage(_model.context!, page: const DevPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeTransition(
        opacity: CurvedAnimation(
          parent: _controller,
          curve: Curves.easeOut,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              AppIcon.momovie,
              width: 152,
            ),
            const SizedBox(height: 24, width: double.infinity),
            const Text(
              "MoMovie",
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
