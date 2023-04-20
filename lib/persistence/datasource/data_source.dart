abstract class DataSource {
  Future<dynamic> save(String table, Map<String, dynamic> entry);
  Future<List<Map<String, dynamic>>> getAll(String table);
  Future<dynamic> delete(String table, dynamic id, {String idName ='id'});
  Future<dynamic> update(String table, Map<String, dynamic> entry, {String idName ='id'});
}
