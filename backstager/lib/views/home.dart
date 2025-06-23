import 'dart:io';

import 'package:backstager/components/file_components/delete_file_component.dart';
import 'package:backstager/components/file_components/move_file_component.dart';
import 'package:backstager/components/folder_components/create_folder_component.dart';
import 'package:backstager/components/file_components/edit_file_component.dart';
import 'package:backstager/components/folder_components/delete_folder_component.dart';
import 'package:backstager/components/folder_components/edit_folder_component.dart';
import 'package:backstager/database/database_conn.dart';
import 'package:backstager/database/file_dao.dart';
import 'package:backstager/database/folder_dao.dart';
import 'package:backstager/models/MediaFile.dart';
import 'package:backstager/models/MediaFolder.dart';
import 'package:backstager/views/add_files_view.dart';
import 'package:backstager/views/folder_content_view.dart';
import 'package:backstager/views/play_audio_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import 'package:backstager/components/custom_navigator.dart';
import 'package:backstager/components/no_files_found.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool _firstBuild = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = true;

  final DatabaseConn conn = DatabaseConn.instance;
  final MediaFolderDao folderDao = MediaFolderDao(DatabaseConn.instance);
  final MediaFileDao fileDao = MediaFileDao(DatabaseConn.instance);

  List<MediaFolder> _currentFolders = [];
  List<MediaFile> _currentFiles = [];

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
      final folders = await folderDao.getAllMediaFolders();
      final rootFiles = await fileDao.getAllMediaFiles();

      setState(() {
        _currentFolders = folders;
        _currentFiles = rootFiles;
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
    if (_firstBuild) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scaffoldKey.currentState?.openDrawer();
        _scaffoldKey.currentState?.closeDrawer();
        _firstBuild = false;
      });
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          'BackStager',
          style: GoogleFonts.montaga(
            textStyle: const TextStyle(
              color: Color(0xFFFFD700),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadFilesAndFolders,
            tooltip: 'Refresh',
          ),
        ],
      ),
      floatingActionButton: _floatingActionButtons(context),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _currentFiles.isEmpty && _currentFolders.isEmpty
          ? NoFilesFound.noFilesFound(title: 'No folders or files found.')
          : _filesAndFoldersGrid(),
    );
  }

  Padding _filesAndFoldersGrid() {
    final rootFiles = _currentFiles
        .where((file) => file.folderId == null)
        .toList();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 0.8,
        ),
        itemCount: _currentFolders.length + rootFiles.length,
        itemBuilder: (context, index) {
          if (index < _currentFolders.length) {
            final folder = _currentFolders[index];
            return Card(
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              child: InkWell(
                onTap: () {
                  CustomNavigator.pushWithSlideTransition(
                    context,
                    FolderContentView(
                      id: folder.id,
                      onFilesMoved: () {
                        _loadFilesAndFolders();
                      },
                      folder: folder,
                    ),
                  );
                },
                onLongPress: () {
                  _showFolderOptionsMenu(context, folder);
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: _buildFolderPlaceholder(folder.coverImagePath),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 4.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.folder, size: 18.0, color: Colors.grey),
                          SizedBox(width: 4.0),
                          Flexible(
                            child: Text(
                              folder.name,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          final file = rootFiles[index - _currentFolders.length];
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 4.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.file_copy, size: 18.0, color: Colors.grey),
                        SizedBox(width: 4.0),
                        Flexible(
                          child: Text(
                            file.name,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
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

  Widget _buildFolderPlaceholder(String? imagePath) {
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
    } else {
      return Container(
        color: Colors.grey[200],
        child: const Center(
          child: Icon(Icons.folder, size: 48, color: Colors.grey),
        ),
      );
    }
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

  Column _floatingActionButtons(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton.extended(
          onPressed: () {
            CustomNavigator.pushWithSlideTransition(
              context,
              AddFilesView(
                onFilesAdded: () {
                  _loadFilesAndFolders();
                },
              ),
            );
          },
          heroTag: 'add_files',
          backgroundColor: Theme.of(context).primaryColor,
          icon: const Icon(Icons.note_add_rounded),
          label: const Text('Add Files'),
        ),
        const SizedBox(height: 16),
        FloatingActionButton.extended(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => CreateFolderComponent(
                onFolderCreated: () {
                  _loadFilesAndFolders();
                },
              ),
            );
          },
          heroTag: 'add_folder',
          backgroundColor: Theme.of(context).primaryColor,
          icon: const Icon(Icons.create_new_folder_sharp),
          label: const Text('Add Folder'),
        ),
      ],
    );
  }

  void _showFolderOptionsMenu(BuildContext context, MediaFolder folder) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 10.0),
            ListTile(
              leading: Icon(Icons.edit, color: Theme.of(context).primaryColor),
              title: Text(
                'Edit',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              onTap: () {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (context) => EditFolderComponent(
                    folder: folder,
                    onFolderUpdated: _loadFilesAndFolders,
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
                  builder: (context) => DeleteFolderComponent(
                    folder: folder,
                    onFolderDeleted: _loadFilesAndFolders,
                  ),
                ).then((value) {
                  if (value == true) {
                    _loadFilesAndFolders();
                  }
                });
              },
            ),
            SizedBox(height: 30.0),
          ],
        );
      },
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
