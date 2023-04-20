import 'package:fahrtenbuch/persistence/datasource/sqlite_data_source.dart';
import 'package:fahrtenbuch/service/preference_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreen();
}

class _SettingsScreen extends State<SettingsScreen> {
  PreferenceService preferenceService = PreferenceService.instance;
  SqliteDataSource sqliteDataSource = SqliteDataSource.instance;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _databasePathController = TextEditingController();

  @override
  void initState() {
    super.initState();
    preferenceService
        .getDatabasePath()
        .then((value) => _databasePathController.text = value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Form(
        key: _formKey,
        child: Container(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(children: <Widget>[
              TextFormField(
                decoration:
                    const InputDecoration(label: Text("Datenbank-Pfad")),
                readOnly: true,
                controller: _databasePathController,
                onTap: () async {
                  String? result = await FilePicker.platform.getDirectoryPath();

                  if (result != null) {
                    _databasePathController.text = result;
                    preferenceService.saveDatabasePath(result);
                  }
                },
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
