import 'package:backstager/database/database_conn.dart';
import 'package:backstager/models/MediaFolder.dart';

class MediaFolderDao {
  final DatabaseConn conn;

  MediaFolderDao(this.conn);

  Future<int> insertMediaFolder(MediaFolder folder) async {
    final db = await conn.database;
    return await db.insert('folders', folder.toMap());
  }

  Future<List<MediaFolder>> getAllMediaFolders() async {
    final db = await conn.database;
    final List<Map<String, dynamic>> maps = await db.query('folders');
    return List.generate(maps.length, (i) {
      return MediaFolder.fromMap(maps[i]);
    });
  }

  Future<MediaFolder?> getMediaFolderById(int id) async {
    final db = await conn.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'folders',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return MediaFolder.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateMediaFolder(MediaFolder folder) async {
    final db = await conn.database;
    return await db.update(
      'folders',
      folder.toMap(),
      where: 'id = ?',
      whereArgs: [folder.id],
    );
  }

  Future<int> deleteMediaFolder(int id) async {
    final db = await conn.database;
    return await db.delete('folders', where: 'id = ?', whereArgs: [id]);
  }
}
