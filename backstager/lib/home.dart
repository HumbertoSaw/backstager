import 'dart:io';
import 'package:backstager/components/sidebar-menu-component.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool _firstBuild = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<FileSystemEntity> _savedFiles = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSavedFiles();
  }

  Future<void> _loadSavedFiles() async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final savedFilesDir = Directory('${appDir.path}/saved_media_files');

      if (await savedFilesDir.exists()) {
        final files = await savedFilesDir.list().toList();
        setState(() {
          _savedFiles = files.where((file) => file is File).toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      debugPrint('Error loading saved files: $e');
    }
  }

  Widget _buildFileIcon(String path) {
    if (path.endsWith('.mp3') ||
        path.endsWith('.wav') ||
        path.endsWith('.m4a')) {
      return const Icon(Icons.audiotrack, size: 48);
    } else if (path.endsWith('.mp4') ||
        path.endsWith('.mov') ||
        path.endsWith('.avi')) {
      return const Icon(Icons.videocam, size: 48);
    } else {
      return const Icon(Icons.insert_drive_file, size: 48);
    }
  }

  String _getFileName(String path) {
    return path.split('/').last;
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
        title: const Text('Saved Media Files'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadSavedFiles,
          ),
        ],
      ),
      drawer: const SidebarMenuComponent(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _savedFiles.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [const Icon(Icons.folder_off_rounded, size: 64)],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 0.8,
                ),
                itemCount: _savedFiles.length,
                itemBuilder: (context, index) {
                  final file = _savedFiles[index];
                  final fileName = _getFileName(file.path);

                  return Card(
                    child: InkWell(
                      onTap: () => OpenFile.open(file.path),
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
            ),
    );
  }
}
