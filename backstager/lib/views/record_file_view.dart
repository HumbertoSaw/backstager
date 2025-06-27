import 'dart:io';

import 'package:backstager/database/database_conn.dart';
import 'package:backstager/database/file_dao.dart';
import 'package:backstager/l10n/app_localizations.dart';
import 'package:backstager/models/MediaFile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:record/record.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:audio_waveforms/audio_waveforms.dart';

class RecordAudioFileView extends StatefulWidget {
  const RecordAudioFileView({super.key});

  @override
  State<RecordAudioFileView> createState() => _RecordAudioFileViewState();
}

class _RecordAudioFileViewState extends State<RecordAudioFileView> {
  final _record = AudioRecorder();
  bool _isRecording = false;
  final MediaFileDao fileDao = MediaFileDao(DatabaseConn.instance);

  Duration _recordingDuration = Duration.zero;
  late final Stopwatch _stopwatch;
  late final Ticker _ticker;

  late final RecorderController _recorderController;

  @override
  void initState() {
    super.initState();
    _requestPermission();

    _stopwatch = Stopwatch();
    _ticker = Ticker((_) {
      if (mounted) {
        setState(() {
          _recordingDuration = _stopwatch.elapsed;
        });
      }
    });

    _recorderController = RecorderController()
      ..updateFrequency = const Duration(milliseconds: 50);
  }

  Future<void> _requestPermission() async {
    await Permission.microphone.request();
  }

  Future<void> _startRecording() async {
    if (await _record.hasPermission()) {
      final directory = await getApplicationDocumentsDirectory();
      final path =
          '${directory.path}/recording_${DateTime.now().millisecondsSinceEpoch}.m4a';

      await _record.start(const RecordConfig(), path: path);
      await _recorderController.record(path: path);

      _stopwatch.reset();
      _stopwatch.start();
      _ticker.start();

      _record.onAmplitudeChanged(const Duration(milliseconds: 300)).listen((
        amp,
      ) {
        setState(() {});
      });

      setState(() {
        _isRecording = true;
      });
    }
  }

  Future<void> _stopRecording() async {
    final path = await _record.stop();
    await _recorderController.stop();
    _stopwatch.stop();
    _ticker.stop();

    final duration = _recordingDuration;
    setState(() {
      _isRecording = false;
      _recordingDuration = Duration.zero;
    });

    if (path != null) {
      final file = File(path);
      final fileName = path.split('/').last;
      final fileSize = await file.length();
      final fileDate = FileStat.statSync(path).modified;

      _saveAudioDialog(fileName, duration, fileSize, fileDate, file, path);
    }
  }

  Future<void> _saveAudioDialog(
    String fileName,
    Duration duration,
    int fileSize,
    DateTime fileDate,
    File file,
    String path,
  ) {
    final t = AppLocalizations.of(context)!;

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(
            t.saveRecordingDialogTitle,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 92, 92, 92),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoItem(t.saveRecordingDialogName, fileName),
              const SizedBox(height: 8),
              _buildInfoItem(
                t.saveRecordingDialogDuration,
                _formatDuration(duration),
              ),
              const SizedBox(height: 8),
              _buildInfoItem(
                t.saveRecordingDialogSize,
                '${(fileSize / 1024).toStringAsFixed(1)} KB',
              ),
              const SizedBox(height: 8),
              _buildInfoItem(
                t.saveRecordingDialogDate,
                fileDate.toLocal().toString(),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text(t.saveRecordingDialogDiscard),
              onPressed: () async {
                if (await file.exists()) {
                  await file.delete();
                }
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text(t.saveRecordingDialogSave),
              onPressed: () async {
                final mediaFile = MediaFile(
                  name: fileName,
                  filePath: path,
                  imagePath: null,
                  folderId: null,
                );
                await fileDao.insertMediaFile(mediaFile);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 92, 92, 92),
          ),
        ),
        Text(value),
      ],
    );
  }

  String _formatDuration(Duration d) {
    return d.toString().split('.').first.padLeft(8, "0");
  }

  @override
  void dispose() {
    _record.dispose();
    _recorderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.recordAudioViewTitle),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _isRecording ? Icons.fiber_manual_record : Icons.mic,
                    size: 60,
                    color: _isRecording ? Colors.red : Colors.deepPurple,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _isRecording
                        ? t.recordAudioViewRecordingInProgress
                        : t.recordAudioViewPressToStart,
                    style: TextStyle(
                      fontSize: 16,
                      color: _isRecording ? Colors.red[700] : Colors.grey[700],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  if (_isRecording)
                    Text(
                      _formatDuration(_recordingDuration),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  const SizedBox(height: 20),
                  if (_isRecording)
                    AudioWaveforms(
                      size: const Size(double.infinity, 50),
                      recorderController: _recorderController,
                      enableGesture: false,
                      waveStyle: const WaveStyle(
                        waveColor: Colors.red,
                        extendWaveform: true,
                        showMiddleLine: false,
                      ),
                    ),
                  const SizedBox(height: 30),
                  ElevatedButton.icon(
                    icon: Icon(
                      _isRecording ? Icons.stop : Icons.fiber_manual_record,
                    ),
                    label: Text(
                      _isRecording
                          ? t.recordAudioViewStopRecording
                          : t.recordAudioViewStartRecording,
                    ),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: _isRecording
                          ? Colors.red
                          : Colors.deepPurple,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                    onPressed: _isRecording ? _stopRecording : _startRecording,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
