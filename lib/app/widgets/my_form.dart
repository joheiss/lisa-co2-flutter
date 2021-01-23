import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import '../../service_locator.dart';
import '../blocs/bloc.dart';
import '../models/sensor_model.dart';

class MyForm extends StatelessWidget {
  final _firebaseService = locator<FirebaseService>();
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
      body: StreamBuilder<DocumentSnapshot>(
        stream: _firebaseService.querySensor(id),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          if (!snapshot.data.exists) return Center(child: CircularProgressIndicator());
          sensor = Sensor.fromFS(id, snapshot.data.data());
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
        _firebaseService.updateSensor(sensor);
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
