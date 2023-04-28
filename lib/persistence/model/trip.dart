import 'package:json_annotation/json_annotation.dart';

part 'trip.g.dart';

@JsonSerializable()
class Trip {
  int? id;
  @JsonKey(fromJson: millisecondsToDateTime, toJson: datetimeToMilliseconds)
  DateTime? startDate;
  @JsonKey(fromJson: millisecondsToDateTime, toJson: datetimeToMilliseconds)
  DateTime? endDate;
  String? type;
  String? startLocation;
  String? endLocation;
  String? reason;
  String? vehicle;
  int? startMileage;
  int? endMileage;
  int? parent;

  Trip({
    this.id,
    this.startDate,
    this.endDate,
    this.type,
    this.startLocation,
    this.endLocation,
    this.reason,
    this.vehicle,
    this.startMileage,
    this.endMileage,
    this.parent,
  });

  Map<String, dynamic> toJson() => _$TripToJson(this);

  factory Trip.fromJson(Map<String, dynamic> json) => _$TripFromJson(json);

  static DateTime? millisecondsToDateTime(int? milliseconds) =>
      milliseconds == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(milliseconds);

  static int? datetimeToMilliseconds(DateTime? dateTime) =>
      dateTime?.millisecondsSinceEpoch;
}
