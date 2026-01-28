import 'package:flutter/material.dart';
import 'package:on_audio_query_plus/on_audio_query.dart';

class AlbumsPage extends StatefulWidget {
  const AlbumsPage({Key? key}) : super(key: key);

  @override
  State<AlbumsPage> createState() => _AlbumsPageState();
}

class _AlbumsPageState extends State<AlbumsPage> {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  bool isLoading = true;
  List<AlbumModel> albums = [];

  @override
  void initState() {
    fetchAlbums();
    super.initState();
  }

  Future<void> fetchAlbums() async {
    try {
      albums = await _audioQuery.queryAlbums();
      setState(() {});
    } catch (e) {
      // Handle error if needed
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Albums'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: albums.length,
              itemBuilder: (context, index) {
                final album = albums[index];
                return ListTile(
                  leading: QueryArtworkWidget(
                    id: album.id,
                    type: ArtworkType.ALBUM,
                    nullArtworkWidget: const Icon(Icons.album),
                  ),
                  title: Text(album.album),
                  subtitle: Text('${album.numOfSongs} songs'),
                );
              },
            ),
    );
  }
}
