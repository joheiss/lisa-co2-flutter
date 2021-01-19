import 'dart:developer';

import 'package:flutter/material.dart';
import '../blocs/bloc.dart';
import '../models/sensor_model.dart';

class MyForm extends StatelessWidget {
  final String id;
  Sensor sensor;
  TextEditingController _nameController;
  TextEditingController _descController;
  TextEditingController _commentController;
  MyForm({this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('Informationen zu Sensor $id'),
      ),
      body: StreamBuilder(
        stream: bloc.newSensor,
        builder: (BuildContext context, AsyncSnapshot<Sensor> snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          sensor = snapshot.data;
          _nameController = TextEditingController(text: sensor.name);
          _descController = TextEditingController(text: sensor.description);
          _commentController = TextEditingController(text: sensor.comment);
          return Container(
            margin: EdgeInsets.all(20.0),
            child: Column(
              children: [
                Text('Sensor ID: $id'),
                _buildNameInputField(context, _nameController),
                _buildDescriptionInputField(context, _descController),
                _buildCommentInputField(context, _commentController),
                Container(margin: EdgeInsets.only(top: 25.0)),
                _buildSubmitButton(context),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildNameInputField(BuildContext context, TextEditingController controller) {
    return TextField(
      decoration: InputDecoration(
        labelText: 'Name',
        hintText: 'Bitte geben Sie einen Namen ein.',
      ),
      controller: controller,
      // onEditingComplete: () {
      //   sensor.name = controller.text;
      //   print('update sensor name in form');
      //   print(sensor.name);
      //   bloc.changeSensor(sensor);
      // },
    );
  }

  Widget _buildDescriptionInputField(BuildContext context, TextEditingController controller) {
    return TextField(
      decoration: InputDecoration(
        labelText: 'Beschreibung',
        hintText: 'Bitte geben Sie eine Beschreibung ein.',
      ),
      controller: controller,
    );
  }

  Widget _buildCommentInputField(BuildContext context, TextEditingController controller) {
    return TextField(
      minLines: 3,
      maxLines: 6,
      decoration: InputDecoration(
        labelText: 'Bemerkung',
        hintText: 'Bitte geben Sie eine Beschreibung ein.',
      ),
      controller: controller,
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return RaisedButton(
      onPressed: () async {
        sensor.name = _nameController.text;
        sensor.description = _descController.text;
        sensor.comment = _commentController.text;
        inspect(sensor);
        bloc.updateSensor(sensor);
        Navigator.of(context).pop();
      },
      child: Text('Speichern'),
      color: Theme.of(context).accentColor,
    );
  }

  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _commentController.dispose();
  }
}
