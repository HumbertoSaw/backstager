class MediaClip {
  final int? id;
  final int? fileId;
  String name;
  double startAt;
  double endAt;
  String? color;

  MediaClip({
    this.id,
    required this.fileId,
    required this.name,
    required this.startAt,
    required this.endAt,
    this.color,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fileId': fileId,
      'name': name,
      'startAt': startAt,
      'endAt': endAt,
      'color': color,
    };
  }

  factory MediaClip.fromMap(Map<String, dynamic> map) {
    return MediaClip(
      id: map['id'],
      fileId: map['fileId'],
      name: map['name'],
      startAt: map['startAt'],
      endAt: map['endAt'],
      color: map['color'],
    );
  }
}
