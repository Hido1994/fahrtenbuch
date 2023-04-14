import 'package:fahrtenbuch/model/log_entry.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LogEntryWidget extends StatelessWidget {
  final LogEntry entry;

  const LogEntryWidget({Key? key, required this.entry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      child: ListTile(
        leading: const Icon(
          Icons.car_rental,
        ),
        trailing: const IconButton(onPressed: null, icon: Icon(Icons.edit)),
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
              '${entry.startMileage} km - ${entry.endMileage} km (${entry.endMileage!-entry.startMileage!} km)',
            ),
          ],
        ),
        title: Text(
          '${DateFormat('dd.MM.yyyy').format(entry.startDate)} - ${DateFormat('hh:mm').format(entry.startDate)} - ${DateFormat('hh:mm').format(entry.endDate)}',
        ),
        isThreeLine: true,
      ),
    );
  }
}
