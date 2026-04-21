import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:travel_taipei_flutter/models/travel/audio_model.dart';

class FileService {
  Directory? _cacheDir;

  Future<Directory> get cacheDir async {
    _cacheDir ??= await getApplicationCacheDirectory();
    return _cacheDir!;
  }

  Future<void> resolveLocalPaths(List<AudioModel> items) async {
    final dir = await cacheDir;
    for (var item in items) {
      final fileName = 'audio_${item.id}.mp3';
      item.localPath = '${dir.path}/$fileName';
      item.isDownloaded = File(item.localPath).existsSync();
    }
  }
}
