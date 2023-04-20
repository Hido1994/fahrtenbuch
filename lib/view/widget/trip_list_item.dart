import 'package:fahrtenbuch/persistence/model/trip.dart';
import 'package:fahrtenbuch/view/screen/form_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TripListItem extends StatelessWidget {
  final Trip entry;

  const TripListItem({Key? key, required this.entry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      child: ListTile(
        leading: const Icon(
          Icons.drive_eta,
        ),
        trailing: const Icon(Icons.edit),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${entry.vehicle} - ${entry.reason}',
            ),
            Text(
              '${entry.startLocation} - ${entry.endLocation}',
            ),
            Text(
              '${entry.startMileage} km - ${entry.endMileage} km (${entry.endMileage! - entry.startMileage!} km)',
            ),
          ],
        ),
        title: Text(
          '${DateFormat('dd.MM.yyyy').format(entry.startDate!)} - ${DateFormat('hh:mm').format(entry.startDate!)} - ${entry.endDate != null ? DateFormat('hh:mm').format(entry.endDate!) : 'offen'}',
        ),
        isThreeLine: true,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FormScreen(
                entryId: entry.id,
              ),
            ),
          );
        },
      ),
    );
  }
}
