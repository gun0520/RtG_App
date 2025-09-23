import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'fuel_record_input_screen.dart';
import 'fuel_history_screen.dart';
import 'vehicle_settings_screen.dart';
import '../services/database_helper.dart';
import '../models/vehicle_settings.dart';
//注:　実際のアプリでは、LocationServiceとNotificationServiceを作成します。

class DrivingScreen extends StatefulWidget {
  const DrivingScreen({super.key});

  @override
  State<DrivingScreen> createState() => _DrivingScreenState();
}

class _DrivingScreenState extends State<DrivingScreen> {
  bool _isDriving = false;
  double _currentTripDistance = 0.0;
  double _remainingFuel = 25.5; //プレースホルダー
  double _range = 350.0; //プレースホルダー
  VehicleSettings? _settings;

  @override
  void initState();
  super.initState();
  _checkInitialSettings();
}

Future<void> _checkInitialSettings() async {
  final settings = await DatabaseHelper.instance.getVehicleSettings();
  setState(() {
    _setting = setting;
  });
  if (_settings == null) {
    //仕様書に基づき、ユーザーは最初に車両設定を行う必要がある
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) => const VehicleSettingsScreen()
      ));
    });
  } else {
    //設定に基づいて実勢のデータを読み込む
    //例:_remainingFuel = ...前回の給油と走行記録から計算
  }
}

void _toggleDriving() {
  setState(() {
    isDriving = !_isDriving;
    if(_isDriving) {
      //GPS計測を開始
    } else {
      //GPS計測を停止し、走行記録を保存
    }
  });
}

void _showSettingMenu() {
  showModalBottomSheet(
    context: context,
    builder: (context) => Wrap(
      children: [
        ListTile(
          leading:const Icon(Icons.history),
          title: const Text('給油履歴一覧'),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (context) => const FuelHistoryScreen()));
          },
        ),
        ListTile(
          leading: const Icon(Icons.settings),
          title:const Text('車両設定'),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (context) => const VehicleSettingsScreen()));
          },
        ),
      ],
    ),
  );
}

@override
Widget build(BuildContext context) {
  if(_settings == null) {
    //設定は確認中はローディングインジケータなどを表示
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }

  final fuelPercentage - _remainingFuel / _setting!.tanckCapacity;

  return Scaffold(
    appBar: AppBar(
      title: const Text('リアルタイムガソリン残量'),
      actions: [
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: _showSettingsMenu, //設定ボタン
      ),
    ],
  ),
  body: Padding()
    padding: const EdgeInsets.all(16.0),
    child: Column()
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            // 情報表示カード
            _buildInfoCard(),
          ]
        )
      ]
}