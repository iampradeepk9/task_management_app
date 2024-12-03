import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async{
  print('Title: ${message.notification?.title}');
  print('Body: ${message.notification?.body}');
  print('Payload: ${message.data}');
}

class FirebaseApi {
  final _firebasemessaging = FirebaseMessaging.instance;
  Future<void> initNotification() async {
    await _firebasemessaging.requestPermission();
    final fcmToken = await _firebasemessaging.getToken();
    print("fcmToken........${fcmToken}");
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }
}