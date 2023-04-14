import 'package:fahrtenbuch/model/log_entry.dart';
import 'package:fahrtenbuch/service/sqlite_service.dart';
import 'package:fahrtenbuch/view/widget/log_entry_widget.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});

  final String title;

  @override
  State<HomeScreen> createState() => _MyHomeScreen();
}

class _MyHomeScreen extends State<HomeScreen> {
  // PreferenceService preferenceService = PreferenceService();
  SqliteService sqliteService = SqliteService.instance;
  List<LogEntry> entries = [];

  @override
  void initState() {
    // String? databasePath = await preferenceService.getDatabasePath();
    //
    // if(databasePath == null) {
    //   FilePickerResult? result = await FilePicker.platform.pickFiles();
    //
    //   if (result != null) {
    //     // File file = File(result.files.single.path);
    //   } else {
    //     // Do something else...
    //   }
    // }
    super.initState();
    sqliteService.getAll().then((result) => entries = result);
  }

  void _addEntry() async {
    LogEntry entry = LogEntry(
      startDate: DateTime.now(),
      endDate: DateTime.now(),
      startLocation: 'Test',
      endLocation: 'Test2',
      reason: 'Cortecs',
      vehicle: 'VW Golf',
      startMileage: 20000,
      endMileage: 20200,
    );

    entry = await sqliteService.save(entry);

    setState(() {
      entries.add(entry);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.separated(
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          return LogEntryWidget(entry: entries[index]);
        },
        itemCount: entries.length,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addEntry,
        tooltip: 'Neu',
        child: const Icon(Icons.add),
      ),
    );
  }
}
