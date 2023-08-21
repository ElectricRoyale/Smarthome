import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smarthome/layouts/spotify_controll_full_page.dart';
import 'package:smarthome/utils/spotify_helper.dart';
import 'package:smarthome/utils/widget_functions.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

import '../../utils/constants.dart';
import '../../utils/globals.dart';
import '../../utils/scrolling_text.dart';

class SpotifyControllLayout extends StatefulWidget {
  const SpotifyControllLayout({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => SpotifyControlLayoutDesign();
}

class SpotifyControlLayoutDesign extends State<SpotifyControllLayout> {
  @override
  void initState() {
    super.initState();
    spotifyControllRefresh = () async => setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    spotifyControllRefresh = () async {};
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.sizeOf(context);
    return Container(
      margin: EdgeInsets.all(screenSize.width * 0.01215),
      width: double.maxFinite,
      decoration: BoxDecoration(
          color: const Color(0x12ffffff),
          borderRadius: BorderRadius.circular(20.0)),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        borderRadius: BorderRadius.circular(20.0),
        onTap: () => Navigator.of(context)
            .push(
          PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const SpotifyControlFullPage(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) => child),
        )
            .then((value) {
          spotifyControllRefresh = () async => setState(() {});
          setState(() {});
        }),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: screenSize.height * 0.0273437,
                  bottom: screenSize.height * 0.0109375),
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
                  width: screenSize.width * 0.571180556,
                  height: screenSize.width * 0.571180556,
                  gaplessPlayback: true,
                  filterQuality: FilterQuality.high,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: screenSize.width * 0.035,
                  vertical: screenSize.width * 0.014),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Column(
                    children: [
                      Container(
                        width: screenSize.width * 0.68,
                        height: screenSize.height * 0.02734375,
                        alignment: Alignment.center,
                        child: ScrollingText(
                          (SpotifyHelper().playerState.track?.name ?? ' '),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            //#Todo: change fontSize to fontScaleFactor.
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
                          crossAxisAlignment: CrossAxisAlignment.center,
                          fadingEdgeStartFraction: 0.1,
                          fadingEdgeEndFraction: 0.1,
                          startAfter: const Duration(seconds: 3),
                          pauseAfterRound: const Duration(seconds: 3),
                          blankSpace: 100,
                        ),
                      ),
                      Container(
                        width: screenSize.width * 0.68,
                        height: screenSize.height * 0.01859375,
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
                            //#Todo: change fontSize to fontScaleFactor.
                            fontSize: 14,
                            overflow: TextOverflow.ellipsis,
                          ),
                          crossAxisAlignment: CrossAxisAlignment.center,
                          fadingEdgeStartFraction: 0.1,
                          fadingEdgeEndFraction: 0.1,
                          startAfter: const Duration(seconds: 3),
                          pauseAfterRound: const Duration(seconds: 3),
                          blankSpace: 100,
                        ),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      onPressed: () {
                        String uri = SpotifyHelper().playerState.track!.uri;
                        SpotifyHelper().favorite
                            ? SpotifySdk.removeFromLibrary(spotifyUri: uri)
                            : SpotifySdk.addToLibrary(spotifyUri: uri);
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
            addVerticalSpace(screenSize.height * 0.016),
            Expanded(
              child: Stack(children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: screenSize.width * 0.035),
                  child: StreamBuilder(
                    stream: SpotifyHelper().position,
                    builder: (context, progress) => ProgressBar(
                      progress: Duration(
                          milliseconds: (progress.data ??
                              SpotifyHelper().playerState.playbackPosition)),
                      total: Duration(
                          milliseconds:
                              SpotifyHelper().playerState.track!.duration),
                      onSeek: (newPosition) {
                        SpotifySdk.seekTo(
                            positionedMilliseconds: newPosition.inMilliseconds);
                      },
                      thumbColor: Colors.white,
                      progressBarColor: Colors.white,
                      baseBarColor: Colors.white.withOpacity(0.4),
                      thumbRadius: 6.0,
                      thumbGlowRadius: 10,
                      //Todo: textSize
                      timeLabelTextStyle:
                          const TextStyle(fontSize: 12, height: 1.4),
                    ),
                  ),
                ),
                Positioned(
                  top: screenSize.height * 0.025,
                  width: screenSize.width * 0.975,
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
                                ? SpotifySdk.resume()
                                : SpotifySdk.pause();
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
                                        child:
                                            Center(child: _repeatIcon[item])))
                                .toList(),
                            initialValue: SpotifyHelper()
                                .playerState
                                .playbackOptions
                                .repeatMode
                                .index,
                            onSelected: (index) => SpotifySdk.setRepeatMode(
                                repeatMode: RepeatMode.values.elementAt(index)),
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0))),
                            color: const Color.fromARGB(255, 51, 54, 68),
                            icon: _repeatIcon[SpotifyHelper()
                                .playerState
                                .playbackOptions
                                .repeatMode
                                .index],
                            padding: EdgeInsets.zero,
                            clipBehavior: Clip.hardEdge,
                            constraints: BoxConstraints(
                                minWidth: screenSize.width * 0.09722222,
                                maxWidth: screenSize.width * 0.09722222),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ]),
            ),
          ],
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
