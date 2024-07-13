/*
 * *
 *  * home_page.dart - MoMovie
 *  * Created by Rahmat Trinanda (rahmat3nanda@gmail.com) on 07/13/2024, 18:52
 *  * Copyright (c) 2024 . All rights reserved.
 *  * Last modified 07/13/2024, 18:52
 *  
 */

import 'package:flutter/material.dart';
import 'package:momovie/common/styles.dart';
import 'package:momovie/model/app/singleton_model.dart';
import 'package:momovie/page/dev_page.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late SingletonModel _model;
  late RefreshController _cRefresh;

  @override
  void initState() {
    super.initState();
    _model = SingletonModel.withContext(context);
    _cRefresh = RefreshController(initialRefresh: false);
    _onRefresh();
  }

  void _onRefresh() {
    _cRefresh.refreshCompleted();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("MoMovie")),
      body: SafeArea(
        child: SmartRefresher(
          primary: true,
          physics: const ClampingScrollPhysics(),
          enablePullDown: true,
          enablePullUp: false,
          header: WaterDropMaterialHeader(
            backgroundColor: AppColor.primary,
            color: Colors.black,
          ),
          footer: CustomFooter(
            builder: (context, status) => Container(),
          ),
          controller: _cRefresh,
          onRefresh: _onRefresh,
          child: const DevPage(),
        ),
      ),
    );
  }
}
