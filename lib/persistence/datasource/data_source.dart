abstract class DataSource {
  Future<dynamic> save(String table, Map<String, dynamic> entry);
  Future<List<Map<String, dynamic>>> getAll(String table, {String? where, String? orderBy});
  Future<Map<String, dynamic>> getById(String table, dynamic id, {String idName ='id'});
  Future<List<dynamic>> getDistinctValues(String table, String column);
  Future<dynamic> delete(String table, dynamic id, {String idName ='id'});
  Future<dynamic> update(String table, Map<String, dynamic> entry, {String idName ='id'});
}
