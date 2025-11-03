import 'package:flutter/material.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';

class PlaylistDetailsPage extends StatefulWidget {
  final PlaylistModel playlist;

  const PlaylistDetailsPage({
    Key? key,
    required this.playlist,
  }) : super(key: key);

  @override
  State<PlaylistDetailsPage> createState() => _PlaylistDetailsPageState();
}

class _PlaylistDetailsPageState extends State<PlaylistDetailsPage> {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  List<SongModel> _songs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPlaylistSongs();
  }

  Future<void> _loadPlaylistSongs() async {
    try {
      final songs = await _audioQuery.queryAudiosFrom(
        AudiosFromType.PLAYLIST,
        widget.playlist.id,
      );
      setState(() {
        _songs = songs;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.playlist.playlist),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _songs.isEmpty
              ? const Center(
                  child: Text(
                    'No songs in this playlist',
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : ListView.builder(
                  itemCount: _songs.length,
                  itemBuilder: (context, index) {
                    final song = _songs[index];
                    return ListTile(
                      leading: QueryArtworkWidget(
                        id: song.id,
                        type: ArtworkType.AUDIO,
                        nullArtworkWidget: const Icon(
                          Icons.music_note,
                          size: 40,
                        ),
                      ),
                      title: Text(
                        song.displayNameWOExt,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        'id: ${song.id} - ${song.artist ?? "Unknown Artist"}',
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Text(
                        _formatDuration(song.duration ?? 0),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      onTap: () {
                        // Handle song tap (play song)
                      },
                    );
                  },
                ),
    );
  }

  String _formatDuration(int duration) {
    final minutes = duration ~/ 60000;
    final seconds = (duration % 60000) ~/ 1000;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
