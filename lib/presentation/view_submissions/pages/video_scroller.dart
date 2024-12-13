import 'package:fitness_project/domain/entities/db/submission.dart';
import 'package:fitness_project/main.dart';
import 'package:fitness_project/presentation/view_submissions/bloc/video_info_cache_cubit.dart';
import 'package:fitness_project/presentation/view_submissions/widgets/vertical_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';

class VideoScroller extends StatefulWidget {
  final List<SubmissionEntity> submissions;
  final int? startIndex;
  final bool reviewing;
  const VideoScroller(
      {super.key,
      required this.submissions,
      this.startIndex,
      this.reviewing = false});

  @override
  State<VideoScroller> createState() => _VideoScrollerState();
}

class _VideoScrollerState extends State<VideoScroller> with RouteAware {
  late PageController _pageController;
  late int _currentIndex;
  late List<VideoPlayerController> videoControllers;

  @override
  void initState() {
    super.initState();

    final initialIndex = widget.startIndex ?? 0;
    _pageController = PageController(
      initialPage: initialIndex,
    );
    _currentIndex = initialIndex;
    videoControllers = widget.submissions
        .map((submission) =>
            VideoPlayerController.networkUrl(Uri.parse(submission.videoUrl)))
        .toList();

    for (var controller in videoControllers) {
      controller.setLooping(true);
    }

    final currentController = videoControllers[initialIndex];
    final controllerAfter = videoControllers.length > initialIndex + 1
        ? videoControllers[initialIndex + 1]
        : null;

    final controllerBefore =
        initialIndex > 0 ? videoControllers[initialIndex - 1] : null;
    currentController.initialize().then((_) {
      setState(() {});
      currentController.play();
    });
    if (controllerAfter != null) {
      controllerAfter.initialize();
    }
    if (controllerBefore != null) {
      controllerBefore.initialize();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    for (var controller in videoControllers) {
      controller.dispose();
    }
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    super.didPopNext();
    final currentController = videoControllers[_currentIndex];
    currentController.play();
  }

  @override
  void didPushNext() {
    super.didPushNext();
    final currentController = videoControllers[_currentIndex];
    currentController.pause();
  }

  void onPageChanged(int index) {
    final previousIndex = _currentIndex;
    _currentIndex = index;
    final previousController = videoControllers[previousIndex];
    final currentController = videoControllers[_currentIndex];
    final controllerAfter = videoControllers.length > _currentIndex + 1
        ? videoControllers[_currentIndex + 1]
        : null;
    final controllerBefore =
        _currentIndex > 0 ? videoControllers[_currentIndex - 1] : null;

    previousController.pause();
    previousController.seekTo(Duration.zero);
    if (currentController.value.isInitialized) {
      currentController.play();
    } else {
      currentController.initialize().then((_) {
        currentController.play();
      });
    }
    if (controllerAfter != null) {
      if (!controllerAfter.value.isInitialized) {
        controllerAfter.initialize();
      }
    }
    if (controllerBefore != null) {
      if (!controllerBefore.value.isInitialized) {
        controllerBefore.initialize();
      }
    }
  }

  void onMuteChanged(bool isMuted) {
    for (var controller in videoControllers) {
      controller.setVolume(isMuted ? 0 : 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final statusBarHeight = MediaQuery.of(context).padding.top;
    final videoPlayerHeight = screenHeight - statusBarHeight;
    return BlocProvider<VideoInfoCacheCubit>(
      create: (context) => VideoInfoCacheCubit(),
      child: Builder(builder: (context) {
        final videoInfoCacheState = context.watch<VideoInfoCacheCubit>().state;
        return SizedBox(
          height: videoPlayerHeight,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (value) {
              onPageChanged(value);
            },
            scrollDirection: Axis.vertical,
            pageSnapping: true,
            itemCount: widget.submissions.length,
            itemBuilder: (BuildContext context, int index) {
              final submission = widget.submissions[index];
              final controller = videoControllers[index];
              return Container(
                margin: EdgeInsets.only(top: statusBarHeight),
                height: videoPlayerHeight,
                width: MediaQuery.of(context).size.width,
                child: VerticalVideoPlayer(
                  controller: controller,
                  submission: submission,
                  data: videoInfoCacheState[index],
                  onLoadInfo: (data) {
                    context.read<VideoInfoCacheCubit>().add(index, data);
                  },
                  reviewing: widget.reviewing,
                  onMute: onMuteChanged,
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
