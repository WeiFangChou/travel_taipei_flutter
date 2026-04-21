import 'package:travel_taipei_flutter/models/travel/audio_model.dart';

class AudioRequest {
  final Lang lang; // Path parameter (必填)
  final int page; // Query parameter (預設為 1)

  AudioRequest({required this.lang, this.page = 1});

  // 將 Query 參數轉換為 Map，方便給 Dio 或 Http 套件使用
  Map<String, dynamic> toQueryParams() {
    return {'page': page};
  }

  // 取得完整路徑 (處理 Path parameter)
  String getPath(String basePath) {
    // 假設原始路徑是 /api/{lang}/products
    return basePath.replaceFirst('{lang}', lang.value);
  }
}

/*
zh-tw -正體中文
zh-cn -簡體中文
en -英文
ja -日文
ko -韓文
*/

enum Lang { zhtw, zhcn, en, ja, ko }

extension LangExtension on Lang {
  String get value {
    switch (this) {
      case Lang.zhtw:
        return 'zh-tw';
      case Lang.zhcn:
        return 'zh-cn';
      case Lang.en:
        return 'en';
      case Lang.ja:
        return 'ja';
      case Lang.ko:
        return 'ko';
    }
  }
}

class AudioResponse {
  final int total;
  final List<AudioModel> data;

  AudioResponse({required this.total, required this.data});

  factory AudioResponse.fromJson(Map<String, dynamic> json) {
    return AudioResponse(
      total: json['total'] ?? 0,
      // 這裡就是你提到的關鍵轉換點
      data: (json['data'] as List)
          .map((item) => AudioModel.fromJson(item))
          .toList(),
    );
  }
}
