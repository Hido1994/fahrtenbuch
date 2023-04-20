abstract class AbstractRepository<T, ID> {
  Future<List<T>> getAll();

  Future<T> save(T entry);

  Future<ID> delete(ID id);

  Future<ID> update(T entry);
}
