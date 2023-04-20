import 'package:json_annotation/json_annotation.dart';

part 'trip.g.dart';

@JsonSerializable()
class Trip {
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

  Trip({
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

  Map<String, dynamic> toJson() => _$TripToJson(this);

  factory Trip.fromJson(Map<String, dynamic> json) =>
      _$TripFromJson(json);

  static DateTime? _millisecondsToDateTime(int? milliseconds) =>
      milliseconds == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(milliseconds);

  static int? _datetimeToMilliseconds(DateTime? dateTime) =>
      dateTime?.millisecondsSinceEpoch;
}
