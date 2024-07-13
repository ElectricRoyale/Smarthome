import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:spotify/spotify.dart' as spotify;
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
  List<spotify.Track> _queue = [];
  String _accessToken = '';
  final List<String> _scopes = [
    "ugc-image-upload",
    "user-read-playback-state",
    "user-modify-playback-state",
    "user-read-currently-playing",
    "app-remote-control",
    "streaming",
    "playlist-read-private",
    "playlist-read-collaborative",
    "playlist-modify-private",
    "playlist-modify-public",
    "user-follow-modify",
    "user-follow-read",
    "user-read-playback-position",
    "user-top-read",
    "user-read-recently-played",
    "user-library-modify",
    "user-library-read",
    "user-read-email",
    "user-read-private"
  ];
  spotify.PlayHistory? _recentlyPlayedSong;
  List<spotify.PlaylistSimple> _playlists = [];

  late spotify.SpotifyApi _spotify;

  late DateTime _beginning;

  late StreamController _progressController;
  late StreamSubscription _progressSubscription;

  static final SpotifyHelper _instance = SpotifyHelper._internal();

  factory SpotifyHelper() => _instance;

  SpotifyHelper._internal();

  Future<void> init() async {
    _accessToken = await SpotifySdk.getAccessToken(
      clientId: _clientId,
      redirectUrl: _redirectUrl,
      scope: _scopes.join(', '),
    );
    Stream.periodic(
        const Duration(hours: 1),
        (_) async => _accessToken = await SpotifySdk.getAccessToken(
              clientId: _clientId,
              redirectUrl: _redirectUrl,
              scope: _scopes.join(', '),
            ));
    _spotify = spotify.SpotifyApi.withAccessToken(_accessToken);
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
    _queue = (await _spotify.player.queue()).queue ?? [];
    /*_recentlyPlayedSong =
        (await _spotify.me.recentlyPlayed(limit: 1).first()).items?.first;
    _previousTrackImage =
        (await get(Uri.parse(_recentlyPlayedSong?.track?.uri ?? ""))).bodyBytes;
    _nextTrackImage = (await get(Uri.parse(_queue.first. ?? ''))).bodyBytes;*/
    _playlists = (await _spotify.playlists.me.all()).toList()
      ..sort((a, b) => a.name!.compareTo(b.name!));
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
      _queue = (await _spotify.player.queue()).queue ?? [];
      /*_previousTrackImage = await SpotifySdk.getImage(
          imageUri: ImageUri(
              _queue.first.uri ?? ''));
      _nextTrackImage = await SpotifySdk.getImage(
          imageUri: ImageUri(_recentlyPlayedSong!.track!.uri!));*/
      _recentlyPlayedSong =
          (await _spotify.me.recentlyPlayed(limit: 1).first()).items?.first;
      _playlists = (await _spotify.playlists.me.all()).toList()
        ..sort((a, b) => a.name!.compareTo(b.name!));
      spotifyControllRefresh.call();
    });
  }

  void reorderQueue(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
  }

  Future<spotify.Pages<spotify.Track>> getPlaylistTracks(playlistId) async =>
      _spotify.playlists.getTracksByPlaylistId(playlistId);

  PlayerState get playerState => _playerState!;

  Uint8List get trackImage => _trackImage!;

  Uint8List get previousTrackImage => _previousTrackImage!;

  Uint8List get nextTrackImage => _nextTrackImage!;

  Stream get position => _progressController.stream;

  Color? get imageColor => _imageColor;

  bool get favorite => _favourite;

  List<spotify.Track> get queue => _queue;

  spotify.PlayHistory? get recentlyPlayedSong => _recentlyPlayedSong;

  List<spotify.PlaylistSimple> get playlists => _playlists;
}
