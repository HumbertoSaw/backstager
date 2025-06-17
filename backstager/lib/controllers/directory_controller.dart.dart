import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/media_folder.dart';

class DirectoryController {
  Future<Directory> getRootDirectory() async {
    final appDir = await getApplicationDocumentsDirectory();
    final savedFilesDir = Directory('${appDir.path}/saved_media_files');

    if (!await savedFilesDir.exists()) {
      await savedFilesDir.create(recursive: true);
    }

    return savedFilesDir;
  }

  Future<List<FileSystemEntity>> loadDirectoryContents(
    Directory directory,
  ) async {
    return await directory.list().toList();
  }

  Future<void> moveFile(File file, Directory destination) async {
    final newPath = '${destination.path}/${file.path.split('/').last}';
    await file.rename(newPath);
  }

  Future<List<MediaFolder>> getAllFolders(Directory rootDir) async {
    final entities = await rootDir.list(recursive: true).toList();
    final directories = entities.whereType<Directory>().toList();

    List<MediaFolder> allFolders = [];
    for (var dir in directories) {
      final dirFiles = await dir.list().toList();
      File? imageFile;

      for (var file in dirFiles.whereType<File>()) {
        final fileName = file.path.split('/').last;
        if (fileName.startsWith('folder_image.')) {
          imageFile = file;
          break;
        }
      }

      allFolders.add(
        MediaFolder(
          name: dir.path.split('/').last,
          imageFile: imageFile,
          directory: dir,
        ),
      );
    }

    return allFolders;
  }

  String getFileName(String path) {
    return path.split('/').last;
  }
}
