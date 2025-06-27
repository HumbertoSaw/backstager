import 'package:backstager/database/clip_dao.dart';
import 'package:backstager/database/database_conn.dart';
import 'package:backstager/l10n/app_localizations.dart';
import 'package:backstager/models/MediaClip.dart';
import 'package:backstager/models/MediaFile.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class CreateClipComponent extends StatefulWidget {
  final void Function() onClipCreated;
  final MediaFile file;

  const CreateClipComponent({
    super.key,
    required this.onClipCreated,
    required this.file,
  });

  @override
  State<CreateClipComponent> createState() => _CreateClipComponentState();
}

class _CreateClipComponentState extends State<CreateClipComponent> {
  final TextEditingController _nameController = TextEditingController();
  final MediaClipDao clipDao = MediaClipDao(DatabaseConn.instance);
  final AudioPlayer _audioPlayer = AudioPlayer();
  RangeValues _clipRange = const RangeValues(0, 0);
  Color? _selectedColor;
  double _audioLength = 0;
  bool _isLoading = true;
  late AppLocalizations t; // Store localization here

  final List<Color> _colorOptions = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
  ];

  @override
  void initState() {
    super.initState();
    // Don't call _getAudioLength here
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    t = AppLocalizations.of(context)!; // Now context is safe to use
    _getAudioLength();
  }

  Future<void> _getAudioLength() async {
    try {
      if (widget.file.filePath == null) {
        throw Exception('Audio file path is null');
      }

      await _audioPlayer.setSource(DeviceFileSource(widget.file.filePath!));
      final duration = await _audioPlayer.getDuration();

      if (duration != null) {
        if (mounted) {
          setState(() {
            _audioLength = duration.inSeconds.toDouble();
            _clipRange = RangeValues(0, _audioLength);
            _isLoading = false;
          });
        }
      } else {
        throw Exception('Could not determine audio length');
      }
    } catch (e) {
      debugPrint('Error getting audio length: $e');
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load audio: ${e.toString()}'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _createNewClip() async {
    try {
      final name = _nameController.text.trim();
      if (name.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(t.createClipViewErrorEmptyName),
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }

      final clip = MediaClip(
        fileId: widget.file.id,
        name: name,
        startAt: _clipRange.start,
        endAt: _clipRange.end,
        color: _selectedColor?.value.toRadixString(16),
      );

      await clipDao.insertMediaClip(clip);
      widget.onClipCreated();
      if (mounted) Navigator.pop(context);
    } catch (e) {
      debugPrint('Error creating clip: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${t.createClipViewErrorCreate} ${e.toString()}'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    t.createClipViewTitle,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                    splashRadius: 20,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: t.createClipViewClipNameLabel,
                  hintText: t.createClipViewClipNameHint,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                t.createClipViewClipColorLabel,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: _colorOptions.map((color) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedColor = color;
                      });
                    },
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: _selectedColor == color
                            ? Border.all(
                                color: Theme.of(context).primaryColor,
                                width: 2,
                              )
                            : null,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              Text(
                t.createClipViewClipRangeLabel,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                      children: [
                        RangeSlider(
                          values: _clipRange,
                          min: 0,
                          max: _audioLength,
                          divisions: (_audioLength ~/ 0.1).toInt(),
                          labels: RangeLabels(
                            '${_clipRange.start.toStringAsFixed(1)}s',
                            '${_clipRange.end.toStringAsFixed(1)}s',
                          ),
                          onChanged: (RangeValues values) {
                            setState(() {
                              _clipRange = values;
                            });
                          },
                        ),
                      ],
                    ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                    child: Text(t.createClipViewCancel),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _createNewClip,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(t.createClipViewCreate),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
