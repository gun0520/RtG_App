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
      await 
    }
  }
}
