import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/driving_screen.dart';
import 'screens/vehicle_settings_screen.dart';
import 'services/database_helper.dart';
import 'services/location_service.dart';
import 'services/notification_service.dart';
import 'viewmodels/driving_view_model.dart';

void main() async {
  //Flutterのバインディングを初期化
  WidgetsFlutterBinding.ensureInitialized();

  // 各サービスをインスタンス化
  await NotificationService().init();
  final locationService = LocationService();
  final dbHelper = DatabaseHelper.instance;

  //[ロジック３]BAT-01 バッチ処理の実装
  final prefs = await SharedPreferences.getInstance();
  final lastBatchRunString = prefs.getString('lastBatchRun');
  if (lastBatchRunString != null) {
    final lastBatchRun = DateTime.parse(lastBatchRunString);
    if (DateTime.now().difference(lastBatchRun).inDays >= 30) {
      await dbHelper.deleteOldData();
      await prefs.setString('lastBatchRun', DateTime.now().toIso8601String());
    }
  } else {
    //初回実行時は日時を記録
    await prefs.setString('lastBatchRun', DateTime.now().toIso8601String());
  }

  final settings = await dbHelper.getVehicleSettings();

  runApp(
    // MultiProviderで複数のサービスをウィジェットツリーに提供
    MultiProvider(
      providers: [
        //LocationServiceはアプリのどこからでもアクセス可能に
        ChangeNotifierProvider.value(value: locationService),
        //DrivingViewModelにLocationServiceを渡してインスタンス化
        ChangeNotifierProvider(
          create: (context) => DrivingViewModel(
            //Provider経由でLocationServiceインスタンスを渡す
            Provider.of<LocationService>(context, listen: false),
          ),
        ),
      ],
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
