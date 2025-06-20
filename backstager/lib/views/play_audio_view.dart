// import 'dart:async';
// import 'dart:io';
// import 'package:backstager/models/file_clipdart';
// import 'package:flutter/material.dart';
// import 'package:audioplayers/audioplayers.dart';

// class PlayAudioView extends StatefulWidget {
//   final FileSystemEntity audioFile;

//   const PlayAudioView({super.key, required this.audioFile});

//   @override
//   State<PlayAudioView> createState() => _PlayAudioViewState();
// }

// class _PlayAudioViewState extends State<PlayAudioView> {
//   late AudioPlayer _player;
//   PlayerState? _playerState;
//   Duration? _duration;
//   Duration? _position;
//   bool _isLooping = false;

//   StreamSubscription? _durationSubscription;
//   StreamSubscription? _positionSubscription;
//   StreamSubscription? _playerCompleteSubscription;
//   StreamSubscription? _playerStateChangeSubscription;

//   bool get _isPlaying => _playerState == PlayerState.playing;
//   bool get _isPaused => _playerState == PlayerState.paused;

//   String get _durationText => _duration?.toString().split('.').first ?? '';
//   String get _positionText => _position?.toString().split('.').first ?? '';

//   final List<Clip> _cuts = [
//     Clip(start: 0.0, end: 5.0),
//     Clip(start: 5.0, end: 10.0),
//     Clip(start: 10.0, end: 15.0),
//   ];

//   Timer? _cutCheckTimer;

//   @override
//   void initState() {
//     super.initState();

//     _player = AudioPlayer();
//     _player.setReleaseMode(ReleaseMode.stop);

//     _initAudio();
//     _initStreams();
//   }

//   Future<void> _initAudio() async {
//     await _player.setSource(DeviceFileSource(widget.audioFile.path));
//     await _player.resume();
//   }

//   void _initStreams() {
//     _durationSubscription = _player.onDurationChanged.listen((duration) {
//       setState(() => _duration = duration);
//     });

//     _positionSubscription = _player.onPositionChanged.listen((p) {
//       setState(() => _position = p);
//     });

//     _playerCompleteSubscription = _player.onPlayerComplete.listen((event) {
//       setState(() {
//         _playerState = PlayerState.stopped;
//         _position = Duration.zero;
//       });
//     });

//     _playerStateChangeSubscription = _player.onPlayerStateChanged.listen((
//       state,
//     ) {
//       setState(() => _playerState = state);
//     });
//   }

//   @override
//   void dispose() {
//     _durationSubscription?.cancel();
//     _positionSubscription?.cancel();
//     _playerCompleteSubscription?.cancel();
//     _playerStateChangeSubscription?.cancel();
//     _player.dispose();
//     super.dispose();
//   }

//   Widget _buildCutControl(int index, Color color) {
//     final cut = _cuts[index];
//     final totalSeconds = _duration?.inSeconds.toDouble() ?? 30.0;

//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 8),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Theme.of(context).scaffoldBackgroundColor,
//         border: Border.all(color: color, width: 2),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Text(
//                 'Cut ${index + 1}',
//                 style: TextStyle(color: color, fontWeight: FontWeight.bold),
//               ),
//               Expanded(
//                 child: RangeSlider(
//                   min: 0.0,
//                   max: totalSeconds,
//                   divisions: totalSeconds.round(),
//                   values: RangeValues(cut.start, cut.end),
//                   labels: RangeLabels(
//                     cut.start.toStringAsFixed(1),
//                     cut.end.toStringAsFixed(1),
//                   ),
//                   activeColor: color,
//                   inactiveColor: color.withOpacity(0.3),
//                   onChanged: (range) {
//                     setState(() {
//                       cut.start = range.start;
//                       cut.end = range.end;
//                     });
//                   },
//                 ),
//               ),
//               IconButton(
//                 icon: Icon(
//                   cut.isPlaying ? Icons.pause : Icons.play_arrow,
//                   size: 40,
//                 ),
//                 onPressed: () {
//                   if (cut.isPlaying) {
//                     _pauseCut(index);
//                   } else {
//                     _playCut(index);
//                   }
//                 },
//                 color: color,
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> _play() async {
//     await _player.resume();
//     setState(() => _playerState = PlayerState.playing);
//   }

//   Future<void> _pause() async {
//     await _player.pause();
//     setState(() => _playerState = PlayerState.paused);
//   }

//   Future<void> _stop() async {
//     await _player.stop();
//     setState(() {
//       _playerState = PlayerState.stopped;
//       _position = Duration.zero;
//     });
//   }

//   Future<void> _playCut(int index) async {
//     final cut = _cuts[index];
//     await _player.seek(Duration(seconds: cut.start.round()));
//     await _player.resume();

//     cut.isPlaying = true;
//     setState(() {});

//     _cutCheckTimer?.cancel();
//     _cutCheckTimer = Timer.periodic(const Duration(milliseconds: 200), (
//       timer,
//     ) async {
//       final current = await _player.getCurrentPosition();
//       if (current != null && current.inMilliseconds >= (cut.end * 1000)) {
//         await _player.pause();
//         cut.isPlaying = false;
//         setState(() {});
//         timer.cancel();
//       }
//     });
//   }

//   Future<void> _pauseCut(int index) async {
//     await _player.pause();
//     _cuts[index].isPlaying = false;
//     _cutCheckTimer?.cancel();
//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     final fileName = widget.audioFile.path.split('/').last;
//     final color = Theme.of(context).primaryColor;

//     return Scaffold(
//       appBar: AppBar(title: Text(fileName)),
//       body: Padding(
//         padding: const EdgeInsets.only(top: 20.0),
//         child: Column(
//           children: [
//             Container(
//               width: 200,
//               height: 200,
//               decoration: BoxDecoration(
//                 color: Colors.grey[300],
//                 borderRadius: BorderRadius.circular(16),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black26,
//                     blurRadius: 8,
//                     offset: Offset(0, 2),
//                   ),
//                 ],
//               ),
//               child: const Center(
//                 child: Icon(Icons.audiotrack, size: 100, color: Colors.grey),
//               ),
//             ),
//             const SizedBox(height: 40),
//             Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 IconButton(
//                   key: const Key('play_button'),
//                   onPressed: _isPlaying ? null : _play,
//                   iconSize: 48.0,
//                   icon: const Icon(Icons.play_arrow),
//                   color: color,
//                 ),
//                 IconButton(
//                   key: const Key('pause_button'),
//                   onPressed: _isPlaying ? _pause : null,
//                   iconSize: 48.0,
//                   icon: const Icon(Icons.pause),
//                   color: color,
//                 ),
//                 IconButton(
//                   key: const Key('stop_button'),
//                   onPressed: _isPlaying || _isPaused ? _stop : null,
//                   iconSize: 48.0,
//                   icon: const Icon(Icons.stop),
//                   color: color,
//                 ),
//                 IconButton(
//                   icon: Icon(
//                     Icons.loop,
//                     color: _isLooping ? Colors.blueAccent : Colors.grey,
//                   ),
//                   onPressed: () {
//                     setState(() {
//                       _isLooping = !_isLooping;
//                       _player.setReleaseMode(
//                         _isLooping ? ReleaseMode.loop : ReleaseMode.stop,
//                       );
//                     });
//                   },
//                 ),
//               ],
//             ),

//             Slider(
//               onChanged: (value) {
//                 final duration = _duration;
//                 if (duration == null) return;
//                 final position = value * duration.inMilliseconds;
//                 _player.seek(Duration(milliseconds: position.round()));
//               },
//               value:
//                   (_position != null &&
//                       _duration != null &&
//                       _position!.inMilliseconds > 0 &&
//                       _position!.inMilliseconds < _duration!.inMilliseconds)
//                   ? _position!.inMilliseconds / _duration!.inMilliseconds
//                   : 0.0,
//             ),
//             Text(
//               _position != null
//                   ? '$_positionText / $_durationText'
//                   : _duration != null
//                   ? _durationText
//                   : '',
//               style: const TextStyle(fontSize: 20.0),
//             ),
//             const SizedBox(height: 20),
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.only(left: 20.0, right: 20.0),
//                 child: Align(
//                   alignment: Alignment.centerLeft,
//                   child: SingleChildScrollView(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         _buildCutControl(0, Colors.green),
//                         _buildCutControl(1, Colors.yellow.shade700),
//                         _buildCutControl(2, Colors.red),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
