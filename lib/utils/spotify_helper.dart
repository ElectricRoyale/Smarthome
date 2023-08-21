import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:spotify_openapi/spotify_openapi.dart';
import 'package:spotify_sdk/models/player_state.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

import 'globals.dart';

class SpotifyHelper {
  final _clientId = 'e927d2ad3e854aa2b133e99ad08d3f69';
  final _redirectUrl = 'smarthome://';
  PlayerState? _playerState;
  Uint8List? _trackImage, _previousTrackImage, _nextTrackImage;
  Color? _imageColor;
  bool _favourite = false;
  List<QueueObjectQueueInner> _queue = [];
  String _accessToken = '';
  final String _scopes =
      "user-read-playback-state, user-modify-playback-state, user-read-currently-playing, app-remote-control, streaming, playlist-read-private, playlist-read-collaborative, playlist-modify-private, playlist-modify-public, user-follow-modify, user-follow-read, user-read-playback-position, user-top-read, user-read-recently-played, user-library-modify, user-library-read, user-read-email, user-read-private";
  PlayHistoryObject? _recentlyPlayedSong;
  List<SimplifiedPlaylistObject> _playlists = [];

  late DateTime _beginning;

  late StreamController _progressController;
  late StreamSubscription _progressSubscription;

  static final SpotifyHelper _instance = SpotifyHelper._internal();

  factory SpotifyHelper() => _instance;

  SpotifyHelper._internal();

  Future<void> init() async {
    await SpotifySdk.connectToSpotifyRemote(
        clientId: _clientId, redirectUrl: _redirectUrl);
    _accessToken = await SpotifySdk.getAccessToken(
      clientId: _clientId,
      redirectUrl: _redirectUrl,
      scope: _scopes,
    );
    Stream.periodic(
        const Duration(hours: 1),
        (_) async => _accessToken = await SpotifySdk.getAccessToken(
              clientId: _clientId,
              redirectUrl: _redirectUrl,
              scope: _scopes,
            ));
    _playerState = await SpotifySdk.getPlayerState();
    _beginning = DateTime.now().subtract(const Duration(seconds: 1));
    _progressController = StreamController.broadcast();
    _progressSubscription = Stream<int>.periodic(
            const Duration(seconds: 1),
            (timer) =>
                (_playerState?.playbackPosition ?? 0) +
                DateTime.now().difference(_beginning).inMilliseconds)
        .listen((event) => _progressController.add(event));
    _checkPlaying();
    _trackImage =
        await SpotifySdk.getImage(imageUri: _playerState!.track!.imageUri);
    _imageColor = (await PaletteGenerator.fromImageProvider(
      Image.memory(_trackImage!,
              gaplessPlayback: true, filterQuality: FilterQuality.high)
          .image,
      maximumColorCount: 20,
    ))
        .vibrantColor
        ?.color;
    _favourite = (await SpotifySdk.getLibraryState(
            spotifyUri: _playerState!.track!.uri))!
        .isSaved;
    /*_queue = (await SpotifyOpenapi()
                .getPlayerApi()
                .getQueue(headers: {'Authorization': 'Bearer $_accessToken'}))
            .data
            ?.queue
            ?.asList() ??
        [];
    _recentlyPlayedSong = (await SpotifyOpenapi()
            .getPlayerApi()
            .getRecentlyPlayed(
                limit: 1, headers: {'Authorization': 'Bearer $_accessToken'}))
        .data
        ?.items
        ?.first;
     _previousTrackImage = await SpotifySdk.getImage(
        imageUri:
            ImageUri((_queue.first.oneOf.value as TrackObject).uri.toString()));
    _nextTrackImage = await SpotifySdk.getImage(
        imageUri: ImageUri(_recentlyPlayedSong!.track!.uri!.toString()));
    _playlists = (await SpotifyOpenapi()
            .getPlaylistsApi()
            .getAListOfCurrentUsersPlaylists(
                headers: {'Authorization': 'Bearer $_accessToken'}))
        .data!
        .items
        .asList();*/
    _updating();
  }

  void _checkPlaying() {
    if (_playerState?.isPaused ?? true) {
      _progressSubscription.pause();
    } else {
      _beginning = DateTime.now();
      _progressSubscription.resume();
    }
  }

  void _updating() {
    SpotifySdk.subscribePlayerState().listen((newState) async {
      _playerState = newState;
      _checkPlaying();
      _favourite = (await SpotifySdk.getLibraryState(
              spotifyUri: _playerState!.track!.uri))!
          .isSaved;
      _trackImage =
          await SpotifySdk.getImage(imageUri: _playerState!.track!.imageUri);
      _imageColor = (await PaletteGenerator.fromImageProvider(Image.memory(
                  _trackImage!,
                  gaplessPlayback: true,
                  filterQuality: FilterQuality.high)
              .image))
          .dominantColor
          ?.color;
      /*_queue = (await SpotifyOpenapi()
                  .getPlayerApi()
                  .getQueue(headers: {'Authorization': 'Bearer $_accessToken'}))
              .data
              ?.queue
              ?.asList() ??
          [];
      _recentlyPlayedSong = (await SpotifyOpenapi()
              .getPlayerApi()
              .getRecentlyPlayed(
                  limit: 1, headers: {'Authorization': 'Bearer $_accessToken'}))
          .data
          ?.items
          ?.first;
      _previousTrackImage = await SpotifySdk.getImage(
          imageUri: ImageUri(
              (_queue.first.oneOf.value as TrackObject).uri.toString()));
      _nextTrackImage = await SpotifySdk.getImage(
          imageUri: ImageUri(_recentlyPlayedSong!.track!.uri!.toString()));
      _playlists = (await SpotifyOpenapi()
              .getPlaylistsApi()
              .getAListOfCurrentUsersPlaylists(
                  headers: {'Authorization': 'Bearer $_accessToken'}))
          .data!
          .items
          .asList();*/
      spotifyControllRefresh.call();
    });
  }

  void reorderQueue(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
  }

  PlayerState get playerState => _playerState!;

  Uint8List get trackImage => _trackImage!;

  Uint8List get previousTrackImage => _previousTrackImage!;

  Uint8List get nextTrackImage => _nextTrackImage!;

  Stream get position => _progressController.stream;

  Color? get imageColor => _imageColor;

  bool get favorite => _favourite;

  List<QueueObjectQueueInner> get queue => _queue;

  PlayHistoryObject? get recentlyPlayedSong => _recentlyPlayedSong;

  List<SimplifiedPlaylistObject> get playlists => _playlists;
}
