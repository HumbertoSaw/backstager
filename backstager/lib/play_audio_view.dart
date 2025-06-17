import 'dart:io';
import 'package:flutter/material.dart';

class PlayAudioView extends StatefulWidget {
  final FileSystemEntity audioFile;

  const PlayAudioView({super.key, required this.audioFile});

  @override
  State<PlayAudioView> createState() => _PlayAudioViewState();
}

class _PlayAudioViewState extends State<PlayAudioView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fileName = widget.audioFile.path.split('/').last;

    return Scaffold(
      appBar: AppBar(title: Text(fileName)),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [],
        ),
      ),
    );
  }
}
