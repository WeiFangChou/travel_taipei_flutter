class AudioModel {
  final int id;
  final String title;
  final String? summary;
  final String url;
  final String? file_ext;
  final DateTime? modified;

  String localPath = "";
  bool isDownloaded = false;
  bool isDownloading = false;
  double progress = 0;

  AudioModel({
    required this.id,
    required this.title,
    required this.url,
    this.summary,
    this.file_ext,
    this.modified,
  });

  factory AudioModel.fromJson(Map<String, dynamic> json) {
    return AudioModel(
      id: json['id'] as int,
      title: json['title'] as String,
      url: json['url'] as String,
      summary: json['summary'] as String?,
      file_ext: json['file_ext'] as String?,
      modified: json['modified'] != null
          ? DateTime.parse(json['modified'])
          : null,
    );
  }
}
