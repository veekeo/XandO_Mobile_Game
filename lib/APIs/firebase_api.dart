import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:xando/Providers/Database/db_provider.dart';

class FirebaseApi {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> requestNotificationPermission() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');
  }

  void initializeFirebaseMessaging() async {
    // Get the FCM token
    String? token = await _firebaseMessaging.getToken();
    DatabaseProvider().saveUserDeviceToken(token);
    saveDeviceTokenAsExternalId(token!);
    print('FCM Token: $token');

    // Handle incoming messages when the app is in the foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Foreground Message: ${message.notification?.body}');
      // Handle the message here
    });
  }

  Future<void> initNotif() async {
    await OneSignal.Debug.setLogLevel(OSLogLevel.verbose);

    OneSignal.initialize("3e491355-9e26-457b-a665-0583d99eca77");

    OneSignal.Notifications.requestPermission(true);
  }

  Future<void> saveDeviceTokenAsExternalId(String externalId) async {
    await OneSignal.login(externalId);
    print('this is onesignal $externalId');
  }
}
