import 'dart:io';
import 'dart:typed_data';

import 'package:excel/excel.dart';
import 'package:fahrtenbuch/service/trip_service.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreen();
}

class _ReportScreen extends State<ReportScreen> {
  TripService sqliteService = TripService.instance;

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
          Sheet sheet = excel['Sheet1'];
          sheet.appendRow(['test', 'test']);
          Share.shareXFiles([XFile.fromData(Uint8List.fromList(excel.encode()!))]);
        },
        tooltip: 'Export',
        child: const Icon(Icons.download_rounded),
      ),
    );
  }
}
