import 'dart:io';
import 'package:backstager/database/database_conn.dart';
import 'package:backstager/database/folder_dao.dart';
import 'package:backstager/l10n/app_localizations.dart';
import 'package:backstager/models/MediaFolder.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class CreateFolderComponent extends StatefulWidget {
  final void Function() onFolderCreated;

  const CreateFolderComponent({super.key, required this.onFolderCreated});

  @override
  State<CreateFolderComponent> createState() => _CreateFolderComponentState();
}

class _CreateFolderComponentState extends State<CreateFolderComponent> {
  final TextEditingController _nameController = TextEditingController();
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  final MediaFolderDao folderDao = MediaFolderDao(DatabaseConn.instance);

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<File?> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    return image != null ? File(image.path) : null;
  }

  Future<void> _createNewFolder(String name, File? imageFile) async {
    final t = AppLocalizations.of(context)!;

    try {
      if (name.isEmpty) {
        throw Exception(t.createFolderViewEmptyNameError);
      }

      String? imagePath;

      if (imageFile != null) {
        final appDir = await getApplicationDocumentsDirectory();
        final imagesDir = Directory('${appDir.path}/folder_covers');
        if (!await imagesDir.exists()) {
          await imagesDir.create();
        }

        final ext = imageFile.path.split('.').last;
        final fileName = '${DateTime.now().millisecondsSinceEpoch}.$ext';
        final savedImage = await imageFile.copy('${imagesDir.path}/$fileName');
        imagePath = savedImage.path;
      }

      final newFolder = MediaFolder(name: name, coverImagePath: imagePath);
      await folderDao.insertMediaFolder(newFolder);
      widget.onFolderCreated();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Folder "$name" created successfully'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      debugPrint('Error creating folder: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create folder: ${e.toString()}'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

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
                    t.createFolderViewTitle,
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
                  labelText: t.createFolderViewNameLabel,
                  hintText: t.createFolderViewNameHint,
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
                t.createFolderViewCoverLabel,
                style: const TextStyle(fontWeight: FontWeight.w500),
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
                    child: _selectedImage != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              _selectedImage!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.image,
                                size: 40,
                                color: Colors.grey,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                t.createFolderViewSelectImage,
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                  ),
                ),
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
                    child: Text(t.createFolderViewCancel),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () async {
                      final name = _nameController.text.trim();
                      if (name.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(t.createFolderViewEmptyNameError),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                        return;
                      }

                      await _createNewFolder(name, _selectedImage);
                      if (mounted) Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(t.createFolderViewCreate),
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
