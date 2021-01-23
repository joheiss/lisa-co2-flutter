import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:swipe_gesture_recognizer/swipe_gesture_recognizer.dart';
import '../services/firebase_service.dart';
import '../../service_locator.dart';
import '../blocs/bloc.dart';
import '../models/sensor_model.dart';
import '../models/diagram_control_model.dart';
import 'my_chart.dart';
import 'my_theme.dart';

class MyDetail extends StatelessWidget {
  final _firebaseService = locator<FirebaseService>();
  final String id;
  Sensor sensor;
  DiagramOptions options;

  MyDetail({this.id});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: _firebaseService.querySensor(id),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
        sensor = Sensor.fromFS(id, snapshot.data.data());
        bloc.getInitialOptions(id, sensor);
        return Scaffold(
          appBar: AppBar(
            title: _buildTitle(sensor),
          ),
          body: _buildList(context),
        );
      },
    );
  }

  Widget _buildTitle(Sensor sensor) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(sensor.name ?? sensor.id, style: TextStyle(fontSize: 20.0)),
          Text(sensor.description ?? '', style: TextStyle(fontSize: 16.0)),
        ],
      ),
    );
  }

  Widget _buildList(BuildContext context) {
    return _buildContainer(context);
  }

  Widget _buildContainer(BuildContext context) {
    return StreamBuilder(
      stream: bloc.options,
      builder: (BuildContext context, AsyncSnapshot<DiagramOptions> snapshot) {
        if (!snapshot.hasData) return Text('... loading diagram options ...');
        options = snapshot.data;
        return ListView(
          children: [
            Padding(padding: EdgeInsets.only(top: 15.0)),
            _buildToggleButton(context),
            ..._buildDiagramPanels(context),
          ],
        );
      },
    );
  }

  Widget _buildToggleButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 10.0, right: 10.0),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return ToggleButtons(
            onPressed: (int index) => bloc.resizeDiagram(sensor, options, index),
            children: [
              _buildSingleToggle(constraints, 6.1, '1 Stunde'),
              _buildSingleToggle(constraints, 6.1, '6 Stunden'),
              _buildSingleToggle(constraints, 6.1, '12 Stunden'),
              _buildSingleToggle(constraints, 6.1, 'Tag'),
              _buildSingleToggle(constraints, 6.1, 'Woche'),
              _buildSingleToggle(constraints, 6.2, 'Monat'),
            ],
            // constraints: BoxConstraints.expand(width: constraints.maxWidth / 6),
            borderColor: MyTheme.toggleButtonBorderColor,
            selectedBorderColor: MyTheme.smallButtonColor,
            highlightColor: MyTheme.highlightColor,
            borderRadius: BorderRadius.circular(10.0),
            isSelected: _setToggle(options.activeToggle),
          );
        },
      ),
    );
  }

  Widget _buildSingleToggle(BoxConstraints constraints, double divider, String text) {
    return Container(
      alignment: Alignment.center,
      width: constraints.maxWidth / divider,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(color: MyTheme.smallButtonColor),
      ),
      padding: EdgeInsets.all(4.0),
    );
  }

  List<bool> _setToggle(int activeToggle) {
    final selected = [false, false, false, false, false, false];
    selected[activeToggle] = true;
    return selected;
  }

  List<Widget> _buildDiagramPanels(BuildContext context) {
    final children = <Widget>[];
    options.diagrams.forEach((d) {
      children.add(_buildPanel(context, d));
      children.add(Divider(color: Colors.white));
    });
    return children;
  }

  Widget _buildPanel(BuildContext context, DiagramControl control) {
    final children = <Widget>[
      _buildPanelHeaderLine(control),
    ];
    if (control.isExpanded) children.add(MyChart(control: control));
    return SwipeGestureRecognizer(
      onSwipeLeft: () => bloc.scrollDiagram(sensor, control, 'forward'),
      onSwipeRight: () => bloc.scrollDiagram(sensor, control, 'back'),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildPanelHeaderLine(DiagramControl control) {
    return GestureDetector(
      onTap: () => bloc.toggleDiagramExpansion(control),
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SizedBox(width: 8.0),
              Sensor.mapStatusIcon(sensor, control),
              Padding(padding: EdgeInsets.only(right: 10.0)),
              Text(
                control.type,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
            ],
          ),
          Text(
            _mapRecentMeasurementValue(sensor, control),
          ),
          _buildScrollAndExpandButtons(control),
        ],
      ),
    );
  }

  String _mapRecentMeasurementValue(Sensor sensor, DiagramControl control) {
    int value = 0;
    if (sensor.measurements.length == 0) return value.toString() + ' ' + control.unit;
    if (control.type == 'CO2') value = sensor.measurements[0].co2;
    if (control.type == 'Temperatur') value = sensor.measurements[0].temperature;
    if (control.type == 'Feuchtigkeit') value = sensor.measurements[0].humidity;
    return value.toString() + ' ' + control.unit;
  }

  String _mapIntervalSizeToText(int size) {
    if (size == DiagramTimeInterval.hour) return 'Stunde';
    if (size == DiagramTimeInterval.six_hours) return '6 Stunden';
    if (size == DiagramTimeInterval.twelve_hours) return '12 Stunden';
    if (size == DiagramTimeInterval.day) return 'Tag';
    if (size == DiagramTimeInterval.week) return 'Woche';
    return 'Monat';
  }

  Widget _buildScrollAndExpandButtons(DiagramControl control) {
    final children = <Widget>[];
    if (control.isExpanded) {
      children.add(
        RawMaterialButton(
          onPressed: () => bloc.scrollDiagram(sensor, control, 'back'),
          constraints: BoxConstraints(
            minHeight: 20.0,
            maxHeight: 20.0,
            minWidth: 20.0,
            maxWidth: 20.0,
          ),
          elevation: 2.0,
          fillColor: MyTheme.smallButtonColor,
          child: Center(
            child: Icon(Icons.keyboard_arrow_left, size: 16.0),
          ),
          shape: CircleBorder(),
        ),
      );
      children.add(Text(_mapIntervalSizeToText(control.interval.size)));
      children.add(
        RawMaterialButton(
          onPressed: () => bloc.scrollDiagram(sensor, control, 'forward'),
          constraints: BoxConstraints(
            minHeight: 20.0,
            maxHeight: 20.0,
            minWidth: 20.0,
            maxWidth: 20.0,
          ),
          elevation: 2.0,
          fillColor: MyTheme.smallButtonColor,
          child: Center(
            child: Icon(Icons.keyboard_arrow_right, size: 16.0),
          ),
          shape: CircleBorder(),
        ),
      );
      children.add(Padding(padding: EdgeInsets.only(right: 10.0)));
    }
    children.add(
      RawMaterialButton(
        onPressed: () => bloc.toggleDiagramExpansion(control),
        constraints: BoxConstraints(
          minHeight: 20.0,
          maxHeight: 20.0,
          minWidth: 20.0,
          maxWidth: 20.0,
        ),
        elevation: 2.0,
        fillColor: MyTheme.smallButtonColor,
        child: Center(
          child: control.isExpanded
              ? Icon(Icons.keyboard_arrow_up, size: 16.0)
              : Icon(Icons.keyboard_arrow_down, size: 16.0),
        ),
        shape: CircleBorder(),
      ),
    );
    return Row(
      children: children,
    );
  }
}
