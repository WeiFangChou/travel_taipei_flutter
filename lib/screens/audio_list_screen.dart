import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_taipei_flutter/providers/audio_provider.dart';
import 'package:travel_taipei_flutter/screens/audio_player_screen.dart';
import 'package:travel_taipei_flutter/widgets/audio_cell.dart';

class AudioListScreen extends StatefulWidget {
  @override
  _AudioListScreenState createState() => _AudioListScreenState();
}

class _AudioListScreenState extends State<AudioListScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AudioProvider>().fetchData();
    });
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        context.read<AudioProvider>().fetchData();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AudioProvider>();
    final audioList = provider.audioList;
    final isLoading = provider.isLoading;

    if (audioList.isEmpty && isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (audioList.isEmpty && !isLoading) {
      return Center(child: Text("沒有資料"));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: audioList.length,
      itemBuilder: (context, index) {
        final item = audioList[index];
        return AudioCell(
          item: item,
          onDownload: () => context.read<AudioProvider>().downloadAudio(index),
          onPlay: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PlayerScreen(item: item)),
            );
          },
        );
      },
      controller: _scrollController,
    );
  }
}
