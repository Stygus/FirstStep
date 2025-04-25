import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;
import 'package:rive/rive.dart';

Future<RiveFile> loadRiveFiles(String path) async {
  final riveFile = await RiveFile.asset(path);
  return riveFile;
}

final Map<String, Future<RiveFile>> riveFiles = {
  "stepus": loadRiveFiles("assets/Animacje/stepus.riv"),
};

final animationsProvider = riverpod.Provider<Map<String, Future<RiveFile>>>((
  ref,
) {
  return riveFiles;
});
