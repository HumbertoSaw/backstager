import 'dart:io';
import 'package:backstager/components/custom_navigator.dart';
import 'package:backstager/database/database_conn.dart';
import 'package:backstager/l10n/app_localizations.dart';
import 'package:backstager/models/MediaFile.dart';
import 'package:backstager/views/record_file_view.dart';
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
    if (_selectedFiles.isEmpty) return;

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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.addFilesViewFileSaved),
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.addFilesViewSaveError),
        ),
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
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(t.addFilesViewTitle)),
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
                        const SizedBox(height: 16),
                        Text(
                          t.addFilesViewEmptyState,
                          style: const TextStyle(
                            color: Color.fromARGB(255, 165, 165, 165),
                          ),
                          textAlign: TextAlign.center,
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
                            Icons.remove_circle,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        onDismissed: (_) => _removeFile(index),
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
                            t.addFilesViewFileSize(
                              (file.size / 1024).toStringAsFixed(2),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          _addFilesButtons(t),
        ],
      ),
    );
  }

  Widget _addFilesButtons(AppLocalizations t) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            spreadRadius: 0,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildActionButton(
            icon: Icons.add,
            label: t.addFilesViewAddFiles,
            onPressed: _pickFiles,
          ),
          const SizedBox(height: 8),
          _buildActionButton(
            icon: Icons.mic,
            label: t.addFilesViewRecordFile,
            onPressed: () {
              CustomNavigator.pushWithSlideTransition(
                context,
                const RecordAudioFileView(),
              );
            },
          ),
          const SizedBox(height: 8),
          _buildActionButton(
            icon: Icons.save,
            label: _isSaving ? t.addFilesViewSaving : t.addFilesViewSaveFiles,
            onPressed: _isSaving ? null : _saveFiles,
            isLoading: _isSaving,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback? onPressed,
    bool isLoading = false,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        onPressed: onPressed,
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 24),
                  const SizedBox(width: 8),
                  Text(label),
                ],
              ),
      ),
    );
  }
}
