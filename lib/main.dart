import 'package:flutter/material.dart';
import 'package:music_player/screens/music_list_screen.dart';
import 'package:provider/provider.dart';
import 'package:music_player/services/audio_service.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void main() {
  getIt.registerSingleton<AudioService>(AudioService());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => getIt<AudioService>()),
      ],
      child: MaterialApp(
        title: 'Music Player',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MusicListScreen(),
      ),
    );
  }
}
