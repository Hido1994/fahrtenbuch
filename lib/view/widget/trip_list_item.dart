import 'package:fahrtenbuch/persistence/model/trip.dart';
import 'package:fahrtenbuch/service/trip_service.dart';
import 'package:fahrtenbuch/state/trip_provider_state.dart';
import 'package:fahrtenbuch/view/screen/form_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TripListItem extends StatefulWidget {
  final Trip entry;

  const TripListItem({Key? key, required this.entry}) : super(key: key);

  @override
  State<TripListItem> createState() => _TripListItem();
}

class _TripListItem extends State<TripListItem> {
  static final DateFormat dateTimeFormat = DateFormat('dd.MM.yyyy HH:mm');
  static final DateFormat timeFormat = DateFormat('HH:mm');
  static final NumberFormat numberFormat = NumberFormat('#,### km', 'de_AT');

  TripService tripService = TripService.instance;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
        key: ObjectKey(widget.entry.id!),
        background: Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 20),
          color: Colors.green,
          child: const Icon(Icons.add),
        ),
        secondaryBackground: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          color: Colors.red,
          child: const Icon(Icons.delete),
        ),
        confirmDismiss: (direction) async {
          if (DismissDirection.endToStart == direction) {
            return await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text("Löschen"),
                  content: const Text("Sind Sie sicher?"),
                  actions: <Widget>[
                    TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text("Löschen")),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text("Abbrechen"),
                    ),
                  ],
                );
              },
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FormScreen(
                  parentId: widget.entry.parent ?? widget.entry.id,
                ),
              ),
            );
            return false;
          }
        },
        onDismissed: (direction) {
          if (DismissDirection.endToStart == direction) {
            tripService.delete(widget.entry.id!);
            Provider.of<TripProviderState>(context, listen: false).refresh();

            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Fahrt gelöscht!'),
              behavior: SnackBarBehavior.floating,
            ));
          }
        },
        child: ListTile(
          leading: Icon(
            widget.entry.parent == null
                ? Icons.drive_eta_outlined
                : Icons.arrow_forward_rounded,
          ),
          trailing: IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FormScreen(
                    entryId: widget.entry.id,
                    finalize: true,
                  ),
                ),
              );
            },
          ),
          title: Text(
            '${dateTimeFormat.format(widget.entry.startDate!)} - ${widget.entry.endDate != null ? timeFormat.format(widget.entry.endDate!) : 'TBD'}',
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${widget.entry.startLocation != null ? widget.entry.startLocation! : 'TBD'} - ${widget.entry.endLocation != null ? widget.entry.endLocation! : 'TBD'}',
              ),
              Text(
                '${widget.entry.type != null ? widget.entry.type! : 'TBD'} - ${widget.entry.reason != null ? widget.entry.reason! : 'TBD'}',
              ),
              const Text(
                '',
              ),
              Text(
                widget.entry.vehicle != null ? widget.entry.vehicle! : 'TBD',
              ),
              if (widget.entry.startMileage != null)
                Text(
                  '${(widget.entry.startMileage != null ? numberFormat.format(widget.entry.startMileage!) : 'TBD')} - ${(widget.entry.endMileage != null ? numberFormat.format(widget.entry.endMileage!) : 'TBD')} (${(widget.entry.startMileage != null && widget.entry.endMileage != null ? numberFormat.format(widget.entry.endMileage! - widget.entry.startMileage!) : 'TBD')})',
                ),
            ],
          ),
          isThreeLine: true,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FormScreen(
                  entryId: widget.entry.id,
                ),
              ),
            );
          },
        ));
  }
}
