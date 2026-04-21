import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_taipei_flutter/providers/audio_provider.dart';
import 'package:travel_taipei_flutter/screens/audio_list_screen.dart';
import 'package:travel_taipei_flutter/services/api_service.dart';
import 'package:travel_taipei_flutter/services/file_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AudioProvider(
            apiService: ApiService(),
            fileService: FileService(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Travel Taipei',
        home: const MyHomePage(),
        debugShowCheckedModeBanner: kDebugMode,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Travel Taipei"),
        backgroundColor: Colors.white,
        shape: Border(
          bottom: BorderSide(color: Colors.grey.shade100, width: 1.0),
        ),
      ),
      body: AudioListScreen(),
    );
  }
}
