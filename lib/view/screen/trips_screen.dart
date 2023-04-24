import 'package:fahrtenbuch/persistence/model/trip.dart';
import 'package:fahrtenbuch/service/trip_service.dart';
import 'package:fahrtenbuch/state/trip_state.dart';
import 'package:fahrtenbuch/view/screen/form_screen.dart';
import 'package:fahrtenbuch/view/widget/trip_list_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TripsScreen extends StatefulWidget {
  const TripsScreen({super.key});

  @override
  State<TripsScreen> createState() => _MyTripsScreen();
}

class _MyTripsScreen extends State<TripsScreen> {
  TripService tripService = TripService.instance;
  List<Trip> entries = [];

  @override
  void initState() {
    super.initState();
    Provider.of<TripState>(context, listen: false).refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fahrtenbuch')),
      body: Consumer<TripState>(
          builder: (context, state, child) {
            return ListView.separated(
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                return TripListItem(entry: state.trips[index]);
              },
              itemCount: state.trips.length,
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context, rootNavigator: true).push(
              MaterialPageRoute(builder: (context) => const FormScreen()));
        },
        tooltip: 'Neu',
        child: const Icon(Icons.add),
      ),
    );
  }
}
