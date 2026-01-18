import 'package:language_app/model/history_model.dart';
import 'package:sqflite/sqflite.dart';

class HistoryDao {
  final Database _database;

  HistoryDao(this._database);

  Future<List<History>> getAll() async {
    final maps = await _database.query('history');
    return maps.map(History.fromMap).toList();
  }

  Future<int> insert(History history) async {
    return _database.insert('history', history.toMap());
  }

  Future<void> update(History history) async {
    await _database.update(
      'history',
      history.toMap(),
      where: 'id=?',
      whereArgs: [history.id],
    );
  }

  Future<void> delete(int id) async {
    await _database.delete('history', where: 'id=?', whereArgs: [id]);
  }
}
