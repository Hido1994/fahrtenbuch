import 'package:fahrtenbuch/model/log_entry.dart';
import 'package:fahrtenbuch/service/sqlite_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

class FormScreen extends StatefulWidget {
  final int? entryId;

  const FormScreen({Key? key, this.entryId}) : super(key: key);

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  static final DateFormat dateTimeFormat = DateFormat('dd.MM.yyyy hh:mm');

  final _formKey = GlobalKey<FormState>();
  SqliteService sqliteService = SqliteService.instance;

  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _vehicleController = TextEditingController();
  final TextEditingController _startLocationController =
      TextEditingController();
  final TextEditingController _endLocationController = TextEditingController();
  final TextEditingController _startMileageController = TextEditingController();
  final TextEditingController _endMileageController = TextEditingController();

  DateTime _selectedStartDate = DateTime.now();
  DateTime _selectedEndDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text((widget.entryId == null ? "Neu" : "Bearbeiten")),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: const InputDecoration(label: Text("Abfahrt")),
                  readOnly: true,
                  controller: _startDateController,
                  onTap: () {
                    DatePicker.showDateTimePicker(context,
                        showTitleActions: true, onConfirm: (date) {
                      _selectedStartDate = date;
                      _startDateController.text = dateTimeFormat.format(date);
                    }, currentTime: _selectedStartDate, locale: LocaleType.de);
                  },
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        _selectedEndDate.isBefore(_selectedStartDate)) {
                      return 'Abfahrtszeit eingeben';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(label: Text("Ankunft")),
                  readOnly: true,
                  controller: _endDateController,
                  onTap: () {
                    DatePicker.showDateTimePicker(context,
                        showTitleActions: true, onConfirm: (date) {
                      _selectedEndDate = date;
                      _endDateController.text = dateTimeFormat.format(date);
                    }, currentTime: _selectedEndDate, locale: LocaleType.de);
                  },
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        _selectedEndDate.isBefore(_selectedStartDate)) {
                      return 'Ankunftszeit eingeben';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _reasonController,
                  decoration: const InputDecoration(label: Text("Zweck")),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Zweck der Fahrt eingeben';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _vehicleController,
                  decoration: const InputDecoration(label: Text("Fahrzeug")),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Fahrzeug eingeben';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _startLocationController,
                  decoration: const InputDecoration(label: Text("Abfahrtsort")),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Abfahrtsort eingeben';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _endLocationController,
                  decoration: const InputDecoration(label: Text("Ankunftsort")),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ankunftsort eingeben';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _startMileageController,
                  decoration:
                      const InputDecoration(label: Text("KM-Stand Abfahrt")),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'KM-Stand Abfahrt eingeben';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _endMileageController,
                  decoration:
                      const InputDecoration(label: Text("KM-Stand Ankunft")),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'KM-Stand Ankunft eingeben';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            sqliteService
                .save(LogEntry(
                  startDate: _selectedStartDate,
                  endDate: _selectedEndDate,
                  reason: _reasonController.text,
                  vehicle: _vehicleController.text,
                  startLocation: _startLocationController.text,
                  endLocation: _endLocationController.text,
                  startMileage: int.tryParse(_startMileageController.text),
                  endMileage: int.tryParse(_endMileageController.text),
                ))
                .then((value) => Navigator.pop(context, value));
          }
        },
        tooltip: 'Speichern',
        child: const Icon(Icons.check),
      ),
    );
  }
}
