/*
 * *
 *  * home_page.dart - MoMovie
 *  * Created by Rahmat Trinanda (rahmat3nanda@gmail.com) on 07/13/2024, 18:52
 *  * Copyright (c) 2024 . All rights reserved.
 *  * Last modified 07/13/2024, 18:52
 *  
 */

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:momovie/bloc/movie/movie_bloc.dart';
import 'package:momovie/common/configs.dart';
import 'package:momovie/common/constants.dart';
import 'package:momovie/common/styles.dart';
import 'package:momovie/model/app/error_model.dart';
import 'package:momovie/model/app/singleton_model.dart';
import 'package:momovie/model/movie_model.dart';
import 'package:momovie/page/search_page.dart';
import 'package:momovie/tool/helper.dart';
import 'package:momovie/widget/image_network_widget.dart';
import 'package:momovie/widget/loading_overlay.dart';
import 'package:momovie/widget/preload_page_view.dart';
import 'package:momovie/widget/reload_data_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late SingletonModel _model;
  late MovieBloc _movieBloc;
  late Helper _helper;

  late RefreshController _cRefresh;
  late PreloadPageController _cNowPlaying;
  late TextEditingController _cSearch;
  late int _iNowPlaying;
  Timer? _timerNowPlaying;
  ErrorModel? _errorNowPlaying;
  ErrorModel? _errorPopular;
  ErrorModel? _errorTopRated;
  ErrorModel? _errorUpcoming;
  late String _qSearch;
  late int _pageNowPlaying;
  late int _pagePopular;
  late int _pageTopRated;
  late int _pageUpcoming;
  late bool _isLoadNowPlaying;
  late bool _isLoadPopular;
  late bool _isLoadTopRated;
  late bool _isLoadUpcoming;
  late bool _showSearch;
  late bool _showLoading;

  @override
  void initState() {
    super.initState();
    _model = SingletonModel.withContext(context);
    _movieBloc = BlocProvider.of<MovieBloc>(context);
    _helper = Helper();
    _cRefresh = RefreshController(initialRefresh: false);
    _cNowPlaying = PreloadPageController();
    _cSearch = TextEditingController();
    _qSearch = "";
    _iNowPlaying = 0;
    _pageNowPlaying = 1;
    _pagePopular = 1;
    _pageTopRated = 1;
    _pageUpcoming = 1;
    _isLoadNowPlaying = false;
    _isLoadPopular = false;
    _isLoadTopRated = false;
    _isLoadUpcoming = false;
    _showSearch = false;
    _showLoading = false;
    _onRefresh(fromCache: true);
    _setupAutoScroll();
  }

  void _setupAutoScroll() {
    _timerNowPlaying = Timer.periodic(const Duration(seconds: 5), (_) {
      if (_model.movie.nowPlaying?.isEmpty ?? true) {
        return;
      }
      int i = _iNowPlaying + 1;
      if (i >= _model.movie.nowPlaying!.length) {
        i = 0;
      }
      _cNowPlaying.animateToPage(
        i,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeIn,
      );
    });
  }

  void _onRefresh({bool fromCache = false}) {
    _getDataNowPlaying(fromCache: fromCache);
    _getDataPopular(fromCache: fromCache);
    _getDataTopRated(fromCache: fromCache);
    _getDataUpcoming(fromCache: fromCache);
    _cRefresh.refreshCompleted();
  }

  void _getDataNowPlaying({bool fromCache = false}) {
    _isLoadTopRated = true;
    _errorTopRated = null;

    if (fromCache && _model.movie.nowPlaying != null) {
      _isLoadTopRated = false;
      return;
    }

    _movieBloc.add(MovieNowPlayingEvent(page: _pageNowPlaying));
  }

  void _getDataPopular({bool fromCache = false}) {
    _isLoadPopular = true;
    _errorPopular = null;

    if (fromCache && _model.movie.popular != null) {
      _isLoadPopular = false;
      return;
    }

    _movieBloc.add(MoviePopularEvent(page: _pagePopular));
  }

  void _getDataTopRated({bool fromCache = false}) {
    _isLoadTopRated = true;
    _errorTopRated = null;

    if (fromCache && _model.movie.topRated != null) {
      _isLoadTopRated = false;
      return;
    }

    _movieBloc.add(MovieTopRatedEvent(page: _pageTopRated));
  }

  void _getDataUpcoming({bool fromCache = false}) {
    _isLoadUpcoming = true;
    _errorUpcoming = null;

    if (fromCache && _model.movie.upcoming != null) {
      _isLoadUpcoming = false;
      return;
    }

    _movieBloc.add(MovieUpcomingEvent(page: _pageUpcoming));
  }

  void _onSearch() {
    setState(() {
      _cSearch.text = _cSearch.text.trim();
      _qSearch = _cSearch.text;
    });
  }

  @override
  void dispose() {
    _timerNowPlaying?.cancel();
    _timerNowPlaying = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MovieBloc, MovieState>(
      bloc: _movieBloc,
      listener: (c, s) {
        if (s is MovieNowPlayingSuccessState) {
          _model = SingletonModel.withContext(context);
          _isLoadNowPlaying = false;
        } else if (s is MoviePopularSuccessState) {
          _model = SingletonModel.withContext(context);
          _isLoadPopular = false;
        } else if (s is MovieTopRatedSuccessState) {
          _model = SingletonModel.withContext(context);
          _isLoadTopRated = false;
        } else if (s is MovieUpcomingSuccessState) {
          _model = SingletonModel.withContext(context);
          _isLoadUpcoming = false;
        } else if (s is MovieNowPlayingFailedState) {
          _isLoadNowPlaying = false;
          if (_model.movie.nowPlaying != null) {
            _helper.showToast("Gagal memuat data now playing");
          } else {
            _errorNowPlaying = ErrorModel(
              event: MovieNowPlayingEvent(page: _pageNowPlaying),
              error: s.data.message,
            );
          }
        } else if (s is MoviePopularFailedState) {
          _isLoadPopular = false;
          if (_model.movie.popular != null) {
            _helper.showToast("Gagal memuat data popular");
          } else {
            _errorPopular = ErrorModel(
              event: MoviePopularEvent(page: _pagePopular),
              error: s.data.message,
            );
          }
        } else if (s is MovieTopRatedFailedState) {
          _isLoadTopRated = false;
          if (_model.movie.topRated != null) {
            _helper.showToast("Gagal memuat data top rated");
          } else {
            _errorTopRated = ErrorModel(
              event: MovieTopRatedEvent(page: _pageTopRated),
              error: s.data.message,
            );
          }
        } else if (s is MovieUpcomingFailedState) {
          _isLoadUpcoming = false;
          if (_model.movie.upcoming != null) {
            _helper.showToast("Gagal memuat data upcoming");
          } else {
            _errorUpcoming = ErrorModel(
              event: MovieUpcomingEvent(page: _pageUpcoming),
              error: s.data.message,
            );
          }
        }
      },
      child: BlocBuilder(
        bloc: _movieBloc,
        builder: (c, s) {
          return LoadingOverlay(
            isLoading: _showLoading,
            color: Colors.black,
            progressIndicator: SpinKitWaveSpinner(
              color: AppColor.primaryLight,
              trackColor: AppColor.primary,
              waveColor: AppColor.secondary,
              size: 64,
            ),
            child: Scaffold(
              appBar: _appBar(),
              body: SafeArea(
                child: Stack(
                  children: [
                    IgnorePointer(
                      ignoring: _showSearch,
                      child: AnimatedOpacity(
                        opacity: !_showSearch ? 1 : 0,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeIn,
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
                          child: _stateView(),
                        ),
                      ),
                    ),
                    IgnorePointer(
                      ignoring: !_showSearch,
                      child: AnimatedOpacity(
                        opacity: _showSearch ? 1 : 0,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeIn,
                        child: SearchPage(
                          query: _qSearch,
                          showLoading: (b) => setState(() {
                            _showLoading = b;
                          }),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  AppBar _appBar() {
    double width = MediaQuery.of(context).size.width;
    return AppBar(
      title: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeIn,
            width: !_showSearch ? width - 80 : 0,
            child: const Text("MoMovie"),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeIn,
            width: _showSearch ? width - 32 : 0,
            child: TextFormField(
              maxLines: 1,
              textInputAction: TextInputAction.search,
              controller: _cSearch,
              enabled: _showSearch,
              textCapitalization: TextCapitalization.words,
              keyboardType: TextInputType.text,
              onFieldSubmitted: (s) => _onSearch(),
              decoration: InputDecoration(
                hintText: "Search",
                hintStyle: const TextStyle(color: Colors.white),
                prefixIcon: _showSearch
                    ? IconButton(
                        onPressed: _onSearch,
                        icon: const Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                      )
                    : null,
                suffixIcon: _showSearch
                    ? IconButton(
                        onPressed: () => setState(() {
                          _showSearch = false;
                        }),
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                      )
                    : null,
              ),
            ),
          ),
        ],
      ),
      actions: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeIn,
          width: _showSearch ? 0 : 48,
          child: IconButton(
            onPressed: () => setState(() {
              _showSearch = true;
            }),
            icon: const Icon(Icons.search),
          ),
        ),
      ],
    );
  }

  Widget _stateView() {
    if (_isLoadNowPlaying &&
        _isLoadTopRated &&
        _isLoadPopular &&
        _isLoadUpcoming) {
      return Center(
        child: SpinKitWaveSpinner(
          color: AppColor.primaryLight,
          trackColor: AppColor.primary,
          waveColor: AppColor.secondary,
          size: 64,
        ),
      );
    }
    if (_errorNowPlaying != null &&
        _errorTopRated != null &&
        _errorPopular != null &&
        _errorUpcoming != null) {
      return Center(
        child: ReloadDataWidget(
          error: "Gagal memuat data.",
          onReload: _onRefresh,
        ),
      );
    }

    return _mainView();
  }

  Widget _mainView() {
    return ListView(
      shrinkWrap: true,
      primary: false,
      padding: const EdgeInsets.symmetric(vertical: 16),
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _nowPlayingView(),
        const SizedBox(height: 32),
        _popularView(),
        const SizedBox(height: 32),
        _topRatedView(),
        const SizedBox(height: 32),
        _upcomingView(),
      ],
    );
  }

  Widget _nowPlayingView() {
    String title = "🎬 Now Playing";
    if (_isLoadNowPlaying) {
      return _sectionView(
        title: title,
        child: Center(
          child: SpinKitWaveSpinner(
            color: AppColor.primaryLight,
            trackColor: AppColor.primary,
            waveColor: AppColor.secondary,
            size: 64,
          ),
        ),
      );
    }

    if (_errorNowPlaying != null) {
      return _sectionView(
        title: title,
        child: Center(
          child: Center(
            child: ReloadDataWidget(
              error: _errorNowPlaying?.error ?? "Gagal memuat data",
              onReload: _getDataNowPlaying,
            ),
          ),
        ),
      );
    }

    if (_model.movie.nowPlaying?.isEmpty ?? true) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: _sectionView(title: title, child: _emptyView()),
      );
    }

    double size = 8;
    return _sectionView(
      title: title,
      child: Column(
        children: [
          SizedBox(
            height: 156,
            child: PreloadPageView.builder(
              itemCount: _model.movie.nowPlaying!.length,
              controller: _cNowPlaying,
              preloadPagesCount: 5,
              onPageChanged: (i) => setState(() {
                _iNowPlaying = i;
              }),
              itemBuilder: (c, i) {
                MovieModel d = _model.movie.nowPlaying![i];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _itemView(
                    data: d,
                    onTap: () {},
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: size,
            child: ListView.separated(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: _model.movie.nowPlaying!.length,
              separatorBuilder: (_, __) => const SizedBox(width: 4),
              itemBuilder: (_, i) {
                return InkWell(
                  onTap: () => _cNowPlaying.animateToPage(
                    i,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeIn,
                  ),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: 8,
                    width: _iNowPlaying == i ? 32 : size,
                    decoration: BoxDecoration(
                      color: _iNowPlaying == i ? AppColor.primary : Colors.grey,
                      borderRadius: BorderRadius.circular(size / 2),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _popularView() {
    String title = "🔥 Popular";
    if (_isLoadPopular) {
      return _sectionView(
        title: title,
        child: Center(
          child: SpinKitWaveSpinner(
            color: AppColor.primaryLight,
            trackColor: AppColor.primary,
            waveColor: AppColor.secondary,
            size: 64,
          ),
        ),
      );
    }

    if (_errorPopular != null) {
      return _sectionView(
        title: title,
        child: Center(
          child: Center(
            child: ReloadDataWidget(
              error: _errorPopular?.error ?? "Gagal memuat data",
              onReload: _getDataPopular,
            ),
          ),
        ),
      );
    }

    if (_model.movie.popular?.isEmpty ?? true) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: _sectionView(title: title, child: _emptyView()),
      );
    }

    return _sectionView(
      title: title,
      child: SizedBox(
        height: 156,
        child: ListView.separated(
          shrinkWrap: true,
          primary: false,
          scrollDirection: Axis.horizontal,
          itemCount: _model.movie.popular!.length,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          separatorBuilder: (c, i) => const SizedBox(width: 12),
          itemBuilder: (c, i) {
            MovieModel d = _model.movie.popular![i];
            return SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: _itemView(
                data: d,
                onTap: () {},
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _topRatedView() {
    String title = "🎖️ Top Rated";
    if (_isLoadTopRated) {
      return _sectionView(
        title: title,
        child: Center(
          child: SpinKitWaveSpinner(
            color: AppColor.primaryLight,
            trackColor: AppColor.primary,
            waveColor: AppColor.secondary,
            size: 64,
          ),
        ),
      );
    }

    if (_errorTopRated != null) {
      return _sectionView(
        title: title,
        child: Center(
          child: Center(
            child: ReloadDataWidget(
              error: _errorTopRated?.error ?? "Gagal memuat data",
              onReload: _getDataTopRated,
            ),
          ),
        ),
      );
    }

    if (_model.movie.topRated?.isEmpty ?? true) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: _sectionView(title: title, child: _emptyView()),
      );
    }

    return _sectionView(
      title: title,
      child: SizedBox(
        height: 156,
        child: ListView.separated(
          shrinkWrap: true,
          primary: false,
          scrollDirection: Axis.horizontal,
          itemCount: _model.movie.topRated!.length,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          separatorBuilder: (c, i) => const SizedBox(width: 12),
          itemBuilder: (c, i) {
            MovieModel d = _model.movie.topRated![i];
            return SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: _itemView(
                data: d,
                onTap: () {},
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _upcomingView() {
    String title = "📝 Upcoming";
    if (_isLoadUpcoming) {
      return _sectionView(
        title: title,
        child: Center(
          child: SpinKitWaveSpinner(
            color: AppColor.primaryLight,
            trackColor: AppColor.primary,
            waveColor: AppColor.secondary,
            size: 64,
          ),
        ),
      );
    }

    if (_errorUpcoming != null) {
      return _sectionView(
        title: title,
        child: Center(
          child: Center(
            child: ReloadDataWidget(
              error: _errorUpcoming?.error ?? "Gagal memuat data",
              onReload: _getDataUpcoming,
            ),
          ),
        ),
      );
    }

    if (_model.movie.upcoming?.isEmpty ?? true) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: _sectionView(title: title, child: _emptyView()),
      );
    }

    return _sectionView(
      title: title,
      child: SizedBox(
        height: 156,
        child: ListView.separated(
          shrinkWrap: true,
          primary: false,
          scrollDirection: Axis.horizontal,
          itemCount: _model.movie.upcoming!.length,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          separatorBuilder: (c, i) => const SizedBox(width: 12),
          itemBuilder: (c, i) {
            MovieModel d = _model.movie.upcoming![i];
            return SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: _itemView(
                data: d,
                onTap: () {},
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _sectionView({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
        ),
        const SizedBox(height: 16),
        child
      ],
    );
  }

  Widget _emptyView() {
    return Card(
      color: AppColor.primary,
      child: InkWell(
        splashColor: AppColor.secondary,
        borderRadius: BorderRadius.circular(12),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: DecorationImage(
                    image: AssetImage(
                      AppImage.momovieFill,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Data lagi kosong 😔",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      "Aduh...\nDatanya lagi gak ada, coba lain kali ya.",
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _itemView({required MovieModel data, required Function() onTap}) {
    return Card(
      color: AppColor.primary,
      child: InkWell(
        splashColor: AppColor.secondary,
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Stack(
          children: [
            ImageNetworkWidget(
              url: "${AppConfig.shared.baseUrlImage}${data.backdropPath}",
              radius: BorderRadius.circular(12),
              defaultImage: "",
              clickable: false,
            ),
            Container(
              color: Colors.black.withOpacity(0.5),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 16,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ImageNetworkWidget(
                    width: 108,
                    height: 156,
                    radius: BorderRadius.circular(16),
                    url: "${AppConfig.shared.baseUrlImage}${data.posterPath}",
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.title ?? "",
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Expanded(
                          child: Text(
                            data.overview ?? "",
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
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
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
