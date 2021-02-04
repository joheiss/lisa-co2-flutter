import 'package:flutter/material.dart';
import 'package:jo_tb_fl_chart/jo_tb_fl_chart.dart';
import '../models/diagram_control_model.dart';
import '../models/sensor_model.dart';
import 'my_theme.dart';

class MyPackagedChart extends StatelessWidget {
  final DiagramControl control;
  final Sensor sensor;

  MyPackagedChart({this.control, this.sensor});


  @override
  Widget build(BuildContext context) {
    return JOTimeBasedSwipingLineChart(
      controller: control.controller,
      swapAnimationDuration: const Duration(milliseconds: 250),
      lineColors: MyTheme.diagramLineColors,
      belowChartColors: MyTheme.diagramGradientColors.map((color) => color.withOpacity(0.3)).toList(),
      backgroundColor: Theme.of(context).canvasColor,
      axisColor: MyTheme.axisColor,
      xAxisTextStyle: TextStyle(color: MyTheme.diagramLabelColor, fontWeight: FontWeight.bold, fontSize: 9.0),
      yAxisTextStyle: TextStyle(color: MyTheme.diagramLabelColor, fontWeight: FontWeight.bold, fontSize: 12.0),
      yAxisLabelStepSize: control.type == 'CO2' ? 500.0 : control.type == 'Temperatur' ? 5.0 : 10.0,
      showLegend: true, // should display a legend (interval from / to within the diagram
      legendTextStyle: TextStyle(color: Theme.of(context).scaffoldBackgroundColor, fontSize: 11, fontWeight: FontWeight.bold),
    );
  }
}
