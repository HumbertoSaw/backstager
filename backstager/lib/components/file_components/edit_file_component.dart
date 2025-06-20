import 'dart:io';

import 'package:backstager/database/database_conn.dart';
import 'package:backstager/database/file_dao.dart';
import 'package:backstager/models/MediaFile.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditFileComponent extends StatefulWidget {
  final MediaFile file;
  final VoidCallback? onFileUpdated;

  const EditFileComponent({super.key, required this.file, this.onFileUpdated});

  @override
  State<EditFileComponent> createState() => _EditFileComponentState();
}

class _EditFileComponentState extends State<EditFileComponent> {
  late TextEditingController _nameController;
  late String _originalName;
  late String _fileExtension;
  bool _isSaving = false;
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  final MediaFileDao fileDao = MediaFileDao(DatabaseConn.instance);

  @override
  void initState() {
    super.initState();
    _originalName = widget.file.name.split('.').first;
    _fileExtension = widget.file.name.substring(_originalName.length);
    _nameController = TextEditingController(text: _originalName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    final newName = _nameController.text.trim();

    if (newName.isEmpty ||
        (newName == _originalName && _selectedImage == null)) {
      Navigator.pop(context);
      return;
    }

    setState(() => _isSaving = true);

    try {
      final newFileName = '$newName$_fileExtension';

      final updatedFile = MediaFile(
        id: widget.file.id,
        name: newFileName,
        folderId: widget.file.folderId,
        filePath: widget.file.filePath,
        imagePath: _selectedImage?.path ?? widget.file.imagePath,
      );

      await fileDao.updateMediaFile(updatedFile);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _selectedImage != null
                ? 'File and image updated successfully'
                : 'File renamed successfully',
          ),
        ),
      );

      if (widget.onFileUpdated != null) {
        widget.onFileUpdated!();
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

  Future<File?> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    return image != null ? File(image.path) : null;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Edit File',
        style: TextStyle(color: Theme.of(context).primaryColor),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Change name',
                hintText: widget.file.name,
                border: const OutlineInputBorder(),
              ),
              autofocus: true,
            ),
            const SizedBox(height: 16),
            const Text(
              'File Cover Image (Optional)',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Center(
              child: GestureDetector(
                onTap: () async {
                  final image = await _pickImage();
                  if (image != null) {
                    setState(() {
                      _selectedImage = image;
                    });
                  }
                },
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Theme.of(context).dividerColor,
                      width: 1,
                    ),
                  ),
                  child: _buildImagePreview(),
                ),
              ),
            ),
            if (_isSaving)
              const Padding(
                padding: EdgeInsets.only(top: 16),
                child: CircularProgressIndicator(),
              ),
          ],
        ),
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

  Widget _buildImagePreview() {
    if (_selectedImage != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.file(_selectedImage!, fit: BoxFit.cover),
      );
    } else if (widget.file.imagePath != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.file(File(widget.file.imagePath!), fit: BoxFit.cover),
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.image, size: 40, color: Colors.grey),
          SizedBox(height: 8),
          Text('Tap to select image', style: TextStyle(color: Colors.grey)),
        ],
      );
    }
  }
}
