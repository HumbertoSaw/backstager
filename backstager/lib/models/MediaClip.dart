class MediaClip {
  final int? id;
  int? fileId;
  final double startAt;
  final double endAt;

  MediaClip({
    this.id,
    required this.fileId,
    required this.startAt,
    required this.endAt,
  });

  Map<String, dynamic> toMap() {
    return {'id': id, 'fileId': fileId, 'startAt': startAt, 'endAt': endAt};
  }

  factory MediaClip.fromMap(Map<String, dynamic> map) {
    return MediaClip(
      id: map['id'],
      fileId: map['fileId'],
      startAt: map['startAt'],
      endAt: map['endAt'],
    );
  }
}
