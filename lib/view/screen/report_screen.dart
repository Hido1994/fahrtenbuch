import 'dart:typed_data';

import 'package:excel/excel.dart';
import 'package:fahrtenbuch/service/report_service.dart';
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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Report')),
      body: Form(
        key: _formKey,
        child: Container(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(children: <Widget>[
              DropdownButton(items: null, onChanged: (value) {}),
            ]),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);

          Excel excel = await reportService.generateExcel();
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
