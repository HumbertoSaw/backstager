import 'dart:async';
import 'dart:io';
import 'package:backstager/l10n/app_localizations.dart';
import 'package:backstager/models/ClipProgressBar.dart';
import 'package:backstager/components/clip_components/create_clip_component.dart';
import 'package:backstager/database/clip_dao.dart';
import 'package:backstager/database/database_conn.dart';
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
  Duration get _audioDuration => _duration ?? Duration.zero;

  StreamSubscription? _durationSubscription;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _playerCompleteSubscription;
  StreamSubscription? _playerStateChangeSubscription;

  bool get _isPlaying => _playerState == PlayerState.playing;
  bool get _isPaused => _playerState == PlayerState.paused;

  final MediaClipDao clipDao = MediaClipDao(DatabaseConn.instance);
  List<MediaClip> _clips = [];
  int? _selectedClipId;
  Timer? _clipEndTimer;

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

  @override
  void dispose() {
    _clipEndTimer?.cancel();
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _playerCompleteSubscription?.cancel();
    _playerStateChangeSubscription?.cancel();
    _player.dispose();
    super.dispose();
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

  String formatTime(double seconds) {
    final duration = Duration(milliseconds: (seconds * 1000).round());
    final twoDigits = (int n) => n.toString().padLeft(2, '0');
    final hours = duration.inHours;
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final secs = twoDigits(duration.inSeconds.remainder(60));
    return hours > 0 ? "$hours:$minutes:$secs" : "$minutes:$secs";
  }

  Future<void> _deleteMediaClip(MediaClip clip) async {
    try {
      await clipDao.deleteMediaClip(clip.id!);
      if (_selectedClipId == clip.id) {
        setState(() => _selectedClipId = null);
        _clipEndTimer?.cancel();
      }
      await _loadClips();
    } catch (e) {
      final t = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(t.audioPlayerClipDeletionFailed)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
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
                  ? '${_position.toString().split('.').first} / ${_duration.toString().split('.').first}'
                  : _duration != null
                  ? _duration.toString().split('.').first
                  : '',
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 20),
            _createClipButton(t),
            const SizedBox(height: 10),
            _clipList(t),
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
          boxShadow: const [
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

  Widget _clipList(AppLocalizations t) {
    return Expanded(
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _clips.isEmpty
          ? Center(
              child: Text(
                t.audioPlayerNoClips,
                style: const TextStyle(color: Colors.grey),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: _clips.map((clip) {
                  final isSelected = _selectedClipId == clip.id;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Dismissible(
                      key: Key(clip.id.toString()),
                      direction: DismissDirection.startToEnd,
                      background: Container(
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(left: 20),
                        child: const Icon(
                          Icons.delete,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      confirmDismiss: (direction) async {
                        final confirmed = await showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text(
                              'Delete Clip',
                              style: TextStyle(
                                color: Color.fromARGB(255, 80, 80, 80),
                              ),
                            ),
                            content: Text(
                              'Are you sure you want to delete "${clip.name}"?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: Text(
                                  t.audioPlayerDelete,
                                  style: const TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        );
                        return confirmed;
                      },
                      onDismissed: (direction) async {
                        await _deleteMediaClip(clip);
                      },
                      movementDuration: const Duration(milliseconds: 200),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () async {
                            final isSelected = _selectedClipId == clip.id;
                            if (isSelected) {
                              await _pause();
                              setState(() => _selectedClipId = null);
                              _clipEndTimer?.cancel();
                            } else {
                              final start = Duration(
                                milliseconds: (clip.startAt * 1000).round(),
                              );
                              final end = Duration(
                                milliseconds: (clip.endAt * 1000).round(),
                              );
                              await _player.seek(start);
                              await _play();
                              _clipEndTimer?.cancel();
                              _clipEndTimer = Timer(end - start, () {
                                _stop();
                                setState(() => _selectedClipId = null);
                              });
                              setState(() => _selectedClipId = clip.id);
                            }
                          },
                          child: Card(
                            elevation: 0,
                            margin: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(
                                color: _parseColor(clip.color),
                                width: 2,
                              ),
                            ),
                            color: isSelected ? _parseColor(clip.color) : null,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: ListTile(
                                leading: Icon(
                                  Icons.cut,
                                  color: isSelected
                                      ? Colors.white
                                      : _parseColor(clip.color),
                                ),
                                title: Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            clip.name,
                                            style: TextStyle(
                                              color: isSelected
                                                  ? Colors.white
                                                  : const Color(0xFF5C5C5C),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            '${formatTime(clip.startAt)} - ${formatTime(clip.endAt)}',
                                            style: TextStyle(
                                              color: isSelected
                                                  ? Colors.white70
                                                  : Colors.black54,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (_duration != null)
                                      Expanded(
                                        flex: 3,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            left: 8.0,
                                          ),
                                          child: ClipProgressBar(
                                            startAt: clip.startAt,
                                            endAt: clip.endAt,
                                            totalDuration: _audioDuration,
                                            color: isSelected
                                                ? Colors.white
                                                : _parseColor(clip.color),
                                            backgroundColor:
                                                Colors.grey.shade300,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
    );
  }

  Padding _createClipButton(AppLocalizations t) {
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
                onClipCreated: () => _loadClips(),
              ),
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.add, size: 25, weight: 700),
              Text(t.audioPlayerCreateClip),
            ],
          ),
        ),
      ),
    );
  }

  Slider _seekBar() {
    return Slider(
      inactiveColor: Colors.grey,
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
            color: _isLooping ? Theme.of(context).primaryColor : Colors.grey,
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
