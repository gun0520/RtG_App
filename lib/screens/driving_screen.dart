import 'package:flutter/material.dart';
import 'fuel_record_input_screen.dart';
import 'fuel_history_screen.dart';
import 'vehicle_settings_screen.dart';
import '../services/database_helper.dart';
import '../models/vehicle_settings.dart';
import 'package:provider/provider.dart';
import '../services/location_service.dart';
import '../services/notification_service.dart';

class DrivingScreen extends StatefulWidget {
  const DrivingScreen({super.key});

  @override
  State<DrivingScreen> createState() => _DrivingScreenState();
}

class _DrivingScreenState extends State<DrivingScreen> {
  double _remainingFuel = 25.5; //プレースホルダー
  double _range = 350.0; //プレースホルダー
  VehicleSettings? _settings;
  bool _lowFuelNotificationSent = false; // 低残量通知を一度だけ送るためのフラグ

  @override
  void initState() {
    super.initState();
    _checkInitialSettings();
  }

  Future<void> _checkInitialSettings() async {
    final settings = await DatabaseHelper.instance.getVehicleSettings();
    setState(() {
      _settings = settings;
    });
    if (_settings == null) {
      //仕様書に基づき、ユーザーは最初に車両設定を行う必要がある
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const VehicleSettingsScreen(),
          ),
        );
      });
    } else {
      //設定に基づいて実勢のデータを読み込む
      //例:_remainingFuel = ...前回の給油と走行記録から計算
    }
  }

  void _toggleDriving() {
    final locationService = context.read<LocationService>();

    if (locationService.isTracking) {
      locationService.stopTracking();
      // ここでは走行距離をDBに保存するロジックを実装
      // final distance = locationService.tripDistance;
      // DatabaseHelper.instance.createTrip(..);
    } else {
      locationService.startTracking();
    }
  }
  

  void _showSettingsMenu() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('給油履歴一覧'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FuelHistoryScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('車両設定'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const VehicleSettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Constmerを使ってLocationServiceの変更を監視
    return Consumer<LocationService> (
      builder: (context, locationService, child) {
    
      if (_settings == null) {
        //設定は確認中はローディングインジケータなどを表示
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }

      // 燃費計算ロジックはもっと整備課が必要
      final fuelPercentage = _remainingFuel / _settings!.tankCapacity;

      // EIF-02の通知ロジック
      if (fuelPercentage < 0.15 && !_lowFuelNotificationSent) {
        NotificationService().showLowFuelAlert();
        setState(() {
          _lowFuelNotificationSent = true; //フラグを立てて再通知を防ぐ
        });
      }

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
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  // 情報表示カード
                  _buildInfoCard(locationService.tripDistance),
                  const SizedBox(height: 20),
                  //ガソリン残量ゲージ
                  LinearProgressIndicator(
                    value: fuelPercentage,
                    minHeight: 20,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      fuelPercentage > 0.15 ? Colors.green : Colors.red, //15％以下で赤
                    ),
                  ),
                  Text(
                    'ガソリン残量: ${_remainingFuel.toStringAsFixed(1)}L / ${_settings!.tankCapacity.toStringAsFixed(1)}L',
                  ),
                ],
              ),
              //アクションボタン
              _buildActionButtons(locationService.isTracking),
            ],
          ),
        ),
      );
    }
  }

  Widget _buildInfoCard(double currentTripDistance) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildInfoColumn('航続可能距離', _range.toStringAsFixed(0), 'km'),
            _buildInfoColumn('今回の走行距離', currentTripDistance.toStringAsFixed(1),'km'),
            _buildInfoColumn('登録中の燃費',_settings!.manualFuelEconomy.toStringAsFixed(1),'km/L'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoColumn(String label, String value, String unit) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        const SizedBox(height: 4),
        Text('$value $unit', style: Theme.of(context).textTheme.headlineSmall),
      ],
    );
  }

  Widget _buildActionButtons(bool isDriving) {
    return Column(
      children: [
        //走行開始/停止ボタン
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: isDriving ? Colors.red : Colors.blue,
            minimumSize: const Size(double.infinity, 50),
          ),
          onPressed: _toggleDriving,
          child: Text(
            isDriving ? '走行停止' : '走行開始',
            style: const TextStyle(fontSize: 18),
          ),
        ),
        const SizedBox(height: 10),
        //給油記録ボタン
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const FuelRecordInputScreen(),
              ),
            );
          },
          child: const Text('給油を記録する', style: TextStyle(fontSize: 18)),
        ),
      ],
    );
  }
}

