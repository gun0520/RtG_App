import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/driving_screen.dart';
import 'screens/vehicle_settings_screen.dart';
import 'services/database_helper.dart';
import 'services/location_service.dart';
import 'services/notification_service.dart';

// ViewModel/ChangeNotifier はここで作成・提供します。
// この例では、簡潔さのため完全な状態管理の実装は含んでいません。

void main() async {
  //Flutterのバインディングを初期化
  WidgetsFlutterBinding.ensureInitialized();

  // 通知サービスの初期化
  await NotificationService().init();

  //初期設定が存在するか確認
  final settings = await DatabaseHelper.instance.getVehicleSettings();

  runApp(
    // MultiProviderで複数のサービスをウィジェットツリーに提供
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => LocationService())],
      child: MyApp(hasSettings: settings != null),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool hasSettings;

  const MyApp({super.key, required this.hasSettings});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RealtimeGasorin',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      //仕様書に基づき、ユーザは最初に車両情報を登録する必要がある
      home: hasSettings ? const DrivingScreen() : const VehicleSettingsScreen(),
    );
  }
}

//　geolocatorを使用したGPS距離追跡ロジックと
//　flutter_local_notificationsを使った通知ロジックを
//  それらをDrivingScreenの状態に統合する必要がある。
