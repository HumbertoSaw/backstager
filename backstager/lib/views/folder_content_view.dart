import 'package:backstager/components/no_files_found.dart';
import 'package:backstager/database/database_conn.dart';
import 'package:backstager/database/file_dao.dart';
import 'package:backstager/models/MediaFile.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mime/mime.dart';

class FolderContentView extends StatefulWidget {
  final int? id;
  const FolderContentView({super.key, this.id});

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
          'BackStager',
          style: GoogleFonts.montaga(
            textStyle: const TextStyle(
              color: Color(0xFFFFD700),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: _filesAndFoldersGrid(),
    );
  }

  Padding _filesAndFoldersGrid() {
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
                // Handle file tap
                // OpenFile.open(file.filePath);
              },
              onLongPress: () {},
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: _buildFilePlaceholder(file.filePath.toString()),
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

  Widget _buildFilePlaceholder(String filePath) {
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
}
