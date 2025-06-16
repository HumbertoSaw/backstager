import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class AddFilesView extends StatefulWidget {
  const AddFilesView({super.key});

  @override
  _AddFilesViewState createState() => _AddFilesViewState();
}

class _AddFilesViewState extends State<AddFilesView> {
  final List<PlatformFile> _selectedFiles = [];

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
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Add Files'),
              onPressed: _pickFiles,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
