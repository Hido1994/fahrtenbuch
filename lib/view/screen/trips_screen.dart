import 'package:fahrtenbuch/persistence/model/trip.dart';
import 'package:fahrtenbuch/service/trip_service.dart';
import 'package:fahrtenbuch/view/screen/form_screen.dart';
import 'package:fahrtenbuch/view/widget/trip_list_item.dart';
import 'package:flutter/material.dart';

class TripsScreen extends StatefulWidget {
  const TripsScreen({super.key});

  @override
  State<TripsScreen> createState() => _MyTripsScreen();
}

class _MyTripsScreen extends State<TripsScreen> {
  TripService sqliteService = TripService.instance;
  List<Trip> entries = [];

  @override
  void initState() {
    super.initState();
    sqliteService.getAll().then((result) => {
          setState(() {
            entries = result;
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fahrtenbuch')),
      body: ListView.separated(
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          return TripListItem(entry: entries[index]);
        },
        itemCount: entries.length,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Trip? newEntry = await Navigator.of(context, rootNavigator: true).push(
              MaterialPageRoute(builder: (context) => const FormScreen()));

          if (newEntry != null) {
            setState(() {
              entries.add(newEntry);
            });
          }
        },
        tooltip: 'Neu',
        child: const Icon(Icons.add),
      ),
    );
  }
}
