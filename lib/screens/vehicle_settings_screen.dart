import 'package:flutter/material.dart';
import '../models/vehicle_settings.dart';
import '../services/database_helper.dart';
import 'driving_screen.dart';

class VehicleSettingsScreen extends StatefulWidget {
  const VehicleSettingsScreen({super.key});

  @override
  State<VehicleSettingsScreen> createState() => _VehicleSettingsScreenState();
}

class _VehicleSettingsScreenState extends State<VehicleSettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tankCapacityController = TextEditingController();
  final _fuelEconomyController = TextEditingController();

  VehicleSettings? _existingSettings;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  // 既存の設定をDBから読み込む
  Future<void> _loadSettings() async {
    final settings = await DatabaseHelper.instance.getVehicleSettings();
    if (settings != null) {
      setState(() {
        _existingSettings = settings;
        _tankCapacityController.text = settings.tankCapacity.toString();
        _fuelEconomyController.text = settings.manualFuelEconomy.toString();
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _tankCapacityController.dispose();
    _fuelEconomyController.dispose();
    super.dispose();
  }

  // 設定を保存するメソッド（これがsaveVehicleSettingsの正しい実装）
  Future<void> _saveSettings() async {
    if (_formKey.currentState!.validate()) {
      final tankCapacity = double.parse(_tankCapacityController.text);
      final fuelEconomy = double.parse(_fuelEconomyController.text);

      if (_existingSettings == null) {
        // --- ① 初めて設定を保存する場合 (INSERT) ---
        final newSettings = VehicleSettings(
          tankCapacity: tankCapacity,
          manualFuelEconomy: fuelEconomy,
        );
        await DatabaseHelper.instance.createVehicleSettings(newSettings);

        // 初期設定後は走行画面に置き換える（戻るボタンで戻れないように）
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const DrivingScreen()),
          );
        }
      } else {
        // --- ② 既存の設定を更新する場合 (UPDATE) ---
        _existingSettings!.tankCapacity = tankCapacity;
        _existingSettings!.manualFuelEconomy = fuelEconomy;
        await DatabaseHelper.instance.updateVehicleSettings(_existingSettings!);

        if (mounted) {
          Navigator.of(context).pop(); // 更新後は前の画面に戻る
        }
      }

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('設定を保存しました。')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_existingSettings == null ? '初期車両設定' : '車両設定の編集'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _tankCapacityController,
                decoration: const InputDecoration(
                  labelText: 'タンク容量 (L)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      double.tryParse(value) == null) {
                    return '有効な数値を入力してください';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _fuelEconomyController,
                decoration: const InputDecoration(
                  labelText: '初期燃費 (km/L)',
                  helperText: '実績燃費が計算されるまでの初期値として使われます。',
                  border: OutlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      double.tryParse(value) == null) {
                    return '有効な数値を入力してください';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveSettings,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('保存'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
