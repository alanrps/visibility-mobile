import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  // Future onSelectNotification(String payload) {
  // Navigator.of(context).push(MaterialPageRoute(builder: (_) {
  //   return NewScreen(
  //     payload: payload,
  //   );
  // }));
  // }
  //  

  initState() async {
    var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
    var initializationSettingsIOs = IOSInitializationSettings();

    var initSetttings = InitializationSettings(
      android: initializationSettingsAndroid, 
      iOS: null
    );

    await flutterLocalNotificationsPlugin.initialize(initSetttings); // onSelectNotification: onSelectNotification
  }

  showNotification(int id, String title, String body, String payload, bool priority) async {
    var android = AndroidNotificationDetails(
        'id', 
        'channel ',
        channelDescription: 'description',
        priority: priority ? Priority.max : Priority.high, 
        importance: priority ? Importance.max : Importance.low
    );

    var iOS = IOSNotificationDetails();
    var platform = new NotificationDetails(android: android, iOS: iOS);

    await flutterLocalNotificationsPlugin.show(id, title, body, platform, payload: payload); 
  }
}
