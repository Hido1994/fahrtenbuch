import 'package:fahrtenbuch/persistence/model/trip.dart';
import 'package:fahrtenbuch/service/trip_service.dart';
import 'package:fahrtenbuch/view/widget/autocomplete_text_form_field.dart';
import 'package:fahrtenbuch/view/widget/datetime_picker_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/trip_provider_state.dart';

class FormScreen extends StatefulWidget {
  final int? entryId;
  final int? parentId;
  final bool finalize;

  const FormScreen(
      {Key? key, this.entryId, this.parentId, this.finalize = false})
      : super(key: key);

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();
  TripService tripService = TripService.instance;

  Trip trip = Trip();

  List<String> vehicles = [];
  List<String> reasons = [];
  List<String> locations = [];

  Future<void> _initTrip() async {
    DateTime now = DateTime.now();
    now = now.subtract(Duration(seconds: now.second));

    List<String> vehicles = await tripService.getVehicles();
    List<String> reasons = await tripService.getReasons();
    List<String> locations = await tripService.getLocations();

    Trip trip = Trip();
    trip.parent = widget.parentId;

    if (widget.entryId == null) {
      trip.startDate = now;

      if (reasons.isNotEmpty) {
        trip.reason = reasons[0];
      }
      if (vehicles.isNotEmpty) {
        trip.vehicle = vehicles[0];
      }

      trip.startMileage = await tripService.getLastEndMileage();
      trip.startLocation = await tripService.getLastEndLocation();
    } else {
      trip = await tripService.getById(widget.entryId!);
    }

    if (this.trip.endDate == null && widget.finalize) {
      trip.endDate = now;
    }

    setState(() {
      this.trip = trip;
      this.vehicles = vehicles;
      this.reasons = reasons;
      this.locations = locations;
    });
  }

  @override
  void initState() {
    super.initState();

    _initTrip();
  }

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
                DateTimePickerTextFormField(
                  key: UniqueKey(),
                  title: 'Abfahrt',
                  initialValue: trip.startDate,
                  onChanged: (date) {
                    trip.startDate = date;
                  },
                ),
                DateTimePickerTextFormField(
                    key: UniqueKey(),
                    title: 'Ankunft',
                    initialValue: trip.endDate,
                    onChanged: (date) {
                      trip.endDate = date;
                    }),
                AutocompleteTextFormField(
                    key: UniqueKey(),
                    title: 'Zweck',
                    options: vehicles,
                    initialValue: trip.reason,
                    onChanged: (value) {
                      trip.reason = value;
                    }),
                AutocompleteTextFormField(
                    key: UniqueKey(),
                    title: 'Fahrzeug',
                    options: vehicles,
                    initialValue: trip.vehicle,
                    onChanged: (value) {
                      trip.vehicle = value;
                    }),
                AutocompleteTextFormField(
                    key: UniqueKey(),
                    title: 'Abfahrtsort',
                    options: locations,
                    initialValue: trip.startLocation,
                    onChanged: (value) {
                      trip.startLocation = value;
                    }),
                AutocompleteTextFormField(
                    key: UniqueKey(),
                    title: 'Ankunftsort',
                    options: locations,
                    initialValue: trip.endLocation,
                    onChanged: (value) {
                      trip.endLocation = value;
                    }),
                AutocompleteTextFormField(
                    key: UniqueKey(),
                    title: 'KM-Abfahrt',
                    options: const [],
                    initialValue: trip.startMileage?.toString(),
                    onChanged: (value) {
                      trip.startMileage = int.tryParse(value);
                    }),
                AutocompleteTextFormField(
                    key: UniqueKey(),
                    title: 'KM-Ankunft',
                    options: const [],
                    initialValue: trip.endMileage?.toString(),
                    onChanged: (value) {
                      trip.endMileage = int.tryParse(value);
                    }),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            tripService.save(trip).then((value) {
              Provider.of<TripProviderState>(context, listen: false).refresh();

              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Fahrt aktualisiert!'),
                behavior: SnackBarBehavior.floating,
              ));
              Navigator.pop(context);
            });
          }
        },
        tooltip: 'Speichern',
        child: const Icon(Icons.check),
      ),
    );
  }
}
