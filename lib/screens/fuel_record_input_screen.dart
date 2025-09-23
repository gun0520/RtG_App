import 'package:flutter/material.dart';
import '../services/database_helper.dart';
import '../models/fuel_record.dart';

class FuelRecordInputScreen extends StatefulWidget {
  const FuelRecordInputScreen({super.key});

  @override
  State<FuelRecordInputScreen> createState() => _FuelRecordInputScreenState();
}

class _FuelRecordInputScreenState extends State<FuelRecordInputScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fuelAmountController = TextEditingController();
  final _paymentAmountController = TextEditingController();

  Future<void> _saveRecord() async {
    if (_formKey.currentState!.validate()) {
      //完全な実装では、前回の給油からの走行距離をこの画面に渡します。
      //ここではプレースホルダ―値を使用します。
      const distanceSinceLastRefuel = 250.0; //プレースホルダ―
      final fuelAmount = double.parse(_fuelAmountController.text);

      final calculatedEconomy = distanceSinceLastRefuel / fuelAmount;

      final newRecord = FuelRecord(
        refuelDate: DateTime.now().toIso8601String(),
        fuelAmount: fuelAmount,
        paymentAmount: int.parse(_paymentAmountController.text),
        distanceSinceLastRefuel: distanceSinceLastRefuel,
        calculatedFuelEconomy: calculatedEconomy,
        createdAt: DateTime.now().toIso8601String(),
      );

      await DatabaseHelper.instance.createFuelRecord(newRecord);

      //ここで新しい'calculatedEconomy'で'VehicleSettings'を更新する
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('給油記録を保存しました')));
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('給油記録入力')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            TextFormField(
              controller: _fuelAmountController,
              decoration: const InputDecoration(labelText: '給油量(L)'),
              keyboardType: TextInputType.number,
              validator: (value) =>
                  (value == null || value.isEmpty) ? '必須項目です' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _paymentAmountController,
              decoration: const InputDecoration(labelText: '支払金額(円)'),
              keyboardType: TextInputType.number,
              validator: (value) =>
                  (value == null || value.isEmpty) ? '必須項目です' : null,
            ),
            const SizedBox(height: 32),
            ElevatedButton(onPressed: _saveRecord, child: const Text('保存')),
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
