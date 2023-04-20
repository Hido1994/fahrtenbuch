import 'package:fahrtenbuch/persistence/datasource/data_source.dart';
import 'package:fahrtenbuch/persistence/datasource/sqlite_data_source.dart';
import 'package:fahrtenbuch/persistence/model/trip.dart';
import 'package:fahrtenbuch/persistence/repository/abstract_repository.dart';

class TripRepository extends AbstractRepository<Trip, int> {
  static const String _table = 'Trip';
  final DataSource _dataSource = SqliteDataSource.instance;

  static final TripRepository instance = TripRepository._privateConstructor();

  TripRepository._privateConstructor();

  @override
  Future<int> delete(int id) async {
    return await _dataSource.delete(_table, id);
  }

  @override
  Future<List<Trip>> getAll() async {
    List<Map<String, dynamic>> result = await _dataSource.getAll(_table);
    return result.map((e) => Trip.fromJson(e)).toList();
  }

  @override
  Future<Trip> save(Trip entry) async {
    entry.id = await _dataSource.save(_table, entry.toJson());
    return entry;
  }

  @override
  Future<int> update(Trip entry) async {
    return await _dataSource.update(_table, entry.toJson());
  }
}
