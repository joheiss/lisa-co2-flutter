import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:swipe_gesture_recognizer/swipe_gesture_recognizer.dart';
import 'diagram_controller.dart';
import 'diagram_datapoint_model.dart';

class JOTimeBasedSwipingLineChart extends StatefulWidget {
  final List<JODataPoint> datapoints;
  final double lowerBound;
  final double upperBound;
  final int size;
  final Duration swapAnimationDuration;
  final List<Color> lineColors;
  final List<Color> belowChartColors;
  final Color backgroundColor;
  final Color axisColor;
  final TextStyle xAxisTextStyle;
  final TextStyle yAxisTextStyle;
  final double yAxisLabelStepSize;
  final bool showLegend;
  final TextStyle legendTextStyle;

  JOTimeBasedSwipingLineChart(
      {@required this.datapoints, @required this.lowerBound, @required this.upperBound, @required this.size, this.swapAnimationDuration,
        this.lineColors, this.belowChartColors, this.backgroundColor, this.axisColor, this.xAxisTextStyle, this.yAxisTextStyle,
        this.yAxisLabelStepSize, this.showLegend, this.legendTextStyle}) : super();

  @override
  _JOTimeBasedSwipingLineChartState createState() =>
      _JOTimeBasedSwipingLineChartState(
          datapoints, lowerBound, upperBound, size, swapAnimationDuration, lineColors, belowChartColors, backgroundColor, axisColor,
            xAxisTextStyle, yAxisTextStyle, yAxisLabelStepSize, showLegend, legendTextStyle
      );
}

class _JOTimeBasedSwipingLineChartState extends State<JOTimeBasedSwipingLineChart> {
  final List<JODataPoint> datapoints;
  final double lowerBound;
  final double upperBound;
  final int size;
  final Duration swapAnimationDuration;
  final List<Color> lineColors;
  final List<Color> belowChartColors;
  final Color backgroundColor;
  final Color axisColor;
  final TextStyle xAxisTextStyle;
  final TextStyle yAxisTextStyle;
  final double yAxisLabelStepSize;
  final bool showLegend;
  final TextStyle legendTextStyle;

  JODiagramController _controller;

  _JOTimeBasedSwipingLineChartState(this.datapoints, this.lowerBound, this.upperBound, this.size,
      this.swapAnimationDuration,
      this.lineColors, this.belowChartColors, this.backgroundColor, this.axisColor, this.xAxisTextStyle,
      this.yAxisTextStyle,
      this.yAxisLabelStepSize, this.showLegend, this.legendTextStyle) {
    _controller = JODiagramController(datapoints, lowerBound, upperBound, size);
  }

  @override
  Widget build(BuildContext context) {
    return SwipeGestureRecognizer(
      onSwipeLeft: () {
        setState(() {
          _controller.scrollDiagram('forward');
        });
      },
      onSwipeRight: (){
        setState(() {
          _controller.scrollDiagram('back');
        });
      },
      child: Column(
        children: <Widget>[
          Container(
            width: MediaQuery
                .of(context)
                .size
                .width,
            height: MediaQuery
                .of(context)
                .size
                .height / 2,
            child: _buildChartContainer(context),
          ),
        ],
      ),
    );
  }

  Widget _buildChartContainer(BuildContext context) {
    List<Widget> children = <Widget>[];
    children.add(Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 15.0, left: 5.0),
              child: LineChart(
                _buildLineChart(context),
                swapAnimationDuration: swapAnimationDuration,
              ),
            ),
          ),
        ],
      ),
    );
    if (showLegend) {
      children.add(
        Container(
          margin: EdgeInsets.only(top: 20.0),
          alignment: Alignment.topCenter,
          child: Text(
            JODiagramController.mapChartLegend(_controller.interval),
            style: legendTextStyle,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    return Stack(
      children: children,
    );
  }

  LineChartData _buildLineChart(BuildContext context) {
    return LineChartData(
      backgroundColor: backgroundColor,
      clipData: FlClipData.all(),
      gridData: FlGridData(
        show: false, // true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: axisColor,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: axisColor,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 32,
          interval: JODiagramController.getEfficientInterval(_controller),
          checkToShowTitle: JODiagramController.checkToShowTitle,
          getTextStyles: (value) => xAxisTextStyle,
          getTitles: (value) => JODiagramController.mapTimeToLabel(_controller, value),
          margin: 8.0,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          reservedSize: 32,
          getTextStyles: (value) => yAxisTextStyle,
          getTitles: (value) => _mapYAxisLabels(value),
          margin: 8.0,
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: Color(0xff37434d)),
      ),
      minX: _controller.interval.from.toDouble() ?? 0.0,
      maxX: _controller.interval.to.toDouble() ?? 0.0,
      minY: _controller.lowerBound,
      maxY: _controller.upperBound,
      lineBarsData: [
        LineChartBarData(
          spots: _mapDataPointsToSpots(),
          isCurved: true,
          colors: lineColors,
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors: belowChartColors.map((color) => color.withOpacity(0.3)).toList(),
          ),
        ),
      ],
    );
  }

  List<FlSpot> _mapDataPointsToSpots() {
    return _controller.datapoints.map((d) => FlSpot(d.time.toDouble(), d.value.toDouble())).toList();
  }

  String _mapYAxisLabels(double value) {
    if (value % yAxisLabelStepSize == 0) return value.toInt().toString();
    return '';
  }
}