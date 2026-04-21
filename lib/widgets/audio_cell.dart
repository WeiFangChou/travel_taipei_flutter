import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:travel_taipei_flutter/models/travel/audio_model.dart';

class AudioCell extends StatelessWidget {
  final AudioModel item;

  final VoidCallback onDownload;
  final VoidCallback onPlay;

  const AudioCell({
    super.key,
    required this.item,
    required this.onDownload,
    required this.onPlay,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // 加上底線模擬 ListTile 的效果
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // 讓左右兩邊都從頂部對齊
        children: [
          // 左側：文字資訊區
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 16), // 左右間距
          // 右側：按鈕與日期區
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end, // 讓日期跟按鈕右對齊
            children: [
              _buildTrailingWidget(),
              const SizedBox(height: 4),
              Text(
                formatDate(item.modified.toString()),
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTrailingWidget() {
    // 定義統一的寬度與高度
    const double fixedWidth = 105.0;
    const double fixedHeight = 40.0;

    // 1. 已下載：播放按鈕
    if (item.isDownloaded) {
      return SizedBox(
        width: fixedWidth,
        height: fixedHeight,
        child: ElevatedButton.icon(
          onPressed: onPlay,
          icon: const Icon(Icons.play_arrow, size: 18),
          label: const Text("播放"),
          style: ElevatedButton.styleFrom(padding: EdgeInsets.zero),
        ),
      );
    }

    // 2. 下載中：與按鈕同寬高的進度容器
    if (item.isDownloading) {
      return Container(
        width: fixedWidth,
        height: fixedHeight,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LinearProgressIndicator(
              value: item.progress,
              backgroundColor: Colors.grey.shade200,
              color: Colors.blue,
              minHeight: 4, // 稍微加厚一點點
            ),
            const SizedBox(height: 2),
            Text(
              "${(item.progress * 100).toInt()}%",
              style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
    }

    // 3. 未下載：下載按鈕
    return SizedBox(
      width: fixedWidth,
      height: fixedHeight,
      child: OutlinedButton.icon(
        onPressed: onDownload,
        icon: const Icon(Icons.download, size: 18),
        label: const Text("下載"),
        style: OutlinedButton.styleFrom(padding: EdgeInsets.zero),
      ),
    );
  }
}

String formatDate(String dateString) {
  // 1. 解析原始字串成 DateTime 物件
  // DateTime.parse 可以處理 "2025-12-10 15:55:41 +08:00" 這種格式
  DateTime dateTime = DateTime.parse(dateString);

  // 2. 定義輸出的格式 (MM/dd HH:mm)
  // M 代表月份, d 代表日期, H 代表 24 小時制
  return DateFormat('MM/dd HH:mm').format(dateTime);
}
