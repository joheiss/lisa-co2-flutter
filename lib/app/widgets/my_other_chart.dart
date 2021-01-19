import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import '../models/diagram_control_model.dart';

class MyOtherChart extends StatelessWidget {
  final DiagramControl control;

  MyOtherChart({this.control});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 2,
        child: _buildLineChart(control));
  }

  Widget _buildLineChart(DiagramControl control) {
    control.datapoints.forEach((d) => print('${d.time} -> ${d.value}'));
    final seriesList = [
      charts.Series<DataPoint, String>(
        id: DiagramControl.mapChartLegend(control.interval),
        colorFn: (_, __) => charts.MaterialPalette.purple.shadeDefault,
        domainFn: (DataPoint point, _) => DiagramControl.mapTimeToLabel(control, point.time.toDouble()),
        measureFn: (DataPoint point, _) => point.value,
        measureUpperBoundFn: (_, __) => control.upperBound,
        measureLowerBoundFn: (_, __) => control.lowerBound,
        measureOffsetFn: (_, __) => control.offset,
        data: control.datapoints,
      ),
    ];
    return charts.LineChart(
      seriesList,
      animate: false,
      behaviors: [charts.SeriesLegend()],
    );
  }
}
