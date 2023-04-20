import 'package:fahrtenbuch/persistence/model/trip.dart';
import 'package:fahrtenbuch/persistence/repository/trip_repository.dart';

class TripService {
  static final TripService instance = TripService._privateConstructor();

  TripService._privateConstructor();

  final TripRepository _tripRepository = TripRepository.instance;

  @override
  Future<int> delete(int id) async {
    return await _tripRepository.delete(id);
  }

  @override
  Future<List<Trip>> getAll() async {
    return await _tripRepository.getAll();
  }

  @override
  Future<Trip> save(Trip entry) async {
    return await _tripRepository.save(entry);
  }

  @override
  Future<int> update(Trip entry) async {
    return await _tripRepository.update(entry);
  }
}
