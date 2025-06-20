import 'package:backstager/database/database_conn.dart';
import 'package:backstager/models/MediaFile.dart';

class MediaFileDao {
  final DatabaseConn conn;

  MediaFileDao(this.conn);

  Future<int> insertMediaFile(MediaFile file) async {
    final db = await conn.database;
    return await db.insert('files', file.toMap());
  }

  Future<List<MediaFile>> getAllMediaFiles() async {
    final db = await conn.database;
    final List<Map<String, dynamic>> maps = await db.query('files');
    return List.generate(maps.length, (i) {
      return MediaFile.fromMap(maps[i]);
    });
  }

  Future<List<MediaFile>> getMediaFilesByFolderId(int? folderId) async {
    final db = await conn.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'files',
      where: 'folderId = ?',
      whereArgs: [folderId],
    );
    return List.generate(maps.length, (i) {
      return MediaFile.fromMap(maps[i]);
    });
  }

  Future<MediaFile?> getMediaFileById(int id) async {
    final db = await conn.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'files',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return MediaFile.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateMediaFile(MediaFile file) async {
    final db = await conn.database;
    return await db.update(
      'files',
      file.toMap(),
      where: 'id = ?',
      whereArgs: [file.id],
    );
  }

  Future<int> deleteMediaFile(int id) async {
    final db = await conn.database;
    return await db.delete('files', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> patchFolderId(int fileId, int? newFolderId) async {
    final db = await conn.database;
    return await db.update(
      'files',
      {'folderId': newFolderId},
      where: 'id = ?',
      whereArgs: [fileId],
    );
  }
}
