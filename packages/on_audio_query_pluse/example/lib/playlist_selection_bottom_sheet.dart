import 'package:flutter/material.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';

class PlaylistSelectionBottomSheet extends StatelessWidget {
  final _audioQuery = OnAudioQuery();

  PlaylistSelectionBottomSheet({Key? key}) : super(key: key);

  static Future<PlaylistModel?> show(BuildContext context) {
    return showModalBottomSheet<PlaylistModel>(
      context: context,
      builder: (context) => PlaylistSelectionBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: FutureBuilder(
          future: _audioQuery.queryPlaylists(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || (snapshot.data as List).isEmpty) {
              return const Center(child: Text('No Playlists Found'));
            } else {
              final playlists = snapshot.data as List<PlaylistModel>;
              return ListView.builder(
                itemCount: playlists.length,
                itemBuilder: (context, index) {
                  final playlist = playlists[index];
                  return ListTile(
                    title: Text(playlist.playlist),
                    subtitle: Text('${playlist.numOfSongs} songs'),
                    onTap: () {
                      Navigator.pop(context, playlist);
                    },
                  );
                },
              );
            }
          }),
    );
  }
}
