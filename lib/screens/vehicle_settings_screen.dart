import 'package:flutter/material.dart';
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

  VehicleSetting? _existingSettings;
  bool _isLoading = true;

  double _initialFuelPercentage = 100.0;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  // 既存の設定をDBから読み込む
  Future<void> _loadSettings() async {
    // getVehicleSettingsが返すのは新しい `VehicleSetting?` 型
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

  // ▼▼▼【修正点】データの保存/更新に `Companion` オブジェクトを使うように全体を書き換え ▼▼▼
  Future<void> _saveSettings() async {
    if (_formKey.currentState!.validate()) {
      final tankCapacity = double.parse(_tankCapacityController.text);
      final fuelEconomy = double.parse(_fuelEconomyController.text);

      if (_existingSettings == null) {
        // --- 新規作成（INSERT）の場合 ---
        final newSettings = VehicleSetting(
          id: 0,
          tankCapacity: tankCapacity,
          manualFuelEconomy: fuelEconomy,
        );
        await DatabaseHelper.instance.createVehicleSettings(newSettings);

        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const DrivingScreen()),
          );
        }
      } else {
        _existingSettings!.tankCapacity = tankCapacity;
        _existingSettings!.manualFuelEconomy = fuelEconomy;
        await DatabaseHelper.instance.updateVehicleSettings(_existingSettings!);

        if (mounted) {
          Navigator.of(context).pop();
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
              if (_existingSettings == null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '現在の燃料残量: ${_initialFuelPercentage.toStringAsFixed(0)}%',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Slider(
                      value: _initialFuelPercentage,
                      min: 0,
                      max: 100,
                      divisions: 100,
                      label: '${_initialFuelPercentage.toStringAsFixed(0)}%',
                      onChanged: (double value) {
                        setState(() {
                          _initialFuelPercentage = value;
                        });
                      },
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
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
