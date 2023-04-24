import 'package:fahrtenbuch/persistence/model/trip.dart';
import 'package:fahrtenbuch/persistence/repository/trip_repository.dart';

class TripService {
  static final TripService instance = TripService._privateConstructor();

  TripService._privateConstructor();

  final TripRepository _tripRepository = TripRepository.instance;

  Future<int> delete(int id) async {
    return await _tripRepository.delete(id);
  }

  Future<List<Trip>> getAll() async {
    return await _tripRepository.getAll();
  }

  Future<Trip> save(Trip entry) async {
    return await _tripRepository.save(entry);
  }

  Future<Trip> getById(int id) async {
    return await _tripRepository.getById(id);
  }

  Future<List<String>> getReasons() async {
    return (await _tripRepository.getDistinctValues('reason'))
        .map((e) => e as String)
        .toList();
  }

  Future<List<String>> getVehicles() async {
    return (await _tripRepository.getDistinctValues('vehicle'))
        .map((e) => e as String)
        .toList();
  }

  Future<DateTime?> getLastEndDate() async {
    List result = await _tripRepository.getDistinctValues('endDate');
    return Trip.millisecondsToDateTime(result.first);
  }

  Future<int?> getLastEndMileage() async {
    List result = await _tripRepository.getDistinctValues('endMileage');
    return result.isNotEmpty ? result.first : null;
  }

  Future<String?> getLastEndLocation() async {
    List result = await _tripRepository.getDistinctValues('endLocation');
    return result.isNotEmpty ? result.first : null;
  }

  Future<List<String>> getLocations() async {
    List startLocations =
        await _tripRepository.getDistinctValues('startLocation');
    List endLocations = await _tripRepository.getDistinctValues('endLocation');
    return {...startLocations, ...endLocations}
        .map((e) => e as String)
        .toList();
  }
}
