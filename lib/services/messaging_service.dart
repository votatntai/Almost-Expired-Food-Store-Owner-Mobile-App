import 'package:appetit/cubits/notification/notification_cubit.dart';
import 'package:appetit/domains/repositories/user_repo.dart';
import 'package:appetit/screens/OrdersWaitPaymentScreen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:nb_utils/nb_utils.dart';

import '../utils/Constants.dart';

class MessagingService {
  final _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  void _handleMessage(RemoteMessage? message) async {
    if (message == null) {
      return;
    }
    navigatorKey.currentState?.pushNamed(OrdersWaitPaymentScreen.routeName);
  }

  Future<void> initNotification() async {
    await _firebaseMessaging.requestPermission();
    String? token = await _firebaseMessaging.getToken();
    if (token != null) {
      UserRepo.deviceToken = token;
      initPushNotification();
      // FirebaseMessaging.onMessage.listen((message){
      //   print('Title:  ${message.notification?.title}');

      // });
      print('Token của thiết bị: ${UserRepo.deviceToken}');
    } else {
      print('Không thể lấy token của thiết bị');
    }
  }

  Future initPushNotification() async {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
    // FirebaseMessaging.instance.getInitialMessage().then(_handleMessage);
    final _notificationCubit = NotificationCubit();
    _notificationCubit.getNotifications();
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    _initLocalNotify();
      showNotification(message.notification!.title!, message.notification!.body!);
    });
  }

  void _initLocalNotify() {
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: DarwinInitializationSettings(),
    );

    _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
          navigatorKey.currentState?.pushNamed(OrdersWaitPaymentScreen.routeName);
      },
    );

final value = getIntAsync(AppConstant.NOTI_COUNT as String);
      setValue(AppConstant.NOTI_COUNT, value + 1);
      print(getIntAsync(AppConstant.NOTI_COUNT).toString());
    // Xử lý trường hợp ứng dụng được mở thông qua một thông báo
    _flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails().then((NotificationAppLaunchDetails? details) {
      if (details != null && details.didNotificationLaunchApp) {
        String? payload = details.notificationResponse?.payload;
        if (payload != null) {
          debugPrint('notification payload: $payload');
          // Thực hiện các hành động khi người dùng nhấn vào thông báo tại đây.
          
        }
      }
    });
  }

  Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    print("Handling a background message: ${message.messageId}");

    // Lấy thông tin từ message
    String title = message.notification?.title ?? 'Default title';
    String body = message.notification?.body ?? 'Default body';

    // Hiển thị thông báo khi có message tới
    await showNotification(title, body);
  }

  Future<void> showNotification(String title, String body) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', // ID kênh thông báo
        'your channel name', // Tên kênh thông báo
        importance: Importance.max,
        playSound: true,
        showProgress: true,
        priority: Priority.high,);
    var platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await FlutterLocalNotificationsPlugin().show(
      0, // ID thông báo, thay đổi để hiển thị nhiều thông báo khác nhau
      title,
      body,
      platformChannelSpecifics,
    );
    await _flutterLocalNotificationsPlugin.show(0, title, body, platformChannelSpecifics, payload: 'item x');
  }
}
