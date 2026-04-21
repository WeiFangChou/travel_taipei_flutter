import 'package:dio/dio.dart';
import 'package:travel_taipei_flutter/models/travel/attractions_audio.dart';

class ApiService {
  static const String _baseUrl = 'https://www.travel.taipei/open-api';

  final Dio _dio;

  ApiService()
      : _dio = Dio(
          BaseOptions(
            baseUrl: _baseUrl,
            headers: {'Accept': 'application/json'},
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10),
          ),
        );

  Future<AudioResponse> fetchAudioList({
    Lang lang = Lang.zhtw,
    int page = 1,
  }) async {
    final request = AudioRequest(lang: lang, page: page);
    final path = request.getPath('/{lang}/Media/Audio');

    final response = await _dio.get(
      path,
      queryParameters: request.toQueryParams(),
    );

    return AudioResponse.fromJson(response.data);
  }

  Future<void> downloadFile({
    required String url,
    required String savePath,
    void Function(double progress)? onProgress,
  }) async {
    await Dio().download(
      url,
      savePath,
      onReceiveProgress: (count, total) {
        if (total > 0 && onProgress != null) {
          onProgress(count / total);
        }
      },
    );
  }
}
