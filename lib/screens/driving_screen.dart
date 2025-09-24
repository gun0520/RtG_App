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
    setState(() {
      _isDriving = !_isDriving;
      if (_isDriving) {
        //GPS計測を開始
      } else {
        //GPS計測を停止し、走行記録を保存
      }
    });
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
    if (_settings == null) {
      //設定は確認中はローディングインジケータなどを表示
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final fuelPercentage = _remainingFuel / _settings!.tankCapacity;

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
                _buildInfoCard(),
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
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildInfoColumn('航続可能距離', _range.toStringAsFixed(0), 'km'),
            _buildInfoColumn(
              '今回の走行距離',
              _currentTripDistance.toStringAsFixed(1),
              'km',
            ),
            _buildInfoColumn(
              '登録中の燃費',
              _settings!.manualFuelEconomy.toStringAsFixed(1),
              'km/L',
            ),
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

  Widget _buildActionButtons() {
    return Column(
      children: [
        //走行開始/停止ボタン
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: _isDriving ? Colors.red : Colors.blue,
            minimumSize: const Size(double.infinity, 50),
          ),
          onPressed: _toggleDriving,
          child: Text(
            _isDriving ? '走行停止' : '走行開始',
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
