import 'package:excel/excel.dart';
import 'package:fahrtenbuch/persistence/model/trip.dart';
import 'package:fahrtenbuch/service/trip_service.dart';
import 'package:intl/intl.dart';

class ReportService {
  static final DateFormat dateTimeFormat = DateFormat('dd.MM.yyyy HH:mm');

  static final ReportService instance = ReportService._privateConstructor();

  TripService tripService = TripService.instance;

  ReportService._privateConstructor();

  Future<Excel> generateExcel(int? year, String? type) async {
    Excel excel = Excel.createExcel();

    String? where;
    List<Trip> trips;
    if (year != null) {
      int yearStartMilliseconds = DateTime(year = year).millisecondsSinceEpoch;
      int yearEndMilliseconds =
          DateTime(year = year + 1).millisecondsSinceEpoch;
      where =
          '${where == null ? '' : '$where AND'} startDate > $yearStartMilliseconds AND startDate < $yearEndMilliseconds';
    }

    if (type != null) {
      where = '${where == null ? '' : '$where AND'} type = "$type"';
    }

    trips = await tripService.getAll(where: where, orderBy: 'startDate ASC');

    await _generateProtokollSheet(excel, trips);
    await _generateReiseSheet(excel, trips);

    excel.delete('Sheet1');
    return excel;
  }

  Future<void> _generateProtokollSheet(Excel excel, List<Trip> trips) async {
    Sheet sheet = excel['Protokoll'];

    CellStyle cellStyle = CellStyle(
      bold: true,
      textWrapping: TextWrapping.WrapText,
    );
    List<CellValue?> header = [
      TextCellValue('Abfahrt'),
      TextCellValue('Ankunft'),
      TextCellValue('Abfahrtsort'),
      TextCellValue('Ankunftsort'),
      TextCellValue('Zweck'),
      TextCellValue('Fahrzeug'),
      TextCellValue('KM-Abfahrt'),
      TextCellValue('KM-Ankunft'),
      TextCellValue('gefahren (km)'),
      TextCellValue('Art'),
    ];
    sheet.appendRow(header);
    sheet.row(0).forEach((element) {
      element!.cellStyle = cellStyle;
    });

    int rowIndex = 2;
    for (var element in trips) {
      List<CellValue?> row = [
        element.startDate != null
            ? DateCellValue.fromDateTime(element.startDate!)
            : null,
        element.endDate != null
            ? DateCellValue.fromDateTime(element.endDate!)
            : null,
        TextCellValue(element.startLocation!),
        TextCellValue(element.endLocation!),
        TextCellValue(element.reason!),
        TextCellValue(element.vehicle!),
        IntCellValue(element.startMileage!),
        IntCellValue(element.endMileage ?? element.startMileage!),
        FormulaCellValue("H$rowIndex-G$rowIndex"),
        TextCellValue(element.type!),
      ];
      sheet.appendRow(row);
      rowIndex++;
    }
  }

  Future<void> _generateReiseSheet(Excel excel, List<Trip> trips) async {
    Sheet sheet = excel['Reise'];

    CellStyle cellStyle = CellStyle(
      bold: true,
      textWrapping: TextWrapping.WrapText,
    );
    List<CellValue?> header = [
      TextCellValue('Abfahrt'),
      TextCellValue('Ankunft'),
      TextCellValue('Reiseweg'),
      TextCellValue('Zweck'),
      TextCellValue('Fahrzeuge'),
      TextCellValue('Art')
    ];
    sheet.appendRow(header);
    sheet.row(0).forEach((element) {
      element!.cellStyle = cellStyle;
    });

    List<CellValue?> row = [];
    for (var element in trips) {
      if (element.parent == null) {
        if (row.isNotEmpty) {
          sheet.appendRow(row);
        }
        row = [
          element.startDate != null
              ? DateCellValue.fromDateTime(element.startDate!)
              : null,
          element.endDate != null
              ? DateCellValue.fromDateTime(element.endDate!)
              : null,
          TextCellValue('${element.startLocation} - ${element.endLocation}'),
          TextCellValue(element.reason!),
          TextCellValue(element.vehicle!),
          TextCellValue(element.type!)
        ];
      } else {
        row[1] = element.endDate != null
            ? DateCellValue.fromDateTime(element.endDate!)
            : null;
        row[2] = TextCellValue('${row[2]} - ${element.endLocation}');
        row[4] = TextCellValue('${row[4]} - ${element.vehicle}');
      }
    }
    sheet.appendRow(row);
  }
}
