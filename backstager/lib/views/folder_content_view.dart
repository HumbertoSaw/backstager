import 'dart:io';

import 'package:backstager/components/custom_navigator.dart';
import 'package:backstager/components/file_components/delete_file_component.dart';
import 'package:backstager/components/file_components/edit_file_component.dart';
import 'package:backstager/components/file_components/move_file_component.dart';
import 'package:backstager/components/no_files_found.dart';
import 'package:backstager/database/database_conn.dart';
import 'package:backstager/database/file_dao.dart';
import 'package:backstager/models/MediaFile.dart';
import 'package:backstager/models/MediaFolder.dart';
import 'package:backstager/views/play_audio_view.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mime/mime.dart';

class FolderContentView extends StatefulWidget {
  final int? id;
  final void Function() onFilesMoved;
  final MediaFolder folder;
  const FolderContentView({
    super.key,
    required this.id,
    required this.onFilesMoved,
    required this.folder,
  });

  @override
  State<FolderContentView> createState() => _FolderContentViewState();
}

class _FolderContentViewState extends State<FolderContentView> {
  bool _isLoading = true;
  List<MediaFile> _folderFiles = [];

  final MediaFileDao fileDao = MediaFileDao(DatabaseConn.instance);

  @override
  void initState() {
    super.initState();
    _loadFilesAndFolders();
  }

  Future<void> _loadFilesAndFolders() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final folderFiles = await fileDao.getMediaFilesByFolderId(widget.id);
      setState(() {
        _folderFiles = folderFiles;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      debugPrint('Error loading data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.folder.name,
          style: GoogleFonts.montaga(
            textStyle: const TextStyle(
              color: Color(0xFFFFD700),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: _filesGrid(),
    );
  }

  Padding _filesGrid() {
    if (_folderFiles.isEmpty) {
      return Padding(
        padding: EdgeInsets.all(8.0),
        child: NoFilesFound.noFilesFound(title: 'No folders or files found.'),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 0.8,
        ),
        itemCount: _folderFiles.length,
        itemBuilder: (context, index) {
          final file = _folderFiles[index];

          return Card(
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            child: InkWell(
              onTap: () {
                final audioFile = File(file.filePath.toString());
                CustomNavigator.pushWithSlideTransition(
                  context,
                  PlayAudioView(audioFile: audioFile, file: file),
                );
              },
              onLongPress: () {
                _showFileOptionsMenu(context, file);
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: _buildFilePlaceholder(
                      file.filePath.toString(),
                      imagePath: file.imagePath,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      file.name,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFilePlaceholder(String filePath, {String? imagePath}) {
    if (imagePath != null && File(imagePath).existsSync()) {
      return ClipRRect(
        child: Image.file(
          File(imagePath),
          fit: BoxFit.cover,
          alignment: Alignment.center,
          width: double.infinity,
          height: double.infinity,
        ),
      );
    }

    final mimeType = lookupMimeType(filePath);
    return Container(
      color: Colors.grey[200],
      child: Center(
        child: Icon(
          mimeType?.startsWith('audio/') ?? false
              ? Icons.audiotrack
              : mimeType?.startsWith('video/') ?? false
              ? Icons.videocam
              : Icons.insert_drive_file,
          size: 48,
          color: Colors.grey,
        ),
      ),
    );
  }

  void _showFileOptionsMenu(BuildContext context, MediaFile file) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 10.0),
              ListTile(
                leading: Icon(
                  Icons.edit,
                  color: Theme.of(context).primaryColor,
                ),
                title: Text(
                  'Edit',
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
                onTap: () {
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (context) => EditFileComponent(
                      file: file,
                      onFileUpdated: _loadFilesAndFolders,
                    ),
                  ).then((value) {
                    if (value == true) {
                      _loadFilesAndFolders();
                    }
                  });
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.delete,
                  color: Theme.of(context).primaryColor,
                ),
                title: Text(
                  'Delete',
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
                onTap: () {
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (context) => DeleteFileComponent(
                      file: file,
                      onFileDeleted: _loadFilesAndFolders,
                    ),
                  ).then((value) {
                    if (value == true) {
                      _loadFilesAndFolders();
                    }
                  });
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.drive_file_move,
                  color: Theme.of(context).primaryColor,
                ),
                title: Text(
                  'Move',
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
                onTap: () {
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (context) => MoveFileComponent(
                      file: file,
                      onFileMoved: _loadFilesAndFolders,
                    ),
                  ).then((value) {
                    if (value == true) {
                      _loadFilesAndFolders();
                    }
                    widget.onFilesMoved();
                  });
                },
              ),
              SizedBox(height: 30.0),
            ],
          ),
        );
      },
    );
  }
}
