class MediaFolder {
  final int? id;
  final String name;
  final String? coverImagePath;

  MediaFolder({this.id, required this.name, this.coverImagePath});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'coverImagePath': coverImagePath};
  }

  factory MediaFolder.fromMap(Map<String, dynamic> map) {
    return MediaFolder(
      id: map['id'],
      name: map['name'],
      coverImagePath: map['coverImagePath'],
    );
  }
}
