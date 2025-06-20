import 'dart:io';

import 'package:backstager/database/database_conn.dart';
import 'package:backstager/database/file_dao.dart';
import 'package:backstager/models/MediaFile.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class DeleteFileComponent extends StatefulWidget {
  final MediaFile file;
  final VoidCallback? onFileDeleted;

  const DeleteFileComponent({
    super.key,
    required this.file,
    this.onFileDeleted,
  });

  @override
  State<DeleteFileComponent> createState() => _DeleteFileComponentState();
}

class _DeleteFileComponentState extends State<DeleteFileComponent> {
  bool _isSaving = false;

  final MediaFileDao fileDao = MediaFileDao(DatabaseConn.instance);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _saveChanges() async {
    setState(() => _isSaving = true);

    try {
      await fileDao.deleteMediaFile(widget.file.id);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('File deleted successfully')));

      if (widget.onFileDeleted != null) {
        widget.onFileDeleted!();
      }
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error updating file: $e')));
    } finally {
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Delete File',
        style: TextStyle(color: Theme.of(context).primaryColor),
      ),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
          
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isSaving ? null : _saveChanges,
          child: const Text('Save'),
        ),
      ],
    );
  }
}
