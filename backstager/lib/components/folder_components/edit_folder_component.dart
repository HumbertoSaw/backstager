import 'dart:io';

import 'package:backstager/database/database_conn.dart';
import 'package:backstager/database/folder_dao.dart';
import 'package:backstager/models/MediaFolder.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditFolderComponent extends StatefulWidget {
  final MediaFolder folder;
  final VoidCallback? onFolderUpdated;

  const EditFolderComponent({
    super.key,
    required this.folder,
    this.onFolderUpdated,
  });

  @override
  State<EditFolderComponent> createState() => _EditFolderComponentState();
}

class _EditFolderComponentState extends State<EditFolderComponent> {
  late TextEditingController _nameController;
  late String _originalName;
  bool _isSaving = false;
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  final MediaFolderDao folderDao = MediaFolderDao(DatabaseConn.instance);

  @override
  void initState() {
    super.initState();
    _originalName = widget.folder.name.split('.').first;
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
      final newFolderName = newName;

      final updatedFolder = MediaFolder(
        id: widget.folder.id,
        name: newFolderName,
        coverImagePath: _selectedImage?.path ?? widget.folder.coverImagePath,
      );

      await folderDao.updateMediaFolder(updatedFolder);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _selectedImage != null
                ? 'Folder and image updated successfully'
                : 'Folder renamed successfully',
          ),
        ),
      );

      if (widget.onFolderUpdated != null) {
        widget.onFolderUpdated!();
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
        'Edit Folder',
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
                hintText: widget.folder.name,
                border: const OutlineInputBorder(),
              ),
              autofocus: true,
            ),
            const SizedBox(height: 16),
            const Text(
              'Folder Cover Image (Optional)',
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
    } else if (widget.folder.coverImagePath != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.file(
          File(widget.folder.coverImagePath!),
          fit: BoxFit.cover,
        ),
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
