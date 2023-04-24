import 'package:fahrtenbuch/persistence/model/trip.dart';
import 'package:fahrtenbuch/service/trip_service.dart';
import 'package:flutter/material.dart';

class TripState extends ChangeNotifier {
  TripService tripService = TripService.instance;

  List<Trip> trips = [];

  void add(Trip trip) {
    trips.add(trip);
    notifyListeners();
  }

  void refresh() {
    tripService.getAll().then((value) {
      trips = value;
      notifyListeners();
    });
  }
}
