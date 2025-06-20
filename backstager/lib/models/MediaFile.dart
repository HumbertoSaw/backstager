class MediaFile {
  final int? id;
  String name;
  int? folderId;
  String? filePath;
  String? imagePath;

  MediaFile({
    this.id,
    required this.name,
    this.folderId,
    this.filePath,
    this.imagePath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'folderId': folderId,
      'filePath': filePath,
      'imagePath': imagePath,
    };
  }

  factory MediaFile.fromMap(Map<String, dynamic> map) {
    return MediaFile(
      id: map['id'],
      name: map['name'],
      folderId: map['folderId'],
      filePath: map['filePath'],
      imagePath: map['imagePath'],
    );
  }
}
