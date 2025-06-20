import 'package:backstager/database/database_conn.dart';
import 'package:backstager/models/MediaClip.dart';

class MediaClipDao {
  final DatabaseConn conn;

  MediaClipDao(this.conn);

  Future<int> insertMediaClip(MediaClip clip) async {
    final db = await conn.database;
    return await db.insert('clips', clip.toMap());
  }

  Future<List<MediaClip>> getAllMediaClips() async {
    final db = await conn.database;
    final List<Map<String, dynamic>> maps = await db.query('clips');
    return List.generate(maps.length, (i) {
      return MediaClip.fromMap(maps[i]);
    });
  }

  Future<List<MediaClip>> getMediaClipsByFileId(int fileId) async {
    final db = await conn.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'clips',
      where: 'fileId = ?',
      whereArgs: [fileId],
    );
    return List.generate(maps.length, (i) {
      return MediaClip.fromMap(maps[i]);
    });
  }

  Future<MediaClip?> getMediaClipById(int id) async {
    final db = await conn.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'clips',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return MediaClip.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateMediaClip(MediaClip clip) async {
    final db = await conn.database;
    return await db.update(
      'clips',
      clip.toMap(),
      where: 'id = ?',
      whereArgs: [clip.id],
    );
  }

  Future<int> deleteMediaClip(int id) async {
    final db = await conn.database;
    return await db.delete('clips', where: 'id = ?', whereArgs: [id]);
  }
}
