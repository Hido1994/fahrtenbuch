import 'package:fahrtenbuch/persistence/datasource/data_source.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqliteDataSource extends DataSource {
  static const String dbName = 'trip.db';
  Database? _database;

  static final SqliteDataSource instance =
      SqliteDataSource._privateConstructor();

  SqliteDataSource._privateConstructor();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDB(dbName);
    return _database!;
  }

  _initDB(String name) async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, name);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE Trip ("
        "id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "
        "startDate INTEGER NOT NULL,"
        "endDate INTEGER NOT NULL,"
        "startLocation TEXT,"
        "endLocation TEXT,"
        "reason TEXT,"
        "vehicle TEXT,"
        "startMileage INTEGER,"
        "endMileage INTEGER,"
        "parent INTEGER, "
        "FOREIGN KEY (parent) REFERENCES Fahrtenprotokoll (id) ON DELETE CASCADE "
        ")");
  }

  @override
  Future<dynamic> save(String table, Map<String, dynamic> entry) async {
    Database db = await database;
    dynamic id = await db.insert(table, entry);
    return id;
  }

  @override
  Future<List<Map<String, dynamic>>> getAll(String table) async {
    Database db = await database;
    List<Map<String, dynamic>> result = await db.query(table);
    return result;
  }

  @override
  Future<dynamic> delete(String table, dynamic id, {String idName ='id'}) async {
    Database db = await database;
    return await db.delete(table, where: '$idName = ?', whereArgs: [id]);
  }

  @override
  Future<dynamic> update(String table, Map<String, dynamic> entry, {String idName ='id'}) async {
    Database db = await database;
    return await db
        .update(table, entry, where: '$idName = ?', whereArgs: [entry[idName]]);
  }
}
