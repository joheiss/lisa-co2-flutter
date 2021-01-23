import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class PushNotificationService {

  PushNotificationService._();

  factory PushNotificationService() => _instance;

  static final PushNotificationService _instance = PushNotificationService._();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  bool _initialized = false;

  Future<void> init() async {
    print('(TRACE) init PushNotificationService');
    if (!_initialized) {
      // For iOS request permission first.
      _firebaseMessaging.requestNotificationPermissions();
      _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
          print('(TRACE) onMessage: $message');
        },
        onLaunch: (Map<String, dynamic> message) async {
          print('(TRACE) onLaunch: $message');
        },
        onResume: (Map<String, dynamic> message) async {
          print('(TRACE) onResume: $message');
        },

      );

      // For testing purposes print the Firebase Messaging token
      String token = await _firebaseMessaging.getToken();
      print('(TRACE) FirebaseMessaging token: $token');

      _initialized = true;
    }
  }
}