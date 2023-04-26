import 'dart:io';
import 'dart:typed_data';

import 'package:excel/excel.dart';
import 'package:fahrtenbuch/persistence/model/trip.dart';
import 'package:fahrtenbuch/service/trip_service.dart';
import 'package:fahrtenbuch/state/trip_provider_state.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreen();
}

class _ReportScreen extends State<ReportScreen> {
  TripService tripService = TripService.instance;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Report')),
      body: const Placeholder(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Excel excel = Excel.createExcel();
          Sheet sheet = excel['protokoll'];

          List<Trip> trips =
              Provider.of<TripProviderState>(context, listen: false).trips;
          sheet.appendRow(trips.first.toJson().keys.toList());
          for (var element in trips) {
            sheet.appendRow(element.toJson().values.toList());
          }

          Share.shareXFiles(
              [XFile.fromData(Uint8List.fromList(excel.encode()!), name: 'report', mimeType: 'xlsx')]);
        },
        tooltip: 'Export',
        child: const Icon(Icons.download_rounded),
      ),
    );
  }
}
