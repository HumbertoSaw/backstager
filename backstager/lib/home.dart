import 'dart:io';
import 'package:backstager/add_files_view.dart';
import 'package:backstager/components/edit_file_component.dart';
import 'package:backstager/controllers/directory_controller.dart.dart';
import 'package:backstager/models/media_folder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:mime/mime.dart';
import 'components/create_folder_component.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool _firstBuild = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final DirectoryController _directoryController = DirectoryController();
  List<FileSystemEntity> _currentFiles = [];
  List<MediaFolder> _currentFolders = [];
  bool _isLoading = true;
  Directory? _currentDirectory;
  final List<Directory> _directoryStack = [];

  @override
  void initState() {
    super.initState();
    _loadRootDirectory();
  }

  Future<void> _loadRootDirectory() async {
    try {
      _currentDirectory = await _directoryController.getRootDirectory();
      await _loadDirectoryContents(_currentDirectory!);
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      debugPrint('Error loading directory: $e');
    }
  }

  Future<void> _loadDirectoryContents(Directory directory) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final entities = await _directoryController.loadDirectoryContents(
        directory,
      );

      final files = entities.whereType<File>().where((file) {
        final fileName = _directoryController.getFileName(file.path);
        return !fileName.startsWith('folder_image.');
      }).toList();

      final directories = entities.whereType<Directory>().toList();

      List<MediaFolder> folders = [];
      for (var dir in directories) {
        final dirFiles = await dir.list().toList();
        File? imageFile;

        for (var file in dirFiles.whereType<File>()) {
          final fileName = _directoryController.getFileName(file.path);
          if (fileName.startsWith('folder_image.')) {
            imageFile = file;
            break;
          }
        }

        folders.add(
          MediaFolder(
            name: _directoryController.getFileName(dir.path),
            imageFile: imageFile,
            directory: dir,
          ),
        );
      }

      setState(() {
        _currentFiles = files;
        _currentFolders = folders;
        _currentDirectory = directory;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      debugPrint('Error loading directory contents: $e');
    }
  }

  void _navigateToFolder(Directory directory) {
    _directoryStack.add(_currentDirectory!);
    _loadDirectoryContents(directory);
  }

  void _navigateBack() {
    if (_directoryStack.isNotEmpty) {
      final parentDirectory = _directoryStack.removeLast();
      _loadDirectoryContents(parentDirectory);
    }
  }

  Future<void> _moveFile(File file, Directory destination) async {
    try {
      await _directoryController.moveFile(file, destination);
      await _loadDirectoryContents(_currentDirectory!);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Archivo movido a ${_directoryController.getFileName(destination.path)}',
          ),
        ),
      );
    } catch (e) {
      debugPrint('Error moving file: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al mover el archivo: $e')));
    }
  }

  void _showMoveDialog(File file) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Move File'),
          content: SizedBox(
            width: double.maxFinite,
            child: FutureBuilder<List<MediaFolder>>(
              future: _directoryController.getRootDirectory().then(
                (rootDir) => _directoryController.getAllFolders(rootDir),
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('No folders available to move the file.');
                }

                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final folder = snapshot.data![index];
                    return ListTile(
                      leading: const Icon(Icons.folder),
                      title: Text(folder.name),
                      onTap: () {
                        Navigator.pop(context);
                        _moveFile(file, folder.directory);
                      },
                    );
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFileIcon(String path) {
    final mimeType = lookupMimeType(path);

    if (mimeType != null) {
      if (mimeType.startsWith('audio/')) {
        return const Icon(Icons.audiotrack, size: 48, color: Color(0xFF6A0DAD));
      } else if (mimeType.startsWith('video/')) {
        return const Icon(Icons.videocam, size: 48, color: Color(0xFF6A0DAD));
      }
    }

    return const Icon(Icons.insert_drive_file, size: 48);
  }

  void _showCreateFolderDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return CreateFolderComponent(
          onFolderCreated: () => _loadDirectoryContents(_currentDirectory!),
          parentDirectory: _currentDirectory,
        );
      },
    );
  }

  void _addFilesViewNavigator() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const AddFilesView(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.ease;

          final tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));
          final offsetAnimation = animation.drive(tween);

          return SlideTransition(position: offsetAnimation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    ).then((_) => _loadDirectoryContents(_currentDirectory!));
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
        leading: _directoryStack.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _navigateBack,
              )
            : null,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _loadDirectoryContents(_currentDirectory!),
          ),
        ],
      ),
      floatingActionButton: _floatingActionButtons(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _currentFiles.isEmpty && _currentFolders.isEmpty
          ? _noFilesAdded(context)
          : _filesAndFoldersGrid(),
    );
  }

  Padding _filesAndFoldersGrid() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 0.8,
        ),
        itemCount: _currentFiles.length + _currentFolders.length,
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
                  _navigateToFolder(folder.directory);
                },
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: folder.imageFile != null
                          ? Image.file(folder.imageFile!, fit: BoxFit.cover)
                          : Container(
                              color: Colors.grey[200],
                              child: const Center(
                                child: Icon(
                                  Icons.folder,
                                  size: 48,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(4),
                            bottomRight: Radius.circular(4),
                          ),
                        ),
                        child: Text(
                          folder.name,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          final fileIndex = index - _currentFolders.length;
          final file = _currentFiles[fileIndex];
          final fileName = _directoryController.getFileName(file.path);

          return Card(
            child: InkWell(
              onTap: () {
                OpenFile.open(file.path);
              },
              onLongPress: () {
                _showFileContextMenu(file as File, context);
              },
              borderRadius: BorderRadius.circular(4),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildFileIcon(file.path),
                    const SizedBox(height: 8),
                    Text(
                      fileName,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showFileContextMenu(File file, BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 8),
              ListTile(
                leading: const Icon(
                  Icons.drive_file_move,
                  color: Color(0xFF6A0DAD),
                ),
                title: const Text('Move'),
                onTap: () {
                  Navigator.pop(context);
                  _showMoveDialog(file);
                },
              ),
              ListTile(
                leading: const Icon(Icons.edit, color: Color(0xFF6A0DAD)),
                title: const Text('Edit'),
                onTap: () {
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (context) => EditFileComponent(
                      file: file,
                      directoryController: _directoryController,
                      onFileEdited: () =>
                          _loadDirectoryContents(_currentDirectory!),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Color(0xFF6A0DAD)),
                title: const Text('Delete'),
                onTap: () {
                  Navigator.pop(context);
                  file
                      .delete()
                      .then((_) {
                        _loadDirectoryContents(_currentDirectory!);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('File deleted successfully')),
                        );
                      })
                      .catchError((error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error deleting file: $error'),
                          ),
                        );
                      });
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Center _noFilesAdded(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.folder_off_rounded,
            size: 64,
            color: const Color.fromARGB(255, 165, 165, 165),
          ),
          const SizedBox(height: 16),
          Text(
            'No files or folders found',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: const Color.fromARGB(255, 165, 165, 165),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the + button to create a folder',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: const Color.fromARGB(255, 165, 165, 165),
            ),
          ),
        ],
      ),
    );
  }

  Column _floatingActionButtons(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton.extended(
          onPressed: _addFilesViewNavigator,
          heroTag: 'add_files',
          backgroundColor: Theme.of(context).primaryColor,
          icon: const Icon(Icons.note_add_rounded),
          label: const Text('Add Files'),
        ),
        const SizedBox(height: 16),
        FloatingActionButton.extended(
          onPressed: _showCreateFolderDialog,
          heroTag: 'add_folder',
          backgroundColor: Theme.of(context).primaryColor,
          icon: const Icon(Icons.create_new_folder_sharp),
          label: const Text('Add Folder'),
        ),
      ],
    );
  }
}
