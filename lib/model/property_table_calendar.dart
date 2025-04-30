class PropertyTableCalendar {
  final String? id;
  final String? start;
  final String? end;
  final PropertyTableCalendarStartParts? startParts;
  final PropertyTableCalendarEndParts? endParts;

  PropertyTableCalendar({
    this.id,
    this.start,
    this.end,
    this.startParts,
    this.endParts,
    required int year,
  });

  PropertyTableCalendar.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String?,
        start = json['start'] as String?,
        end = json['end'] as String?,
        startParts = (json['start_parts'] as Map<String, dynamic>?) != null
            ? PropertyTableCalendarStartParts.fromJson(
                json['start_parts'] as Map<String, dynamic>)
            : null,
        endParts = (json['end_parts'] as Map<String, dynamic>?) != null
            ? PropertyTableCalendarEndParts.fromJson(
                json['end_parts'] as Map<String, dynamic>)
            : null;

  Map<String, dynamic> toJson() => {
        'id': id,
        'start': start,
        'end': end,
        'start_parts': startParts?.toJson(),
        'end_parts': endParts?.toJson()
      };
}

class PropertyTableCalendarStartParts {
  final int? year;
  final int? month;
  final int? day;

  PropertyTableCalendarStartParts({
    this.year,
    this.month,
    this.day,
  });

  PropertyTableCalendarStartParts.fromJson(Map<String, dynamic> json)
      : year = json['year'] as int?,
        month = json['month'] as int?,
        day = json['day'] as int?;

  Map<String, dynamic> toJson() => {'year': year, 'month': month, 'day': day};
}

class PropertyTableCalendarEndParts {
  final int? year;
  final int? month;
  final int? day;

  PropertyTableCalendarEndParts({
    this.year,
    this.month,
    this.day,
  });

  PropertyTableCalendarEndParts.fromJson(Map<String, dynamic> json)
      : year = json['year'] as int?,
        month = json['month'] as int?,
        day = json['day'] as int?;

  Map<String, dynamic> toJson() => {'year': year, 'month': month, 'day': day};
}
