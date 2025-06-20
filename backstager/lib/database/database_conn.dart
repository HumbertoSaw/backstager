import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseConn {
  static const _databaseName = 'backstager.db';
  static const _databaseVersion = 1;

  DatabaseConn._privateConstructor();
  static final DatabaseConn instance = DatabaseConn._privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE folders (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        coverImagePath TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE files (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        folderId INTEGER,
        filePath TEXT NOT NULL,
        imagePath TEXT,
        FOREIGN KEY (folderId) REFERENCES folders (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE clips (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        fileId INTEGER NOT NULL,
        name TEXT NOT NULL,
        startAt REAL NOT NULL,
        endAt REAL NOT NULL,
        color TEXT,
        FOREIGN KEY (fileId) REFERENCES files (id) ON DELETE CASCADE
      )
    ''');

    // await _insertDummyData(db);
  }

  Future<void> clearDatabase() async {
    final db = await database;
    await db.delete('clips');
    await db.delete('files');
    await db.delete('folders');
  }

  Future close() async {
    final db = await database;
    db.close();
  }

  Future<void> _insertDummyData(Database db) async {
    int folderId = await db.insert('folders', {
      'name': 'Sample Show',
      'coverImagePath': 'path/to/sample_cover.jpg',
    });

    int fileId1 = await db.insert('files', {
      'name': 'Scene 1',
      'folderId': folderId,
      'filePath': 'path/to/audio/scene1.mp3',
      'imagePath': 'path/to/scene1_image.jpg',
    });

    await db.insert('files', {
      'name': 'Scene 2',
      'folderId': null,
      'filePath': 'path/to/audio/scene2.mp3',
      'imagePath': 'path/to/scene2_image.jpg',
    });

    await db.insert('clips', {
      'fileId': fileId1,
      'startAt': 0.0,
      'endAt': 10.5,
    });

    await db.insert('clips', {
      'fileId': fileId1,
      'startAt': 12.0,
      'endAt': 20.0,
    });
  }
}
