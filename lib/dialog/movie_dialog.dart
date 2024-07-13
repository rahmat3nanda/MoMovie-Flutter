import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:momovie/bloc/movie/movie_bloc.dart';
import 'package:momovie/common/configs.dart';
import 'package:momovie/common/styles.dart';
import 'package:momovie/model/movie_model.dart';
import 'package:momovie/model/video_model.dart';
import 'package:momovie/tool/helper.dart';
import 'package:momovie/widget/image_network_widget.dart';
import 'package:momovie/widget/section_widget.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
// import 'package:video_player/video_player.dart';

class MovieDialog extends StatefulWidget {
  final MovieModel movie;

  const MovieDialog({super.key, required this.movie});

  @override
  State<MovieDialog> createState() => _MovieDialogState();
}

class _MovieDialogState extends State<MovieDialog> {
  late MovieBloc _movieBloc;

  // late VideoPlayerController? _controller;
  YoutubePlayerController? _controller;

  List<MovieModel>? _recommendations;
  List<MovieModel>? _similar;

  @override
  void initState() {
    super.initState();
    _movieBloc = BlocProvider.of<MovieBloc>(context);
    // _controller = VideoPlayerController.networkUrl(Uri.parse(
    //     'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'))
    //   ..initialize().then((_) {
    //     // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
    //     setState(() {});
    //   });
    _movieBloc.add(MovieVideosEvent(id: widget.movie.id ?? 0));
    _movieBloc.add(MovieRecommendationsEvent(
      id: widget.movie.id ?? 0,
      page: 1,
    ));
    _movieBloc.add(MovieSimilarEvent(
      id: widget.movie.id ?? 0,
      page: 1,
    ));
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MovieBloc, MovieState>(
      bloc: _movieBloc,
      listener: (c, s) {
        if (s is MovieVideosSuccessState) {
          VideoModel? v = s.data
              .firstWhereOrNull((e) => e.site?.toLowerCase() == "youtube");
          if (v != null) {
            _controller = YoutubePlayerController(
              initialVideoId: v.key ?? "",
              flags: const YoutubePlayerFlags(
                autoPlay: true,
                mute: false,
                loop: true,
              ),
            );
          }
        } else if (s is MovieRecommendationsSuccessState) {
          _recommendations = s.data;
        } else if (s is MovieSimilarSuccessState) {
          _similar = s.data;
        }
      },
      child: BlocBuilder(
        bloc: _movieBloc,
        builder: (c, s) {
          return Dialog(
            insetPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: kToolbarHeight,
            ),
            backgroundColor: Colors.black,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0)),
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.resolveWith<Color?>(
                        (Set<WidgetState> states) => AppColor.primary,
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                if (_controller != null)
                  YoutubePlayer(
                    controller: _controller!,
                    showVideoProgressIndicator: true,
                    progressIndicatorColor: Colors.amber,
                    progressColors: const ProgressBarColors(
                      playedColor: Colors.amber,
                      handleColor: Colors.amberAccent,
                    ),
                  ),
                if (_controller != null) const SizedBox(height: 16),
                // if (_controller?.value.isInitialized ?? false)
                //   Container(
                //     padding: const EdgeInsets.only(left: 8, top: 8, right: 8),
                //     decoration: BoxDecoration(
                //       color: AppColor.primary,
                //       borderRadius: const BorderRadius.vertical(
                //         top: Radius.circular(8),
                //       ),
                //     ),
                //     child: AspectRatio(
                //       aspectRatio: _controller!.value.aspectRatio,
                //       child: VideoPlayer(_controller!),
                //     ),
                //   ),
                // if (_controller?.value.isInitialized ?? false)
                //   Container(
                //     padding: const EdgeInsets.all(4),
                //     decoration: BoxDecoration(
                //       color: AppColor.primary,
                //       borderRadius: const BorderRadius.vertical(
                //         bottom: Radius.circular(8),
                //       ),
                //     ),
                //     child: Center(
                //       child: IconButton(
                //         style: ButtonStyle(
                //           backgroundColor: WidgetStateProperty.resolveWith<Color?>(
                //             (Set<WidgetState> states) => AppColor.secondary,
                //           ),
                //         ),
                //         onPressed: () => setState(() {
                //           _controller!.value.isPlaying
                //               ? _controller!.pause()
                //               : _controller!.play();
                //         }),
                //         icon: Icon(
                //           _controller!.value.isPlaying
                //               ? Icons.pause
                //               : Icons.play_arrow,
                //           color: Colors.white,
                //           size: 28,
                //         ),
                //       ),
                //     ),
                //   ),
                // const SizedBox(height: 16),
                Text(
                  widget.movie.title ?? "",
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
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
                        "${widget.movie.voteAverage?.toStringAsFixed(2) ?? 0}/10",
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  widget.movie.overview ?? "",
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                if (_recommendations != null) const SizedBox(height: 32),
                if (_recommendations != null)
                  SectionWidget(
                    title: "👍 Recommendations",
                    child: SizedBox(
                      height: 256,
                      child: ListView.separated(
                        shrinkWrap: true,
                        primary: false,
                        scrollDirection: Axis.horizontal,
                        itemCount: _recommendations!.length,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        separatorBuilder: (c, i) => const SizedBox(width: 12),
                        itemBuilder: (c, i) {
                          MovieModel d = _recommendations![i];
                          return SizedBox(
                            width: 200,
                            child: _itemView(
                              data: d,
                              onTap: () => openMovieDialog(context, movie: d),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                if (_similar != null) const SizedBox(height: 16),
                if (_similar != null)
                  SectionWidget(
                    title: "🔍 Similar",
                    child: SizedBox(
                      height: 256,
                      child: ListView.separated(
                        shrinkWrap: true,
                        primary: false,
                        scrollDirection: Axis.horizontal,
                        itemCount: _similar!.length,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        separatorBuilder: (c, i) => const SizedBox(width: 12),
                        itemBuilder: (c, i) {
                          MovieModel d = _similar![i];
                          return SizedBox(
                            width: 200,
                            child: _itemView(
                              data: d,
                              onTap: () => openMovieDialog(context, movie: d),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
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
                            color: Colors.white,
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
                                  color: Colors.white,
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
  }
}

Future openMovieDialog(
  BuildContext context, {
  required MovieModel movie,
}) {
  return showGeneralDialog(
    barrierLabel: "Movie Dialog",
    barrierDismissible: false,
    barrierColor: Colors.black.withOpacity(0.5),
    context: context,
    pageBuilder: (context, anim1, anim2) => MovieDialog(movie: movie),
    transitionDuration: const Duration(milliseconds: 300),
    transitionBuilder: (context, anim1, anim2, child) {
      return Transform.scale(
        scale: anim1.value,
        child: child,
      );
    },
  );
}
