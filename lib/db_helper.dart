import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'summary_model.dart';

class DBHelper {
  static Future<Database> _getDB() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'summaries.db'),
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE summaries(id INTEGER PRIMARY KEY AUTOINCREMENT, input TEXT, output TEXT)',
        );
      },
    );
  }

  static Future<void> insertSummary(Summary summary) async {
    final db = await _getDB();
    await db.insert('summaries', summary.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Summary>> getAllSummaries() async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query('summaries');
    return List.generate(maps.length, (i) => Summary.fromMap(maps[i])).reversed.toList();
  }
}
