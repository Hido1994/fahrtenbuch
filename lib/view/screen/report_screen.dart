import 'dart:typed_data';

import 'package:excel/excel.dart';
import 'package:fahrtenbuch/service/report_service.dart';
import 'package:fahrtenbuch/service/trip_service.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreen();
}

class _ReportScreen extends State<ReportScreen> {
  final _formKey = GlobalKey<FormState>();
  ReportService reportService = ReportService.instance;
  TripService tripService = TripService.instance;

  List<int> years = [];

  int? selectedYear;

  @override
  void initState() {
    super.initState();

    tripService.getYears().then((value) => setState(() {
          years = value;
          selectedYear = years[0];
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Report')),
      body: Form(
        key: _formKey,
        child: Container(
          padding: const EdgeInsets.all(30),
          child: SingleChildScrollView(
            child: Column(children: <Widget>[
              if(years.isNotEmpty) DropdownButton(
                  isExpanded: true,
                  value: selectedYear,
                  // dropdownColor: Colors.grey.shade900..withOpacity(0.5),
                  items: years.map<DropdownMenuItem<int>>((int item) {
                    return DropdownMenuItem<int>(
                      value: item,
                      child: Text(item.toString()),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedYear = value;
                    });
                  }),
            ]),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);

          Excel excel = await reportService.generateExcel(selectedYear);
          ShareResult result = await Share.shareXFiles([
            XFile.fromData(Uint8List.fromList(excel.encode()!),
                mimeType: 'xlsx')
          ]);
          if (ShareResultStatus.success == result.status) {
            messenger.showSnackBar(const SnackBar(
              content: Text('Report erstellt!'),
              behavior: SnackBarBehavior.floating,
            ));
          }
        },
        tooltip: 'Export',
        child: const Icon(Icons.download_rounded),
      ),
    );
  }
}
