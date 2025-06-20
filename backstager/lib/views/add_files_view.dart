import 'dart:io';
import 'package:backstager/database/database_conn.dart';
import 'package:backstager/models/MediaFile.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class AddFilesView extends StatefulWidget {
  final void Function() onFilesAdded;
  const AddFilesView({super.key, required this.onFilesAdded});

  @override
  _AddFilesViewState createState() => _AddFilesViewState();
}

class _AddFilesViewState extends State<AddFilesView> {
  final List<PlatformFile> _selectedFiles = [];
  bool _isSaving = false;
  final DatabaseConn conn = DatabaseConn.instance;

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

      await conn.database.then((db) async {
        await db.transaction((txn) async {
          for (final file in _selectedFiles) {
            try {
              final originalFile = File(file.path!);
              final newFile = File('${savedFilesDir.path}/${file.name}');
              await originalFile.copy(newFile.path);

              final mediaFile = MediaFile(
                name: file.name,
                filePath: newFile.path,
              );

              await txn.insert(
                'files',
                mediaFile.toMap(),
                conflictAlgorithm: ConflictAlgorithm.replace,
              );

              await originalFile.delete();
            } catch (e) {
              debugPrint('Error processing file ${file.name}: $e');
            }
          }
        });
      });

      setState(() {
        _selectedFiles.clear();
      });
      widget.onFilesAdded();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Files saved successfully!')));
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving files, try again or report')),
      );
      Navigator.pop(context);
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
                        Icon(
                          Icons.folder_off_sharp,
                          size: 80,
                          color: const Color.fromARGB(255, 165, 165, 165),
                        ),
                        SizedBox(height: 16),
                        Text(
                          "Add files and save them with the buttons below",
                          style: TextStyle(
                            color: const Color.fromARGB(255, 165, 165, 165),
                          ),
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
                            color: Theme.of(context).primaryColor,
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
