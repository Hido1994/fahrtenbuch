import 'package:excel/excel.dart';
import 'package:fahrtenbuch/persistence/model/trip.dart';
import 'package:fahrtenbuch/service/trip_service.dart';
import 'package:intl/intl.dart';

class ReportService {
  static final DateFormat dateTimeFormat = DateFormat('dd.MM.yyyy HH:mm');

  static final ReportService instance = ReportService._privateConstructor();

  TripService tripService = TripService.instance;

  ReportService._privateConstructor();

  Future<Excel> generateExcel() async {
    Excel excel = Excel.createExcel();
    await _generateProtokollSheet(excel);
    await _generateReiseSheet(excel);

    excel.delete('Sheet1');
    return excel;
  }

  Future<void> _generateProtokollSheet(Excel excel) async {
    Sheet sheet = excel['Protokoll'];

    CellStyle cellStyle = CellStyle(
      bold: true,
      textWrapping: TextWrapping.WrapText,
    );
    List<String> header = [
      'Abfahrt',
      'Ankunft',
      'Abfahrtsort',
      'Ankunftsort',
      'Zweck',
      'Fahrzeug',
      'KM-Abfahrt',
      'KM-Ankunft',
      'gefahren (km)',
    ];
    sheet.appendRow(header);
    sheet.row(0).forEach((element) {
      element!.cellStyle = cellStyle;
    });

    List<Trip> trips = await tripService.getAll();
    int rowIndex = 2;
    for (var element in trips.reversed) {
      List<dynamic> row = [
        element.startDate != null
            ? dateTimeFormat.format(element.startDate!)
            : null,
        element.endDate != null
            ? dateTimeFormat.format(element.endDate!)
            : null,
        element.startLocation,
        element.endLocation,
        element.reason,
        element.vehicle,
        element.startMileage,
        element.endMileage ?? element.startMileage,
        Formula.custom("H$rowIndex-G$rowIndex"),
      ];
      sheet.appendRow(row);
      rowIndex++;
    }
  }

  Future<void> _generateReiseSheet(Excel excel) async {
    Sheet sheet = excel['Reise'];

    CellStyle cellStyle = CellStyle(
      bold: true,
      textWrapping: TextWrapping.WrapText,
    );
    List<String> header = [
      'Abfahrt',
      'Ankunft',
      'Reiseweg',
      'Zweck',
      'Fahrzeuge',
    ];
    sheet.appendRow(header);
    sheet.row(0).forEach((element) {
      element!.cellStyle = cellStyle;
    });

    List<Trip> trips = await tripService.getAll();
    List<dynamic> row = [];
    for (var element in trips.reversed) {
      if (element.parent == null) {
        if (row.isNotEmpty) {
          sheet.appendRow(row);
        }
        row = [
          element.startDate != null
              ? dateTimeFormat.format(element.startDate!)
              : null,
          element.endDate != null
              ? dateTimeFormat.format(element.endDate!)
              : null,
          '${element.startLocation} - ${element.endLocation}',
          element.reason,
          element.vehicle
        ];
      } else {
        row[1] = element.endDate != null
            ? dateTimeFormat.format(element.endDate!)
            : null;
        row[2] = '${row[2]} - ${element.endLocation}';
        row[4] = '${row[4]} - ${element.vehicle}';
      }
    }
    sheet.appendRow(row);
  }
}
