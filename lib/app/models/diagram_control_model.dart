import 'package:intl/intl.dart';

class DiagramTimeInterval {
  int from;
  int to;
  int size;

  DiagramTimeInterval({this.from, this.to, this.size});

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

  static DiagramTimeInterval next(DiagramTimeInterval interval) {
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

  static DiagramTimeInterval previous(DiagramTimeInterval interval) {
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

class DataPoint {
  final int time;
  int value;

  DataPoint(this.time, this.value);

  static List<DataPoint> buildFixedDataPoints(DiagramTimeInterval interval) {
    final step = DataPoint.getStepSize(interval.size);
    List<DataPoint> datapoints = <DataPoint>[];
    for (var t = interval.from; t < interval.to + step; t += step) {
      datapoints.insert(0, DataPoint(t, 0));
    }
    return datapoints;
  }

  static int getStepSize(int size) {
    int step = 1440;
    if (size == DiagramTimeInterval.hour) step = 5;
    if (size == DiagramTimeInterval.six_hours) step = 30;
    if (size == DiagramTimeInterval.twelve_hours) step = 30;
    if (size == DiagramTimeInterval.day) step = 60;
    if (size == DiagramTimeInterval.week) step = 1440;
    return step * 60 * 1000;
  }
}

class DiagramControl {
  final String type;
  final String unit;
  bool isExpanded;
  DiagramTimeInterval interval;
  List<DataPoint> datapoints;
  List<String> labels;
  final double lowerBound;
  final double upperBound;
  final double offset;

  DiagramControl(
      {this.type,
      this.unit,
      this.isExpanded,
      this.interval,
      this.datapoints,
      this.labels,
      this.lowerBound,
      this.upperBound,
      this.offset});

  static bool checkToShowTitle(minValue, maxValue, sideTitles, appliedInterval, value) {
    if ((maxValue + 1 - minValue) % appliedInterval == 0) {
      return true;
    }
    return value != maxValue;
  }

  static double getEfficientInterval(DiagramControl control) {
    return DataPoint.getStepSize(control.interval.size).toDouble() * 2;
  }

  static String mapChartLegend(DiagramTimeInterval interval) {
    var legend = '';
    final startDate = DateTime.fromMillisecondsSinceEpoch(interval.from);
    final endDate = DateTime.fromMillisecondsSinceEpoch(interval.to);
    final formattedStartDate = DateFormat('dd.MM.yyyy kk:mm').format(startDate).replaceFirst('24:00', '00:00');
    final formattedEndDate = DateFormat('dd.MM.yyyy kk:mm').format(endDate);

    if (startDate.day == endDate.day && startDate.month == endDate.month && startDate.year == endDate.year) {
      legend = formattedStartDate + ' bis ' + formattedEndDate.substring(11);
    } else {
      legend = formattedStartDate + ' bis ' + formattedEndDate;
    }
    return legend;
  }

  static String mapTimeToLabel(DiagramControl control, double value) {
    final step = DataPoint.getStepSize(control.interval.size);
    final time = value.toInt();
    return DiagramControl.mapTimeToPointLabel(time, step);
  }

  static String mapTimeToPointLabel(int t, int step) {
    final date = DateTime.fromMillisecondsSinceEpoch(t);
    final formatted = DateFormat('dd.MM.yyyy kk:mm').format(date).replaceFirst('24:00', '00:00');
    if (step < DiagramTimeInterval.hour) return formatted.substring(11);
    if (step >= DiagramTimeInterval.hour && step < DiagramTimeInterval.day) return formatted.substring(11);
    if (step >= DiagramTimeInterval.day) return formatted.substring(0, 2);
    return '';
  }
}

class DiagramOptions {
  final String sensorId;
  int activeToggle;
  final List<DiagramControl> diagrams;

  DiagramOptions({this.sensorId, this.activeToggle, this.diagrams});

  static DiagramOptions resizeInterval(DiagramOptions options, int selectedIndex) {
    final now = DateTime.now();
    options.activeToggle = selectedIndex;
    List<int> sizes = [
      DiagramTimeInterval.hour,
      DiagramTimeInterval.six_hours,
      DiagramTimeInterval.twelve_hours,
      DiagramTimeInterval.day,
      DiagramTimeInterval.week,
      DiagramTimeInterval.day * 30,
    ];

    options.diagrams.forEach((d) {
      d.interval.size = sizes[selectedIndex];
      if (d.interval.size == DiagramTimeInterval.hour) {
        d.interval.to = DiagramTimeInterval.justifyToMinutes(DateTime.now().millisecondsSinceEpoch, 5);
        d.interval.from = d.interval.to - d.interval.size + 1;
      }
      if (d.interval.size == DiagramTimeInterval.six_hours) {
        d.interval.to = DiagramTimeInterval.justifyToMinutes(DateTime.now().millisecondsSinceEpoch, 15);
        d.interval.from = d.interval.to - d.interval.size + 1;
      }
      if (d.interval.size == DiagramTimeInterval.twelve_hours) {
        d.interval.to = DiagramTimeInterval.justifyToMinutes(DateTime.now().millisecondsSinceEpoch, 30);
        d.interval.from = d.interval.to - d.interval.size + 1;
      }
      if (d.interval.size == DiagramTimeInterval.day) {
        d.interval.to = DateTime(now.year, now.month, now.day, 23, 59, 59, 999).millisecondsSinceEpoch;
        d.interval.from = DateTime(now.year, now.month, now.day, 0, 0, 0, 0).millisecondsSinceEpoch;
      }
      if (d.interval.size == DiagramTimeInterval.week) {
        var date = DateTime.fromMillisecondsSinceEpoch(
            now.millisecondsSinceEpoch + (7 - now.weekday) * DiagramTimeInterval.day);
        d.interval.to = DateTime(date.year, date.month, date.day, 23, 59, 59, 999).millisecondsSinceEpoch;
        d.interval.from = DateTime(date.year, date.month, date.day - 6, 0, 0, 0, 0).millisecondsSinceEpoch;
      }
      if (d.interval.size > DiagramTimeInterval.week) {
        d.interval.to = DateTime(now.year, now.month + 1, 0, 23, 59, 59, 999).millisecondsSinceEpoch;
        d.interval.from = DateTime(now.year, now.month, 1, 0, 0, 0, 0).millisecondsSinceEpoch;
      }
    });
    return options;
  }

}
