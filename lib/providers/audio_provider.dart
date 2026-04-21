import 'package:flutter/foundation.dart';
import 'package:travel_taipei_flutter/models/travel/audio_model.dart';
import 'package:travel_taipei_flutter/services/api_service.dart';
import 'package:travel_taipei_flutter/services/file_service.dart';

class AudioProvider extends ChangeNotifier {
  final ApiService _apiService;
  final FileService _fileService;

  AudioProvider({
    required ApiService apiService,
    required FileService fileService,
  })  : _apiService = apiService,
        _fileService = fileService;

  final List<AudioModel> _audioList = [];
  List<AudioModel> get audioList => _audioList;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  int _currentPage = 1;

  Future<void> fetchData() async {
    if (_isLoading) return;
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiService.fetchAudioList(page: _currentPage);
      await _fileService.resolveLocalPaths(response.data);

      _audioList.addAll(response.data);
      _currentPage++;
    } catch (e) {
      if (kDebugMode) {
        print('API Error: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> downloadAudio(int index) async {
    final item = _audioList[index];
    if (item.isDownloading || item.isDownloaded) return;

    item.isDownloading = true;
    item.progress = 0.0;
    notifyListeners();

    try {
      await _apiService.downloadFile(
        url: item.url,
        savePath: item.localPath,
        onProgress: (progress) {
          item.progress = progress;
          notifyListeners();
        },
      );

      item.isDownloaded = true;
      item.isDownloading = false;
      notifyListeners();
    } catch (e) {
      item.isDownloading = false;
      item.progress = 0.0;
      notifyListeners();
      if (kDebugMode) {
        print('Download Error: $e');
      }
    }
  }
}
