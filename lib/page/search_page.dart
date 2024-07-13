/*
 * *
 *  * search_page.dart - MoMovie
 *  * Created by Rahmat Trinanda (rahmat3nanda@gmail.com) on 07/14/2024, 01:13
 *  * Copyright (c) 2024 . All rights reserved.
 *  * Last modified 07/14/2024, 01:13
 *
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:momovie/bloc/movie/movie_bloc.dart';
import 'package:momovie/common/configs.dart';
import 'package:momovie/common/styles.dart';
import 'package:momovie/model/app/error_model.dart';
import 'package:momovie/model/app/singleton_model.dart';
import 'package:momovie/model/movie_model.dart';
import 'package:momovie/tool/helper.dart';
import 'package:momovie/widget/image_network_widget.dart';
import 'package:momovie/widget/reload_data_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SearchPage extends StatefulWidget {
  final String query;
  final Function(bool isLoading) showLoading;
  final Function(MovieModel) onSelect;

  const SearchPage({
    super.key,
    required this.query,
    required this.showLoading,
    required this.onSelect,
  });

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late MovieBloc _movieBloc;
  late Helper _helper;

  late RefreshController _cRefresh;
  List<MovieModel>? _data;
  ErrorModel? _error;
  String? _query;
  late int _page;

  @override
  void initState() {
    super.initState();
    SingletonModel.withContext(context);
    _movieBloc = BlocProvider.of<MovieBloc>(context);
    _helper = Helper();
    _cRefresh = RefreshController(initialRefresh: false);
    _page = 1;
  }

  void _search({int page = 1}) {
    _cRefresh.refreshCompleted();
    _error = null;
    if (_query?.isEmpty ?? true) {
      _data = null;
      return;
    }

    widget.showLoading(true);
    _movieBloc.add(MovieSearchEvent(page: page, query: _query!));
  }

  void _checkQuery() {
    if (widget.query == _query) {
      return;
    }

    _data = null;
    _page = 1;
    _query = widget.query;
    _search();
  }

  @override
  Widget build(BuildContext context) {
    _checkQuery();

    return BlocListener<MovieBloc, MovieState>(
      bloc: _movieBloc,
      listener: (c, s) {
        if (s is MovieSearchSuccessState) {
          SingletonModel.withContext(context);
          widget.showLoading(false);
          if (s.page == 1) {
            _data = s.data;
          } else {
            _data!.addAll(s.data);
            _page = s.page;
          }
        } else if (s is MovieSearchFailedState) {
          widget.showLoading(false);
          if (_data != null) {
            _helper.showToast("Gagal memuat data");
          } else {
            _error = ErrorModel(
              event: const MovieNowPlayingEvent(page: 1),
              error: s.data.message,
            );
          }
        }
      },
      child: BlocBuilder(
        bloc: _movieBloc,
        builder: (c, s) {
          return Scaffold(
            body: SafeArea(
              child: SmartRefresher(
                primary: true,
                physics: const ClampingScrollPhysics(),
                enablePullDown: _query?.isNotEmpty ?? false,
                enablePullUp: _query?.isNotEmpty ?? false,
                header: WaterDropMaterialHeader(
                  backgroundColor: AppColor.primary,
                  color: Colors.black,
                ),
                footer: CustomFooter(
                  builder: (context, status) => SpinKitWave(
                    color: AppColor.primary,
                    size: 32,
                  ),
                ),
                controller: _cRefresh,
                onRefresh: _search,
                onLoading: () => setState(() {
                  _movieBloc.add(MovieSearchEvent(
                    page: _page + 1,
                    query: _query!,
                  ));
                  _cRefresh.loadComplete();
                }),
                child: _stateView(),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _stateView() {
    if (_error != null) {
      return Center(
        child: ReloadDataWidget(
          error: _error?.error ?? "Gagal melakukan pencarian",
          onReload: _search,
        ),
      );
    }

    if (_data?.isEmpty ?? true) {
      if (_query?.isEmpty ?? true) {
        return Container();
      } else {
        return Center(
          child: Text("Tidak dapat menemukan '$_query'"),
        );
      }
    }

    return _mainView();
  }

  Widget _mainView() {
    double imageSize = 108.0;
    int gridCount = (MediaQuery.of(context).size.width - 152) ~/ imageSize;
    return GridView.builder(
      shrinkWrap: true,
      primary: false,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _data!.length,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: gridCount,
        crossAxisSpacing: 2.0,
        mainAxisSpacing: 2.0,
        childAspectRatio: 0.75,
      ),
      itemBuilder: (c, i) {
        MovieModel data = _data![i];
        return Card(
          color: AppColor.primary,
          child: InkWell(
            splashColor: AppColor.secondary,
            borderRadius: BorderRadius.circular(12),
            onTap: () => widget.onSelect(data),
            child: Stack(
              children: [
                ImageNetworkWidget(
                  url: "${AppConfig.shared.baseUrlImage}${data.posterPath}",
                  radius: BorderRadius.circular(12),
                  defaultImage: "",
                  clickable: false,
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(12),
                      ),
                    ),
                    child: Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data.title ?? "",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 18,
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    "${data.voteAverage?.toStringAsFixed(2) ?? 0}/10",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
