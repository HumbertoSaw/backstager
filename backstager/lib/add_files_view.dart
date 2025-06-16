import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';

class AddFilesView extends StatefulWidget {
  const AddFilesView({super.key});

  @override
  _AddFilesViewState createState() => _AddFilesViewState();
}

class _AddFilesViewState extends State<AddFilesView> {
  final List<PlatformFile> _selectedFiles = [];
  bool _isSaving = false;

  Future<void> _pickFiles() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.audio,
        allowMultiple: true,
      );

      if (result != null) {
        setState(() {
          _selectedFiles.addAll(result.files);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error picking files: $e')));
    }
  }

  void _removeFile(int index) {
    setState(() {
      _selectedFiles.removeAt(index);
    });
  }

  Future<void> _saveFiles() async {
    if (_selectedFiles.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No files to save')));
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final appDir = await getApplicationDocumentsDirectory();
      final savedFilesDir = Directory('${appDir.path}/saved_media_files');

      if (!await savedFilesDir.exists()) {
        await savedFilesDir.create(recursive: true);
      }

      int successCount = 0;

      for (final file in _selectedFiles) {
        try {
          final originalFile = File(file.path!);
          final newFile = File('${savedFilesDir.path}/${file.name}');

          await originalFile.copy(newFile.path);
          await originalFile.delete();

          successCount++;
        } catch (e) {
          debugPrint('Error moving file ${file.name}: $e');
        }
      }

      setState(() {
        _selectedFiles.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Saved $successCount/${_selectedFiles.length} files'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error saving files: $e')));
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Media Files')),
      body: Column(
        children: [
          Expanded(
            child: _selectedFiles.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'No files selected',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _selectedFiles.length,
                    itemBuilder: (context, index) {
                      final file = _selectedFiles[index];
                      return Dismissible(
                        key: Key(file.name + index.toString()),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        onDismissed: (direction) => _removeFile(index),
                        child: ListTile(
                          leading: Icon(
                            file.path!.endsWith('.mp3') ||
                                    file.path!.endsWith('.wav') ||
                                    file.path!.endsWith('.m4a')
                                ? Icons.audiotrack
                                : Icons.videocam,
                            size: 36,
                          ),
                          title: Text(file.name),
                          subtitle: Text(
                            '${(file.size / 1024).toStringAsFixed(2)} KB',
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text('Add Files'),
                  onPressed: _pickFiles,
                ),
                const SizedBox(width: 20),
                ElevatedButton.icon(
                  icon: _isSaving
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Icon(Icons.save),
                  label: _isSaving
                      ? const Text('Saving...')
                      : const Text('Save Files'),
                  onPressed: _isSaving ? null : _saveFiles,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
