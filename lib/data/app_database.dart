import 'package:language_app/data/character_data.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

final characterSchema = '''
CREATE TABLE characters (
id INTEGER PRIMARY KEY AUTOINCREMENT,
character TEXT NOT NULL,
translation TEXT NOT NULL,
character_group TEXT NOT NULL,
audio TEXT NOT NULL
);''';

final historySchema = '''
CREATE TABLE history (
id INTEGER PRIMARY KEY AUTOINCREMENT,
character_fk INTEGER NOT NULL,
date INTEGER NOT NULL,
correct BOOL NOT NULL
);
''';

final class AppDatabase {
  // singleton pattern
  static final AppDatabase instance = AppDatabase._();
  static Database? _database;

  // This is a private constructor
  AppDatabase._();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    print('DB PATH: $dbPath');
    final path = join(dbPath, 'app.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int verion) async {
    await db.execute(characterSchema);
    await db.execute(historySchema);
    for (var char in characterList) {
      await db.insert('characters', char);
    }
  }
}
