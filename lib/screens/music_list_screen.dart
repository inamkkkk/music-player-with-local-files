import 'package:flutter/material.dart';
import 'package:music_player/models/audio_model.dart';
import 'package:provider/provider.dart';
import 'package:music_player/services/audio_service.dart';

class MusicListScreen extends StatefulWidget {
  @override
  _MusicListScreenState createState() => _MusicListScreenState();
}

class _MusicListScreenState extends State<MusicListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AudioService>(context, listen: false).loadAudioFiles();
    });
  }

  @override
  Widget build(BuildContext context) {
    final audioService = Provider.of<AudioService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Music Player'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              audioService.pickAudioFile();
            },
          ),
        ],
      ),
      body: audioService.isLoading
          ? Center(child: CircularProgressIndicator())
          : audioService.audioFiles.isEmpty
              ? Center(child: Text('No music files found.'))
              : ListView.builder(
                  itemCount: audioService.audioFiles.length,
                  itemBuilder: (context, index) {
                    AudioModel audioFile = audioService.audioFiles[index];
                    return ListTile(
                      title: Text(audioFile.name),
                      subtitle: Text(audioFile.path),
                      onTap: () {
                        audioService.playAudio(audioFile.path);
                      },
                    );
                  },
                ),
      bottomNavigationBar: audioService.currentAudioPath != null
          ? Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(color: Colors.grey[200]),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: Icon(Icons.pause),
                    onPressed: audioService.isPlaying ? () => audioService.pauseAudio() : null,
                  ),
                  IconButton(
                    icon: Icon(Icons.play_arrow),
                    onPressed: !audioService.isPlaying ? () => audioService.resumeAudio() : null,
                  ),
                  Text(audioService.currentAudioPath!.split('/').last),
                ],
              ),
            )
          : null,
    );
  }
}
