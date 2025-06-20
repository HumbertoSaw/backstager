import 'dart:async';
import 'dart:io';
import 'package:backstager/components/clip_components/create_clip_component.dart';
import 'package:backstager/database/clip_dao.dart';
import 'package:backstager/database/database_conn.dart';
import 'package:backstager/database/file_dao.dart';
import 'package:backstager/models/MediaClip.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:backstager/models/MediaFile.dart';

class PlayAudioView extends StatefulWidget {
  final MediaFile file;
  final FileSystemEntity audioFile;

  const PlayAudioView({super.key, required this.audioFile, required this.file});

  @override
  State<PlayAudioView> createState() => _PlayAudioViewState();
}

class _PlayAudioViewState extends State<PlayAudioView> {
  late AudioPlayer _player;
  PlayerState? _playerState;
  Duration? _duration;
  Duration? _position;
  bool _isLooping = false;

  StreamSubscription? _durationSubscription;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _playerCompleteSubscription;
  StreamSubscription? _playerStateChangeSubscription;

  bool get _isPlaying => _playerState == PlayerState.playing;
  bool get _isPaused => _playerState == PlayerState.paused;

  String get _durationText => _duration?.toString().split('.').first ?? '';
  String get _positionText => _position?.toString().split('.').first ?? '';

  final MediaClipDao clipDao = MediaClipDao(DatabaseConn.instance);
  List<MediaClip> _clips = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    _player = AudioPlayer();
    _player.setReleaseMode(ReleaseMode.stop);

    _initAudio();
    _loadClips();
    _initStreams();
  }

  Future<void> _loadClips() async {
    final clips = await clipDao.getMediaClipsByFileId(widget.file.id!);
    setState(() {
      _clips = clips;
      _isLoading = false;
    });
  }

  Future<void> _initAudio() async {
    await _player.setSource(DeviceFileSource(widget.audioFile.path));
    await _player.resume();
  }

  void _initStreams() {
    _durationSubscription = _player.onDurationChanged.listen((duration) {
      setState(() => _duration = duration);
    });

    _positionSubscription = _player.onPositionChanged.listen((p) {
      setState(() => _position = p);
    });

    _playerCompleteSubscription = _player.onPlayerComplete.listen((event) {
      setState(() {
        _playerState = PlayerState.stopped;
        _position = Duration.zero;
      });
    });

    _playerStateChangeSubscription = _player.onPlayerStateChanged.listen((
      state,
    ) {
      setState(() => _playerState = state);
    });
  }

  @override
  void dispose() {
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _playerCompleteSubscription?.cancel();
    _playerStateChangeSubscription?.cancel();
    _player.dispose();
    super.dispose();
  }

  Future<void> _play() async {
    await _player.resume();
    setState(() => _playerState = PlayerState.playing);
  }

  Future<void> _pause() async {
    await _player.pause();
    setState(() => _playerState = PlayerState.paused);
  }

  Future<void> _stop() async {
    await _player.stop();
    setState(() {
      _playerState = PlayerState.stopped;
      _position = Duration.zero;
    });
  }

  Color _parseColor(String? colorString) {
    if (colorString == null || colorString.isEmpty) {
      return Colors.grey;
    }

    try {
      final hexColor = colorString.replaceAll('#', '');
      final color = hexColor.length == 6 ? 'FF$hexColor' : hexColor;
      return Color(int.parse(color, radix: 16));
    } catch (e) {
      return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.file.name)),
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Column(
          children: [
            SizedBox(
              height: 200,
              width: 300,
              child: _imageFile(widget.file.imagePath),
            ),
            const SizedBox(height: 20),
            _audioControlls(),

            _seekBar(),
            Text(
              _position != null
                  ? '$_positionText / $_durationText'
                  : _duration != null
                  ? _durationText
                  : '',
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 20),
            _createClipButton(context),
            const SizedBox(height: 14),
            _clipList(),
          ],
        ),
      ),
    );
  }

  Widget _imageFile(String? imagePath) {
    if (imagePath != null && File(imagePath).existsSync()) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.file(
          File(imagePath),
          fit: BoxFit.cover,
          alignment: Alignment.center,
          width: double.infinity,
          height: double.infinity,
        ),
      );
    } else {
      return Container(
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: const Center(
          child: Icon(Icons.audiotrack, size: 100, color: Colors.grey),
        ),
      );
    }
  }

  Expanded _clipList() {
    return Expanded(
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _clips.isEmpty
          ? const Center(
              child: Text(
                "No clips created",
                style: TextStyle(color: Colors.grey),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: _clips.map((clip) {
                  return Card(
                    elevation: 0,
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: _parseColor(clip.color),
                        width: 2,
                      ),
                    ),
                    child: ListTile(
                      leading: Icon(Icons.cut, color: _parseColor(clip.color)),
                      title: Text(clip.name),
                      subtitle: Text(
                        '${clip.startAt.toStringAsFixed(2)}s - ${clip.endAt.toStringAsFixed(2)}s',
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
    );
  }

  Padding _createClipButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            side: BorderSide(width: 2, color: Theme.of(context).primaryColor),
          ),
          onPressed: () {
            if (_duration == null) return;
            showDialog(
              context: context,
              builder: (context) => CreateClipComponent(
                file: widget.file,
                onClipCreated: () {
                  _loadClips();
                },
              ),
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.add, size: 25, weight: 700),
              Text("Create Clip"),
            ],
          ),
        ),
      ),
    );
  }

  Slider _seekBar() {
    return Slider(
      onChanged: (value) {
        final duration = _duration;
        if (duration == null) return;
        final position = value * duration.inMilliseconds;
        _player.seek(Duration(milliseconds: position.round()));
      },
      value:
          (_position != null &&
              _duration != null &&
              _position!.inMilliseconds > 0 &&
              _position!.inMilliseconds < _duration!.inMilliseconds)
          ? _position!.inMilliseconds / _duration!.inMilliseconds
          : 0.0,
    );
  }

  Row _audioControlls() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          key: const Key('play_button'),
          onPressed: _isPlaying ? null : _play,
          iconSize: 48.0,
          icon: const Icon(Icons.play_arrow),
          color: Theme.of(context).primaryColor,
        ),
        IconButton(
          key: const Key('pause_button'),
          onPressed: _isPlaying ? _pause : null,
          iconSize: 48.0,
          icon: const Icon(Icons.pause),
          color: Theme.of(context).primaryColor,
        ),
        IconButton(
          key: const Key('stop_button'),
          onPressed: _isPlaying || _isPaused ? _stop : null,
          iconSize: 48.0,
          icon: const Icon(Icons.stop),
          color: Theme.of(context).primaryColor,
        ),
        IconButton(
          icon: Icon(
            Icons.loop,
            color: _isLooping ? Colors.blueAccent : Colors.grey,
          ),
          onPressed: () {
            setState(() {
              _isLooping = !_isLooping;
              _player.setReleaseMode(
                _isLooping ? ReleaseMode.loop : ReleaseMode.stop,
              );
            });
          },
        ),
      ],
    );
  }
}
