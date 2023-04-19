import 'package:json_annotation/json_annotation.dart';

part 'log_entry.g.dart';

@JsonSerializable()
class LogEntry {
  int? id;
  @JsonKey(fromJson: _millisecondsToDateTime, toJson: _datetimeToMilliseconds)
  DateTime? startDate;
  @JsonKey(fromJson: _millisecondsToDateTime, toJson: _datetimeToMilliseconds)
  DateTime? endDate;
  String startLocation;
  String? endLocation;
  String reason;
  String vehicle;
  int? startMileage;
  int? endMileage;
  int? parent;

  LogEntry({
    this.id,
    required this.startDate,
    this.endDate,
    required this.startLocation,
    this.endLocation,
    required this.reason,
    required this.vehicle,
    this.startMileage,
    this.endMileage,
    this.parent,
  });

  Map<String, dynamic> toMap() => _$LogEntryToJson(this);

  factory LogEntry.fromJson(Map<String, dynamic> json) =>
      _$LogEntryFromJson(json);

  static DateTime? _millisecondsToDateTime(int? milliseconds) =>
      milliseconds == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(milliseconds);

  static int? _datetimeToMilliseconds(DateTime? dateTime) =>
      dateTime?.millisecondsSinceEpoch;
}
