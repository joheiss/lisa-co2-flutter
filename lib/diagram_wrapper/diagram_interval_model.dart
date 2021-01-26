class JODiagramTimeInterval {
  int from;
  int to;
  int size;

  JODiagramTimeInterval({this.from, this.to, this.size});

  static const minute = 60 * 1000;
  static const hour = 60 * minute;
  static const day = 24 * hour;
  static const six_hours = 6 * hour;
  static const twelve_hours = 12 * hour;
  static const week = 7 * day;

  static int daysOfMonth(int month, [int year]) {
    if (year == null) year = DateTime.now().year;
    month = month + 1;
    return new DateTime(year, month, 0).day;
  }

  static JODiagramTimeInterval next(JODiagramTimeInterval interval) {
    if (interval.size <= week) {
      interval.from = interval.from + interval.size;
      interval.to = interval.to + interval.size;
    } else {
      DateTime date = DateTime.fromMillisecondsSinceEpoch(interval.from);
      interval.from = DateTime(date.year, date.month + 1, 1).millisecondsSinceEpoch;
      interval.to = DateTime(date.year, date.month + 1, 0).millisecondsSinceEpoch;
    }
    return interval;
  }

  static JODiagramTimeInterval previous(JODiagramTimeInterval interval) {
    if (interval.size <= week) {
      interval.from = interval.from - interval.size;
      interval.to = interval.to - interval.size;
    } else {
      DateTime date = DateTime.fromMillisecondsSinceEpoch(interval.from);
      interval.from = DateTime(date.year, date.month - 1, 1).millisecondsSinceEpoch;
      interval.to = DateTime(date.year, date.month - 1, 0).millisecondsSinceEpoch;
    }
    return interval;
  }

  static int justifyToMinutes(int time, int minutes) {
    final date = DateTime.fromMillisecondsSinceEpoch(time);
    final minute = date.minute;
    int newMinute = 0;
    for (var i = 0; i <= 60; i += minutes) {
      if (i > minute) break;
      newMinute += minutes;
    }
    return DateTime(date.year, date.month, date.day, date.hour, newMinute - 1, 59, 999).millisecondsSinceEpoch;
  }
}
