import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  //シングルトンインスタンスを作成
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  //通知サービスの初期化
  Future<void> init() async {
    // android用の初期化設定
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_lancher');

    //IOS用の初期化設定
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    const InitializationSettings initializationSettings =
        InitializationSettings(android: androidSettings, iOS: iosSettings);

    await _notificationsPlugin.initialize(initializationSettings);
  }

  // EIF-02 & NOTIF-01: ガソリン残量低下アラートを表示する
  Future<void> showLowFuelAlert() async {
    //Android用の通知詳細設定
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'low_fuel_channel', //チャンネルID
          '低燃費アラート', //チャンネル名
          channelDescription: 'ガソリン残量が少なくなった際に通知します。',
          importance: Importance.max,
          priority: Priority.high,
        );

    //iOS用の通知詳細設定
    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notificationsPlugin.show(
      0, //通知ID
      'ガソリン残量が少なくなっています', //NOTID-01: 通知タイトル
      '残量は15%です。給油をおすすめします。', //NOTIF-01: 通知本文
      notificationDetails,
    );
  }
}
