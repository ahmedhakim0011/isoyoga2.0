import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'db/shared_pref.dart';
import 'model/PushNotification.dart';

final String databaseName = "danyTech.db";
final String productTableName = "products";
final String baseURL = "https://yoga.voltronsol.com/storage/";
final String stripeKey =
    "pk_test_51LjL8YL6r7kDAc36zaloInDjrp6YUvFSUVGUdBj3kiy7ACXDta3lDzMTqF7cjITp4JBNVEVHllWRHAZWYqUCZcJK008TDn1iUC";
final String clientKey =
    "sk_test_51LjL8YL6r7kDAc36bqe9vpdx8erb2XPJqTYolRaSlsIPXj8OBApUUqRpHZOWrArQJ7KskW5XSgIqwTt7x3AzeQLO00dfUCo1bX";

const stripePublishableKey =
    "pk_test_51Lz7KKBOVrnjWB5txHokBSOtwp91RTpmlVY7pCG1FWWxDgsuJSLB2k5S9r0FbAbhopvBCifUVFn96Ps3w9xDX2m000a5leiAY4";
const secretKey =
    "sk_test_51Lz7KKBOVrnjWB5t4z5Q14LABh0ZSSaIP8W2uWmaz5sAzBGoILh7U6bSmhnX4n2rMTqPoPj0ArsN1S3EwFenJPLa00NcrB1x9S";
String name = "";
String email = "";
String avatar = "";
int userId = 50;

RegExp RegexToRemoveZero = RegExp(r'([.]*0)(?!.*\d)');
late FirebaseMessaging firebaseMessaging;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

const AndroidNotificationDetails? androidPlatformChannelSpecifics =
    AndroidNotificationDetails("199199199", "yogaAppFlutter",
        channelDescription: "Dany Retail",
        importance: Importance.high,
        priority: Priority(1));

const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

register() async {
  await Firebase.initializeApp();
  init_local_notification();
  firebaseMessaging = FirebaseMessaging.instance;

  NotificationSettings settings = await firebaseMessaging.requestPermission(
    alert: true,
    badge: true,
    provisional: false,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted permission');
    // TODO: handle the received notifications
  } else {
    print('User declined or has not accepted permission');
  }
  firebaseMessaging.getToken().then((token) {
    SharedPrefs.setFirebaseToken(token!);
    print("Firebase Token " + token);
    // setFirebaseToken(token);
  });

  showNotification(String title, String message) async {
    await flutterLocalNotificationsPlugin
        .show(12345, title, message, platformChannelSpecifics, payload: 'data');
  }

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('message : ${message}');

    showNotification(
        message.notification?.title ?? "", message.notification?.body ?? "");
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    PushNotification notification = PushNotification(
      title: message.notification?.title,
      body: message.notification?.body,
    );

    showNotification(
        message.notification?.title ?? "", message.notification?.body ?? "");
  });

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
  } else {
    print('User declined or has not accepted permission');
  }
}

Future _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}

init_local_notification() async {
  final AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon');

  final DarwinInitializationSettings initializationSettingsDarwin =
      DarwinInitializationSettings();

  final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

const String APP_ID = 'a14cf60b65d5497287a63eef425cc0e3';
