import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:music_player/models/audio_model.dart';

class AudioService with ChangeNotifier {
  final AudioPlayer audioPlayer = AudioPlayer();
  List<AudioModel> audioFiles = [];
  bool isPlaying = false;
  bool isLoading = false;
  String? currentAudioPath;

  AudioService() {
    audioPlayer.onPlayerComplete.listen((event) {
      isPlaying = false;
      notifyListeners();
    });
  }

  Future<void> loadAudioFiles() async {
    isLoading = true;
    notifyListeners();

    if (await _requestPermissions()) {
      final directory = await getApplicationDocumentsDirectory();
      final files = directory.listSync().whereType<File>().toList();

      audioFiles = files.where((file) => file.path.endsWith('.mp3') || file.path.endsWith('.aac') || file.path.endsWith('.wav')).map((file) => AudioModel.fromPath(file.path)).toList();

      isLoading = false;
      notifyListeners();
    } else {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> pickAudioFile() async {
    if (await _requestPermissions()) {
      FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.audio);

      if (result != null) {
        File file = File(result.files.single.path!); // Ensure non-null
        final appDir = await getApplicationDocumentsDirectory();
        final newPath = '${appDir.path}/${result.files.single.name}';
        await file.copy(newPath);

        audioFiles.add(AudioModel.fromPath(newPath));
        notifyListeners();
      }
    }
  }

  Future<bool> _requestPermissions() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      status = await Permission.storage.request();
      return status.isGranted;
    }
    return true;
  }

  Future<void> playAudio(String filePath) async {
    try {
      await audioPlayer.play(DeviceFileSource(filePath));
      isPlaying = true;
      currentAudioPath = filePath;
      notifyListeners();
    } catch (e) {
      print('Error playing audio: $e');
    }
  }

  Future<void> pauseAudio() async {
    await audioPlayer.pause();
    isPlaying = false;
    notifyListeners();
  }

  Future<void> resumeAudio() async {
    await audioPlayer.resume();
    isPlaying = true;
    notifyListeners();
  }

  Future<void> stopAudio() async {
    await audioPlayer.stop();
    isPlaying = false;
    notifyListeners();
  }
}
