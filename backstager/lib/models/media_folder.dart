import 'dart:io';

class MediaFolder {
  final String name;
  final File? imageFile;
  final Directory directory;

  MediaFolder({
    required this.name,
    required this.imageFile,
    required this.directory,
  });
}
