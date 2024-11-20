import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fitness_project/domain/usecases/db/update_fcm_token.dart';
import 'package:fitness_project/main.dart';
import 'package:fitness_project/presentation/challenge/pages/challenge_page.dart';
import 'package:fitness_project/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final messaging = FirebaseMessaging.instance;

  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> initNotifications() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    if (Platform.isAndroid) {
      await messaging.setAutoInitEnabled(true);
      messaging.getToken().then((value) async {
        await sl<UpdateFcmToken>().call(params: value);
      });
      messaging.onTokenRefresh.listen((value) async {
        await sl<UpdateFcmToken>().call(params: value);
      });
    }

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await _notifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (response) {
        if (response.payload == null) {
          return;
        }
        final payload = jsonDecode(response.payload!);
        if (payload['type'] == 'challenge') {
          final challengeId = payload['challengeId'];
          if (challengeId == null) {
            return;
          }
          navigatorKey.currentState?.push(MaterialPageRoute(
            builder: (context) => ChallengePage(
              challengeId: challengeId,
            ),
          ));
        }
      },
    );
    await createChallengeNotificationChannel();
  }

  static showNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'com.example.fitness_project.challenge_start',
      'Challenge start',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await _notifications.show(
      0,
      message.notification!.title,
      message.notification!.body,
      platformChannelSpecifics,
      payload: jsonEncode(message.data),
    );
  }

  static Future<void> createChallengeNotificationChannel() async {
    const AndroidNotificationChannel androidNotificationChannel =
        AndroidNotificationChannel(
            'com.example.fitness_project.challenge_start', 'Challenge start',
            description: 'Channel for challenge start notifications',
            importance: Importance.max,
            playSound: true,
            enableVibration: true);
    await _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidNotificationChannel);
  }

  static Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  static void _handleMessage(RemoteMessage message) {
    if (message.data['type'] == 'challenge' &&
        message.data['challengeId'] != null) {
      final challengeId = message.data['challengeId'];
      navigatorKey.currentState?.push(MaterialPageRoute(
        builder: (context) => ChallengePage(
          challengeId: challengeId,
        ),
      ));
    }
  }
}
