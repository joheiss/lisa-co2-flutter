import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationHandler extends StatefulWidget {
  @override
  _NotificationHandlerState createState() => _NotificationHandlerState();
}

class _NotificationHandlerState extends State<NotificationHandler> {
  final _store = FirebaseFirestore.instance;
  final _fcm = FirebaseMessaging();

  @override
  void initState() {
    super.initState();
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('(TRACE) onMessage: $message');
        final snackbar = SnackBar(
          content: Text(message['notification']['title']),
          action: SnackBarAction(
            label: 'OK',
            onPressed: () => null,
          )
        );
        Scaffold.of(context).showSnackBar(snackbar);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('(TRACE) onLaunch: $message');
      },
      onResume: (Map<String, dynamic> message) async {
        print('(TRACE) onResume: $message');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
