class LogEntry {
  int? id;
  DateTime startDate;
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

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "id": id,
      "start_date": startDate.millisecondsSinceEpoch,
      "end_date": endDate?.millisecondsSinceEpoch,
      "start_location": startLocation,
      "end_location": endLocation,
      "reason": reason,
      "vehicle": vehicle,
      "start_mileage": startMileage,
      "end_mileage": endMileage,
      "parent": parent,
    };
  }

  factory LogEntry.fromMap(Map<String, dynamic> map) {
    return LogEntry(
      id: map['id'],
      startDate: DateTime.fromMicrosecondsSinceEpoch(map['start_date']),
      endDate: DateTime.fromMicrosecondsSinceEpoch(map['end_date']),
      startLocation: map['start_location'],
      endLocation: map['end_location'],
      reason: map['reason'],
      vehicle: map['vehicle'],
      startMileage: map['start_mileage'],
      endMileage: map['end_mileage'],
      parent: map['parent'],
    );
  }
}
