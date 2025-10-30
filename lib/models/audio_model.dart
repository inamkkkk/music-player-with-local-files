class AudioModel {
  final String name;
  final String path;

  AudioModel({required this.name, required this.path});

  factory AudioModel.fromPath(String path) {
    String name = path.split('/').last;
    return AudioModel(name: name, path: path);
  }
}
