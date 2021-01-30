import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import 'my_theme.dart';

class MyScatterChart extends StatelessWidget {
  final id;
  final value;

  static const maxX = 50.0;
  static const maxY = 50.0;
  static const radius = 8.0;
  static final color1 = MyTheme.bubbleColor1;
  static final color2 = MyTheme.bubbleColor2;
  static final color3 = MyTheme.bubbleColor2;

  MyScatterChart({this.id, this.value});

  @override
  Widget build(BuildContext context) {
    return ScatterChart(
      ScatterChartData(
        scatterSpots: randomData(value),
        minX: 0,
        maxX: maxX,
        minY: 0,
        maxY: maxY,
        borderData: FlBorderData(
          show: false,
        ),
        gridData: FlGridData(
          show: false,
        ),
        titlesData: FlTitlesData(
          show: false,
        ),
        scatterTouchData: ScatterTouchData(
          enabled: false,
        ),
      ),
      swapAnimationDuration: const Duration(milliseconds: 1000),
    );
  }

  List<ScatterSpot> randomData(int value) {
    const maxValue = 3500;
    final current = value * 100 / maxValue;
    List<int> maxBubbles;
    if (current > 80) maxBubbles = [80, 10, 10];
    if (current > 70 && current < 80) maxBubbles = [70, 15, 15];
    if (current > 60 && current < 70) maxBubbles = [60, 20, 20];
    if (current > 50 && current < 60) maxBubbles = [45, 26, 29];
    if (current > 40 && current < 50) maxBubbles = [33, 30, 37];
    if (current > 30 && current < 40) maxBubbles = [25, 35, 40];
    if (current > 20 && current < 30) maxBubbles = [12, 38, 50];
    if (current > 10 && current < 20) maxBubbles = [7, 40, 53];
    if (current < 10) maxBubbles = [2, 42, 56];

    final lighterBubbles = (maxBubbles[2] * current / 100).toDouble().ceil();
    final lightBubbles = (maxBubbles[1] * current / 100).toDouble().floor();
    final darkBubbles = (maxBubbles[0] * current / 100).toDouble().floor();

    return List.generate(lighterBubbles + lightBubbles + darkBubbles, (i) {
      Color color;
      if (i < darkBubbles) {
        color = color1;
      } else if (i < darkBubbles + lightBubbles) {
        color = color2;
      } else {
        color = color3;
      }

      return ScatterSpot(
        (Random().nextDouble() * (maxX - 8)) + 4,
        (Random().nextDouble() * (maxY - 8)) + 4,
        color: color,
        radius: (Random().nextDouble() * 16) + 4,
      );
    });
  }
}
