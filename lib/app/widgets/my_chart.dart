import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../models/diagram_control_model.dart';
import 'my_theme.dart';

class MyChart extends StatelessWidget {
  final DiagramControl control;

  MyChart({this.control});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 2,
        child: _buildChartContainer(context, control));
  }

  _buildChartContainer(BuildContext context, DiagramControl control) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 15.0, left: 5.0),
                child: LineChart(
                  _buildLineChart(context, control),
                  swapAnimationDuration: const Duration(milliseconds: 250),
                ),
                ),
              ),
          ],
        ),
        Container(
          margin: EdgeInsets.only(top: 20.0),
          alignment: Alignment.topCenter,
          child: Text(
            DiagramControl.mapChartLegend(control.interval),
            style: TextStyle(color: Theme.of(context).scaffoldBackgroundColor, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 2),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  LineChartData _buildLineChart(BuildContext context, DiagramControl control) {
    List<Color> gradientColors = MyTheme.diagramGradientColors;

    return LineChartData(
      backgroundColor: Theme.of(context).canvasColor,
      clipData: FlClipData.all(),
      gridData: FlGridData(
        show: false, // true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: MyTheme.axisColor,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: MyTheme.axisColor,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 32,
          interval: DiagramControl.getEfficientInterval(control),
          checkToShowTitle: DiagramControl.checkToShowTitle,
          getTextStyles: (value) => TextStyle(color: MyTheme.diagramLabelColor, fontWeight: FontWeight.bold, fontSize: 9.0),
          getTitles: (value) => DiagramControl.mapTimeToLabel(control, value),
          margin: 8.0,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          reservedSize: 32,
          getTextStyles: (value) => TextStyle(color: MyTheme.diagramLabelColor, fontWeight: FontWeight.bold, fontSize: 12.0),
          getTitles: (value) => _mapYAxisLabels(control, value),
          margin: 8.0,
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: Color(0xff37434d)),
      ),
      minX: control.interval.from.toDouble() ?? 0.0,
      maxX: control.interval.to.toDouble() ?? 0.0,
      minY: control.lowerBound,
      maxY: control.upperBound,
      lineBarsData: [
        LineChartBarData(
          spots: _mapDataPointsToSpots(control.datapoints),
          isCurved: true,
          colors: MyTheme.diagramLineColors,
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors: gradientColors.map((color) => color.withOpacity(0.3)).toList(),
          ),
        ),
      ],
    );
  }

  String _mapYAxisLabels(DiagramControl control, double value) {
    if (control.type == 'CO2') {
      if (value % 500 == 0) return value.toInt().toString();
      return '';
    }
    if (control.type == 'Temperatur') {
      if (value % 5 == 0) return value.toInt().toString();
      return '';
    }
    if (control.type == 'Feuchtigkeit') {
      if (value % 10 == 0) return value.toInt().toString();
      return '';
    }
    return '';
  }

  List<FlSpot> _mapDataPointsToSpots(List<DataPoint> datapoints) {
    return datapoints.map((d) => FlSpot(d.time.toDouble(), d.value.toDouble())).toList();
  }
}
