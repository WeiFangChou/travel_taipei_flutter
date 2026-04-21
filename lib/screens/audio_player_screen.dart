import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:travel_taipei_flutter/models/travel/audio_model.dart';

class PlayerScreen extends StatefulWidget {
  final AudioModel item;
  PlayerScreen({required this.item});

  @override
  _PlayerScreenState createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  late AudioPlayer _player;
  bool _isPlaying = false;
  bool _isDragging = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();
    _initPlayer();
  }

  void _initPlayer() {
    _player = AudioPlayer();
    _player.onDurationChanged.listen((duration) {
      if (!mounted || duration == Duration.zero) return;
      setState(() => _duration = duration);
    });
    _player.onPositionChanged.listen((position) {
      if (!mounted || _isDragging) return;
      setState(() => _position = position);
    });
    _player.onPlayerStateChanged.listen((state) {
      if (!mounted) return;
      setState(() => _isPlaying = state == PlayerState.playing);
    });
    _setAudioSource();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _setAudioSource() async {
    await _player.setSource(DeviceFileSource(widget.item.localPath));
  }

  void _togglePlay() async {
    _isPlaying ? _player.pause() : _player.resume();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("正在播放 ${widget.item.title}")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.audiotrack, size: 100),
            SizedBox(height: 20),
            Text(
              widget.item.title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              "audio_${widget.item.id}.mp3",
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 40),

            Slider(
              min: 0,
              max: _duration.inMilliseconds > 0
                  ? _duration.inMilliseconds.toDouble()
                  : 1.0,
              value: _position.inMilliseconds.toDouble().clamp(
                0,
                _duration.inMilliseconds.toDouble(),
              ),
              // 托拉時更新
              onChanged: (value) async {
                setState(
                  () => _position = Duration(milliseconds: value.toInt()),
                );
              },
              // 拖動開始
              onChangeStart: (value) {
                setState(() => _isDragging = true);
              },
              // 拖動結束
              onChangeEnd: (value) async {
                final position = Duration(milliseconds: value.toInt());
                await _player.seek(position);
                setState(() => _isDragging = false);
              },
            ),
            Text(
              "${_position.toString().split('.').first} / ${_duration.toString().split('.').first}",
            ),
            SizedBox(height: 40),

            CircleAvatar(
              radius: 40,
              child: IconButton(
                iconSize: 40,
                icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                onPressed: _togglePlay,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
