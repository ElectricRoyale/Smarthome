import 'dart:ui';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spotify_openapi/spotify_openapi.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

import '../generated/l10n.dart';
import '../utils/constants.dart';
import '../utils/globals.dart';
import '../utils/scrolling_text.dart';
import '../utils/spotify_helper.dart';
import '../utils/widget_functions.dart';

class SpotifyControlFullPage extends StatefulWidget {
  const SpotifyControlFullPage({Key? key}) : super(key: key);

  @override
  State createState() => _SpotifyControlFullPageState();
}

class _SpotifyControlFullPageState extends State<SpotifyControlFullPage>
    with TickerProviderStateMixin {
  StateSetter? updateFullControlView;
  bool showQueue = false;
  double opacity = 0.0;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    spotifyControllRefresh = () async {
      setState(() {});
      if (updateFullControlView != null) updateFullControlView!.call(() {});
    };
  }

  @override
  void dispose() {
    super.dispose();
    spotifyControllRefresh = () async {};
  }

  void resume() {
    SpotifySdk.resume();
  }

  void pause() {
    SpotifySdk.pause();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            BACKGROUND_START,
            BACKGROUND_END,
          ],
        ),
      ),
      child: Theme(
        data: ThemeData().copyWith(
            bottomSheetTheme: const BottomSheetThemeData(
                backgroundColor: Colors.transparent, elevation: 0)),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          bottomSheet: _controlView(),
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            forceMaterialTransparency: true,
            title: CupertinoTextField(
              controller: searchController,
              placeholder: S.of(context).searchPlaceholder,
              placeholderStyle: const TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Color.fromARGB(76, 235, 235, 245)),
              suffix: Padding(
                padding: EdgeInsets.only(
                    right: MediaQuery.of(context).size.width * 0.01),
                child: const Icon(CupertinoIcons.search),
              ),
              cursorColor: CupertinoColors.white,
              style: const TextStyle(color: CupertinoColors.white),
              padding: const EdgeInsets.all(9.0),
              decoration: BoxDecoration(
                  color: const Color(0x27ffffff),
                  border:
                      Border.all(width: 0.0, color: const Color(0x33FFFFFF)),
                  borderRadius: const BorderRadius.all(Radius.circular(7.0))),
            ),
          ),
          body: GridView.builder(
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: MediaQuery.of(context).size.width / 2,
                  childAspectRatio: MediaQuery.of(context).size.width / 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15),
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 20),
              itemCount: SpotifyHelper().playlists.length,
              itemBuilder: (context, index) => Container()),
        ),
      ),
    );
  }

  Widget _controlView() {
    return Container(
      margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height * 0.035,
          left: 5,
          right: 5),
      decoration: BoxDecoration(
          color: Colors.transparent, borderRadius: BorderRadius.circular(16.0)),
      clipBehavior: Clip.hardEdge,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaY: 30.0, sigmaX: 30.0),
        child: BottomSheet(
          onClosing: () {},
          backgroundColor: const Color(0x27ffffff),
          animationController: BottomSheet.createAnimationController(this),
          onDragStart: (_) => showModalBottomSheet(
              isDismissible: false,
              elevation: 0,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              barrierColor: Colors.transparent,
              context: context,
              builder: (context) => StatefulBuilder(
                  builder: (context, state) => _fullControlView(state))),
          builder: (context) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 5.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16.0),
                      child: Image.memory(
                        SpotifyHelper().trackImage,
                        width: 47,
                        height: 47,
                        gaplessPlayback: true,
                        filterQuality: FilterQuality.high,
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.57,
                          height: 25,
                          margin: const EdgeInsets.symmetric(horizontal: 7.0),
                          child: ScrollingText(
                            (SpotifyHelper().playerState.track?.name ?? ' '),
                            //maxWidth: MediaQuery.of(context).size.width * 0.57,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              overflow: TextOverflow.ellipsis,
                            ),
                            fadingEdgeStartFraction: 0.1,
                            fadingEdgeEndFraction: 0.1,
                            startAfter: const Duration(seconds: 3),
                            pauseAfterRound: const Duration(seconds: 3),
                            blankSpace: 100,
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.57,
                          height: 17,
                          margin: const EdgeInsets.symmetric(horizontal: 7.0),
                          child: ScrollingText(
                            (SpotifyHelper()
                                    .playerState
                                    .track
                                    ?.artists
                                    .map((artist) => artist.name)
                                    .join(', ') ??
                                ' '),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              overflow: TextOverflow.ellipsis,
                            ),
                            fadingEdgeStartFraction: 0.1,
                            fadingEdgeEndFraction: 0.1,
                            startAfter: const Duration(seconds: 3),
                            pauseAfterRound: const Duration(seconds: 3),
                            blankSpace: 100,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () {
                        String uri = SpotifyHelper().playerState.track!.uri;
                        SpotifyHelper().favorite
                            ? SpotifySdk.removeFromLibrary(spotifyUri: uri)
                            : SpotifySdk.addToLibrary(spotifyUri: uri);
                      },
                      color: Colors.white,
                      iconSize: 28,
                      padding: EdgeInsets.zero,
                      icon: Icon(
                        SpotifyHelper().favorite
                            ? CupertinoIcons.heart_fill
                            : CupertinoIcons.heart,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        SpotifyHelper().playerState.isPaused
                            ? resume()
                            : pause();
                      },
                      alignment: Alignment.center,
                      color: Colors.white,
                      iconSize: 35,
                      padding: EdgeInsets.zero,
                      icon: Icon(
                        SpotifyHelper().playerState.isPaused
                            ? CupertinoIcons.play_fill
                            : CupertinoIcons.pause_fill,
                      ),
                    ),
                  ],
                ),
              ),
              addVerticalSpace(8.0),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.035),
                child: StreamBuilder(
                  stream: SpotifyHelper().position,
                  builder: (context, progress) => ProgressBar(
                    progress: Duration(
                        milliseconds: progress.data ??
                            SpotifyHelper().playerState.playbackPosition),
                    total: Duration(
                        milliseconds:
                            SpotifyHelper().playerState.track!.duration),
                    timeLabelLocation: TimeLabelLocation.none,
                    progressBarColor: Colors.white,
                    baseBarColor: Colors.white.withOpacity(0.4),
                    barHeight: 3,
                    thumbRadius: 0.0,
                    thumbGlowRadius: 0.0,
                    thumbCanPaintOutsideBar: false,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _fullControlView(StateSetter state) {
    updateFullControlView = state;
    if (SpotifyHelper().queue.isEmpty && showQueue) {
      Future.delayed(
          const Duration(milliseconds: 200),
          () => updateFullControlView!(() {
                opacity = 1.0;
              }));
    }
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.height * 0.035,
        horizontal: 5.0,
      ),
      decoration: BoxDecoration(
          color: Colors.transparent, borderRadius: BorderRadius.circular(16.0)),
      clipBehavior: Clip.hardEdge,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaY: 30.0, sigmaX: 30.0),
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  showQueue
                      ? Colors.black
                      : SpotifyHelper().imageColor ?? BACKGROUND_END,
                  const Color(0x33ffffff)
                ],
                tileMode: TileMode.decal,
              ),
              borderRadius: BorderRadius.circular(16.0)),
          clipBehavior: Clip.hardEdge,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaY: 1.0, sigmaX: 1.0),
            child: BottomSheet(
              onClosing: () => Navigator.of(context).pop(),
              animationController: BottomSheet.createAnimationController(this),
              elevation: 0,
              showDragHandle: true,
              backgroundColor: Colors.transparent,
              builder: (context) => !showQueue
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.only(top: 25.0, bottom: 15.0),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16.0),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black,
                                    spreadRadius: 0,
                                    blurRadius: 3,
                                  ),
                                ]),
                            clipBehavior: Clip.hardEdge,
                            child: Image.memory(
                              SpotifyHelper().trackImage,
                              width: 235,
                              height: 235,
                              gaplessPlayback: true,
                              filterQuality: FilterQuality.high,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.035,
                              vertical:
                                  MediaQuery.of(context).size.width * 0.014),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: IconButton(
                                  onPressed: () => updateFullControlView!(
                                      () => showQueue = !showQueue),
                                  iconSize: 27,
                                  icon: const Icon(
                                    CupertinoIcons.music_note_list,
                                    shadows: [
                                      Shadow(
                                        offset: Offset(0.0, 2.5),
                                        blurRadius: 3.0,
                                        color: Color.fromARGB(255, 0, 0, 0),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Column(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.68,
                                    height: 25,
                                    alignment: Alignment.center,
                                    child: ScrollingText(
                                      (SpotifyHelper()
                                              .playerState
                                              .track
                                              ?.name ??
                                          ' '),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        shadows: [
                                          Shadow(
                                            offset: Offset(0.0, 2.0),
                                            blurRadius: 3.0,
                                            color: Color.fromARGB(255, 0, 0, 0),
                                          )
                                        ],
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      fadingEdgeStartFraction: 0.1,
                                      fadingEdgeEndFraction: 0.1,
                                      startAfter: const Duration(seconds: 3),
                                      pauseAfterRound:
                                          const Duration(seconds: 3),
                                      blankSpace: 100,
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.68,
                                    height: 17,
                                    alignment: Alignment.center,
                                    child: ScrollingText(
                                      (SpotifyHelper()
                                              .playerState
                                              .track
                                              ?.artists
                                              .map((artist) => artist.name)
                                              .join(', ') ??
                                          ' '),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      fadingEdgeStartFraction: 0.1,
                                      fadingEdgeEndFraction: 0.1,
                                      startAfter: const Duration(seconds: 3),
                                      pauseAfterRound:
                                          const Duration(seconds: 3),
                                      blankSpace: 100,
                                    ),
                                  ),
                                ],
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: IconButton(
                                  onPressed: () {
                                    String uri =
                                        SpotifyHelper().playerState.track!.uri;
                                    SpotifyHelper().favorite
                                        ? SpotifySdk.removeFromLibrary(
                                            spotifyUri: uri)
                                        : SpotifySdk.addToLibrary(
                                            spotifyUri: uri);
                                  },
                                  icon: Icon(
                                    SpotifyHelper().favorite
                                        ? CupertinoIcons.heart_fill
                                        : CupertinoIcons.heart,
                                    color: Colors.white,
                                    size: 28,
                                    shadows: const [
                                      Shadow(
                                        offset: Offset(0.0, 2.5),
                                        blurRadius: 3.0,
                                        color: Color.fromARGB(255, 0, 0, 0),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        addVerticalSpace(
                            MediaQuery.of(context).size.height * 0.016),
                        SizedBox(
                          height: 95,
                          child: Stack(children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                      MediaQuery.of(context).size.width *
                                          0.035),
                              child: StreamBuilder(
                                stream: SpotifyHelper().position,
                                builder: (context, progress) => ProgressBar(
                                  progress: Duration(
                                      milliseconds: progress.data ??
                                          SpotifyHelper()
                                              .playerState
                                              .playbackPosition),
                                  total: Duration(
                                      milliseconds: SpotifyHelper()
                                          .playerState
                                          .track!
                                          .duration),
                                  onSeek: (newPosition) => SpotifySdk.seekTo(
                                      positionedMilliseconds:
                                          newPosition.inMilliseconds),
                                  thumbColor: Colors.white,
                                  progressBarColor: Colors.white,
                                  baseBarColor: Colors.white.withOpacity(0.4),
                                  thumbRadius: 6.0,
                                  thumbGlowRadius: 10,
                                  thumbCanPaintOutsideBar: false,
                                  timeLabelTextStyle: const TextStyle(
                                      fontSize: 12, height: 1.4),
                                ),
                              ),
                            ),
                            Positioned(
                              top: MediaQuery.of(context).size.height * 0.025,
                              width: MediaQuery.of(context).size.width * 0.975,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: IconButton(
                                      onPressed: () {
                                        SpotifySdk.setShuffle(
                                            shuffle: !SpotifyHelper()
                                                .playerState
                                                .playbackOptions
                                                .isShuffling);
                                      },
                                      alignment: Alignment.center,
                                      icon: Icon(
                                        CupertinoIcons.shuffle_medium,
                                        color: SpotifyHelper()
                                                .playerState
                                                .playbackOptions
                                                .isShuffling
                                            ? COLOR_ACCENT
                                            : Colors.white,
                                        size: 35,
                                        shadows: const [
                                          Shadow(
                                            offset: Offset(0.0, 2.5),
                                            blurRadius: 3.0,
                                            color: Color.fromARGB(255, 0, 0, 0),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: IconButton(
                                      onPressed: () {
                                        SpotifySdk.skipPrevious();
                                      },
                                      alignment: Alignment.center,
                                      icon: const Icon(
                                        CupertinoIcons.backward_end_fill,
                                        color: Colors.white,
                                        size: 35,
                                        shadows: [
                                          Shadow(
                                            offset: Offset(0.0, 2.5),
                                            blurRadius: 3.0,
                                            color: Color.fromARGB(255, 0, 0, 0),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: IconButton(
                                      onPressed: () {
                                        SpotifyHelper().playerState.isPaused
                                            ? resume()
                                            : pause();
                                      },
                                      alignment: Alignment.center,
                                      color: Colors.white,
                                      iconSize: 60,
                                      padding: EdgeInsets.zero,
                                      icon: Icon(
                                        SpotifyHelper().playerState.isPaused
                                            ? CupertinoIcons.play_fill
                                            : CupertinoIcons.pause_fill,
                                        shadows: const [
                                          Shadow(
                                            offset: Offset(0.0, 2.5),
                                            blurRadius: 3.0,
                                            color: Color.fromARGB(255, 0, 0, 0),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: IconButton(
                                      onPressed: () {
                                        SpotifySdk.skipNext();
                                      },
                                      alignment: Alignment.center,
                                      icon: const Icon(
                                        CupertinoIcons.forward_end_fill,
                                        color: Colors.white,
                                        size: 35,
                                        shadows: [
                                          Shadow(
                                            offset: Offset(0.0, 2.5),
                                            blurRadius: 3.0,
                                            color: Color.fromARGB(255, 0, 0, 0),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Center(
                                      child: PopupMenuButton(
                                        itemBuilder: (context) => [
                                          RepeatMode.off.index,
                                          RepeatMode.context.index,
                                          RepeatMode.track.index
                                        ]
                                            .map<PopupMenuItem<int>>((item) =>
                                                PopupMenuItem(
                                                    value: item,
                                                    padding: EdgeInsets.zero,
                                                    child: Center(
                                                        child:
                                                            _repeatIcon[item])))
                                            .toList(),
                                        initialValue: SpotifyHelper()
                                            .playerState
                                            .playbackOptions
                                            .repeatMode
                                            .index,
                                        onSelected: (index) =>
                                            SpotifySdk.setRepeatMode(
                                                repeatMode: RepeatMode.values
                                                    .elementAt(index)),
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20.0))),
                                        color: const Color.fromARGB(
                                            255, 51, 54, 68),
                                        icon: _repeatIcon[SpotifyHelper()
                                            .playerState
                                            .playbackOptions
                                            .repeatMode
                                            .index],
                                        padding: EdgeInsets.zero,
                                        clipBehavior: Clip.hardEdge,
                                        constraints: const BoxConstraints(
                                            minWidth: 40.0, maxWidth: 40.0),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ]),
                        ),
                      ],
                    )
                  : Scaffold(
                      backgroundColor: Colors.transparent,
                      appBar: AppBar(
                        forceMaterialTransparency: true,
                        automaticallyImplyLeading: false,
                        leading: IconButton(
                          icon: const Icon(CupertinoIcons.back),
                          onPressed: () => updateFullControlView!(
                              () => showQueue = !showQueue),
                        ),
                      ),
                      bottomNavigationBar: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          StreamBuilder(
                            stream: SpotifyHelper().position,
                            builder: (context, progress) => ProgressBar(
                              progress: Duration(
                                  milliseconds: progress.data ??
                                      SpotifyHelper()
                                          .playerState
                                          .playbackPosition),
                              total: Duration(
                                  milliseconds: SpotifyHelper()
                                      .playerState
                                      .track!
                                      .duration),
                              timeLabelLocation: TimeLabelLocation.none,
                              progressBarColor: Colors.white,
                              baseBarColor: Colors.white.withOpacity(0.4),
                              barHeight: 3,
                              thumbRadius: 0.0,
                              thumbGlowRadius: 0.0,
                              thumbCanPaintOutsideBar: false,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: () {
                                  SpotifySdk.skipPrevious();
                                },
                                alignment: Alignment.center,
                                icon: const Icon(
                                  CupertinoIcons.backward_end_fill,
                                  color: Colors.white,
                                  size: 35,
                                  shadows: [
                                    Shadow(
                                      offset: Offset(0.0, 2.5),
                                      blurRadius: 3.0,
                                      color: Color.fromARGB(255, 0, 0, 0),
                                    )
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  SpotifyHelper().playerState.isPaused
                                      ? resume()
                                      : pause();
                                },
                                alignment: Alignment.center,
                                color: Colors.white,
                                iconSize: 60,
                                padding: EdgeInsets.zero,
                                icon: Icon(
                                  SpotifyHelper().playerState.isPaused
                                      ? CupertinoIcons.play_fill
                                      : CupertinoIcons.pause_fill,
                                  shadows: const [
                                    Shadow(
                                      offset: Offset(0.0, 2.5),
                                      blurRadius: 3.0,
                                      color: Color.fromARGB(255, 0, 0, 0),
                                    )
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  SpotifySdk.skipNext();
                                },
                                alignment: Alignment.center,
                                icon: const Icon(
                                  CupertinoIcons.forward_end_fill,
                                  color: Colors.white,
                                  size: 35,
                                  shadows: [
                                    Shadow(
                                      offset: Offset(0.0, 2.5),
                                      blurRadius: 3.0,
                                      color: Color.fromARGB(255, 0, 0, 0),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      body: ShaderMask(
                        shaderCallback: (Rect rect) => const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.grey,
                            Colors.transparent,
                            Colors.transparent,
                            Colors.grey,
                          ],
                          stops: [0.0, 0.01, 0.97, 1.0],
                        ).createShader(rect),
                        blendMode: BlendMode.dstOut,
                        child: SpotifyHelper().queue.isNotEmpty
                            ? ReorderableListView.builder(
                                buildDefaultDragHandles: false,
                                onReorder: (oldIndex, newIndex) =>
                                    SpotifyHelper()
                                        .reorderQueue(oldIndex, newIndex),
                                padding: const EdgeInsets.only(bottom: 10.0),
                                itemCount: SpotifyHelper().queue.length,
                                itemBuilder: (context, index) {
                                  bool isChecked = false;
                                  return CupertinoListTile(
                                    key: Key((SpotifyHelper()
                                            .queue
                                            .elementAt(index)
                                            .oneOf
                                            .value! as TrackObject)
                                        .name!),
                                    leading: CupertinoCheckbox(
                                        shape: const CircleBorder(),
                                        value: isChecked,
                                        onChanged: (isCheck) => setState(
                                            () => isChecked = isCheck!)),
                                    trailing: ReorderableDragStartListener(
                                        index: index,
                                        child: const Icon(CupertinoIcons.bars)),
                                    padding:
                                        const EdgeInsetsDirectional.symmetric(
                                      vertical: 3,
                                      horizontal: 14.0,
                                    ),
                                    title: Text(
                                      (SpotifyHelper()
                                              .queue
                                              .elementAt(index)
                                              .oneOf
                                              .value! as TrackObject)
                                          .name!,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 17.5,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Text((SpotifyHelper()
                                            .queue
                                            .elementAt(index)
                                            .oneOf
                                            .value! as TrackObject)
                                        .artists!
                                        .map((artist) => artist.name)
                                        .join(', ')),
                                  );
                                })
                            : Center(
                                child: AnimatedOpacity(
                                  duration: const Duration(seconds: 2),
                                  opacity: opacity,
                                  child: Text(
                                    S.of(context).emptyQueue,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        color:
                                            Color.fromARGB(55, 255, 255, 255),
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.none),
                                  ),
                                ),
                              ),
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  final Map<int, Widget> _repeatIcon = {
    0: const Icon(
      CupertinoIcons.repeat,
      color: Colors.white,
      size: 35,
      shadows: [
        Shadow(
          offset: Offset(0.0, 2.5),
          blurRadius: 3.0,
          color: Color.fromARGB(255, 0, 0, 0),
        )
      ],
    ),
    2: const Icon(
      CupertinoIcons.repeat,
      color: COLOR_ACCENT,
      size: 35,
      shadows: [
        Shadow(
          offset: Offset(0.0, 2.5),
          blurRadius: 3.0,
          color: Color.fromARGB(255, 0, 0, 0),
        )
      ],
    ),
    1: const Icon(
      CupertinoIcons.repeat_1,
      color: COLOR_ACCENT,
      size: 35,
      shadows: [
        Shadow(
          offset: Offset(0.0, 2.5),
          blurRadius: 3.0,
          color: Color.fromARGB(255, 0, 0, 0),
        )
      ],
    )
  };
}
