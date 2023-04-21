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

  void _refreshList(){
    sqliteService.getAll().then((result) => {
      setState(() {
        entries = result;
      })
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshList();
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
          await Navigator.of(context, rootNavigator: true).push(
              MaterialPageRoute(builder: (context) => const FormScreen()));

          _refreshList();
        },
        tooltip: 'Neu',
        child: const Icon(Icons.add),
      ),
    );
  }
}
