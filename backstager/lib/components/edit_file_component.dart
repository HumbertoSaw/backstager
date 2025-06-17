import 'dart:io';
import 'package:backstager/controllers/directory_controller.dart.dart';
import 'package:flutter/material.dart';

class EditFileComponent extends StatefulWidget {
  final File file;
  final DirectoryController directoryController;
  final VoidCallback onFileEdited;

  const EditFileComponent({
    super.key,
    required this.file,
    required this.directoryController,
    required this.onFileEdited,
  });

  @override
  State<EditFileComponent> createState() => _EditFileComponentState();
}

class _EditFileComponentState extends State<EditFileComponent> {
  late TextEditingController _nameController;
  late String _originalName;
  late String _fileExtension;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final fileName = widget.directoryController.getFileName(widget.file.path);
    _originalName = fileName;

    final lastDotIndex = fileName.lastIndexOf('.');
    if (lastDotIndex != -1 && lastDotIndex != 0) {
      _fileExtension = fileName.substring(lastDotIndex);
      _originalName = fileName.substring(0, lastDotIndex);
    } else {
      _fileExtension = '';
    }

    _nameController = TextEditingController(text: _originalName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    final newName = _nameController.text.trim();

    if (newName.isEmpty || newName == _originalName) {
      Navigator.pop(context);
      return;
    }

    setState(() => _isSaving = true);

    try {
      final newFileName = '$newName$_fileExtension';
      final newPath = '${widget.file.parent.path}/$newFileName';

      await widget.file.rename(newPath);
      widget.onFileEdited();

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('File renamed successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error renaming file: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit File'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'File Name',
              hintText: 'Enter new name',
              border: const OutlineInputBorder(),
            ),
            autofocus: true,
          ),
          const SizedBox(height: 16),
          if (_isSaving) const CircularProgressIndicator(),
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
