abstract class AbstractRepository<T, ID> {
  Future<List<T>> getAll();

  Future<T> save(T entry);

  Future<ID> delete(ID id);

  Future<T> getById(ID id);

  Future<List<dynamic>> getDistinctValues(String column);
}
