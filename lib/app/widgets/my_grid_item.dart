import 'package:flutter/material.dart';
import 'package:try_grid/app/widgets/my_scatter_chart.dart';
import '../models/sensor_model.dart';
import '../blocs/bloc.dart';
import 'my_theme.dart';

class MyGridItem extends StatelessWidget {
  final String id;

  MyGridItem({this.id});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: bloc.sensors,
      builder: (BuildContext context, AsyncSnapshot<Map<String, Future<Sensor>>> snapshot) {
        if (!snapshot.hasData) return Text('... Loading $id ...');
        return FutureBuilder(
          future: snapshot.data[id],
          builder: (BuildContext context, AsyncSnapshot<Sensor> sensorSnapshot) {
            if (!sensorSnapshot.hasData) return Text('... Sensor $id is loading ...');
            return _buildContainer(context, sensorSnapshot.data);
          },
        );
      },
    );
  }

  Widget _buildContainer(BuildContext context, Sensor sensor) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/detail/${sensor.id}'),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Theme.of(context).canvasColor,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(25.0),
            ),
          ),
          _buildScatter(context, sensor),
          Container(
            margin: EdgeInsets.only(top: 100.0, right: 80.0),
            padding: EdgeInsets.all(5.0),
            width: 100.0,
            height: 40.0,
            decoration: BoxDecoration(
              color: MyTheme.smallTextBoxColor,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: 
                Row(
                  children: [
                    Sensor.mapStatusIcon(sensor),
                    Column(
                      children: [
                        Text(
                          '${sensor.name}',
                          style: TextStyle(color: Colors.white, fontSize: 11.0, fontWeight: FontWeight.bold),
                        ),
                          Text(
                          '${sensor.description}',
                          style: TextStyle(color: Colors.white, fontSize: 10.0, fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                  ],
                ),
          ),
        ],
      ),
    );
  }

  _buildScatter(BuildContext context, Sensor sensor) {
    if (sensor.measurements.length > 0) {
      return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(5.0),
        child: MyScatterChart(
          id: sensor.id,
          value: sensor.measurements.length > 0 ? sensor.measurements[0].co2 : 0,
        ),
      );
    } else {
      return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(5.0),
        child: Text(
          'Es liegen noch keine Messungen vor!',
          textAlign: TextAlign.center,
          softWrap: true,
          style: TextStyle(
            fontSize: 16.0,
            color: MyTheme.toggleButtonBorderColor,
          ),
        ),
      );
    }
  }
}
