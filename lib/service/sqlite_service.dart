import 'dart:io';

import 'package:fahrtenbuch/model/log_entry.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqliteService {
  static const String TABLE = 'Fahrtenprotokoll';
  static const String DB_NAME = 'fahrtenprotokoll.db';

  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDB(DB_NAME);
    return _database!;
  }

  static final SqliteService instance = SqliteService._privateConstructor();
  SqliteService._privateConstructor();

  _initDB(String name) async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, name);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE Fahrtenprotokoll ("
        "id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "
        "start_date INTEGER NOT NULL,"
        "end_date INTEGER NOT NULL,"
        "start_location TEXT,"
        "end_location TEXT,"
        "reason TEXT,"
        "vehicle TEXT,"
        "start_mileage INTEGER,"
        "end_mileage INTEGER,"
        "parent INTEGER, "
        "FOREIGN KEY (parent) REFERENCES Fahrtenprotokoll (id) ON DELETE CASCADE "
        ")");
  }

  Future<LogEntry> save(LogEntry entry) async {
    Database db = await database;
    entry.id = await db.insert(TABLE, entry.toMap());
    return entry;
  }

  Future<List<LogEntry>> getAll() async {
    Database db = await database;
    List<Map<String, dynamic>> result = await db.query(TABLE);
    List<LogEntry> items = [];
    items = result.map((e) => LogEntry.fromMap(e)).toList();
    return items;
  }

  Future<int> delete(int id) async {
    Database db = await database;
    return await db.delete(TABLE, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> update(LogEntry entry) async {
    Database db = await database;
    return await db.update(TABLE, entry.toMap(), where: 'id = ?', whereArgs: [entry.id]);
  }
}
