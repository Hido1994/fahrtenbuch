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
  TripService tripService = TripService.instance;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      child: ListTile(
        leading: const Icon(
          Icons.drive_eta,
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            tripService.delete(widget.entry.id!);
            Provider.of<TripProviderState>(context, listen: false).refresh();
          },
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${widget.entry.vehicle} - ${widget.entry.reason}',
            ),
            Text(
              '${widget.entry.startLocation} - ${widget.entry.endLocation}',
            ),
            Text(
              '${widget.entry.startMileage} km - ${(widget.entry.endMileage != null ? widget.entry.endMileage! : '-')} km (${(widget.entry.endMileage != null ? widget.entry.endMileage! - widget.entry.startMileage! : '-')} km)',
            ),
          ],
        ),
        title: Text(
          '${DateFormat('dd.MM.yyyy').format(widget.entry.startDate!)} - ${DateFormat('HH:mm').format(widget.entry.startDate!)} - ${widget.entry.endDate != null ? DateFormat('HH:mm').format(widget.entry.endDate!) : 'offen'}',
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
      ),
    );
  }
}
