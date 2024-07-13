import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart' as spotify;

import '../utils/constants.dart';

class SpotifyPlaylistPage extends StatefulWidget {
  final spotify.Pages playlistTracks;
  const SpotifyPlaylistPage(this.playlistTracks, {Key? key}) : super(key: key);

  @override
  State createState() {
    return _SpotifyPlaylistPageState();
  }
}

class _SpotifyPlaylistPageState extends State<SpotifyPlaylistPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.sizeOf(context);
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
        child: Container());
  }
}
