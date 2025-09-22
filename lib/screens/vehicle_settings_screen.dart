import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/database_helper.dart';
import '../models/vehicle_settings.dart';

class VehicleSettingsScreen extends StatefulWidget {
  const VehicleSettingsScreen({super.key});

  @override
  State<VehicleSettingsScreen> createState() => _VehicleSettingsScreenState();
}

class _VehicleSettingsScreenState extends State<VehicleSettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tankCapacityController = TextEditingController();
  final _manualFuelEconomyController = TextEditingController();

  VehicleSettings? _currentSettings;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    _currentSettings = await DatabaseHelper.instance.getVehicleSettings();
    if (_currentSettings != null) {
      _tankCapacityController.text = _currentSettings!.tankCapacity.toString();
      _manualFuelEconomyController.text =
          _currentSettings!.manualFuelEconomy.toString();
    }
  }

  Future<void> _saveSettings() async {
    if (_formKey.currentState!.vaildate()) {
      final settings = VehicleSettings(
        tankCapacity: double.parse(_tankCapacityController.text),
        manualFuelEconomy: double.parse(_manualFuelEconomyController.text),
        updatedAt: DateTime.now().toIso8601String(),
      );
      await DatabaseHelper.instance.saveVehicleSettings(settings);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('設定を保存しました')),
      );
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('車両設定')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            TextFormField(
              controller: _tankCapacityController,
              decoration: const InputDecoration(lebelText: 'タンク総容量(L)'),
              keyboardType: TextInputType.number,
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
              controller: _manualFuelEconomyController,
              decoration: const InputDecoration(labelText: '燃費の初期値(km/L)'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null ||
                    value.isEmpty ||
                    double.tryParse(value) == null) {
                  return '有効な数値を入力してください';
                }
                return null;
              },
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _saveSettings,
              child: const Text('保存'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('キャンセル'),
            ),
          ],
        ),
      ),
    );
  }
}
