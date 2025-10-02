// lib/screens/fuel_record_input_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/driving_view_model.dart';

class FuelRecordInputScreen extends StatefulWidget {
  const FuelRecordInputScreen({super.key});

  @override
  State<FuelRecordInputScreen> createState() => _FuelRecordInputScreenState();
}

class _FuelRecordInputScreenState extends State<FuelRecordInputScreen> {
  final _formKey = GlobalKey<FormState>();
  // TextEditingControllerを定義
  final _fuelAmountController = TextEditingController();
  final _paymentAmountController = TextEditingController();

  // Controllerを破棄するためのdispose
  @override
  void dispose() {
    _fuelAmountController.dispose();
    _paymentAmountController.dispose();
    super.dispose();
  }

  void _saveRecord() {
    // バリデーションチェック
    if (_formKey.currentState!.validate()) {
      // Stringからdoubleに変換
      final fuelAmount = double.tryParse(_fuelAmountController.text) ?? 0.0;
      final totalPrice = double.tryParse(_paymentAmountController.text) ?? 0.0;

      // ViewModelのメソッドを呼び出して保存処理を移譲
      Provider.of<DrivingViewModel>(
        context,
        listen: false,
      ).saveFuelRecord(fuelAmount, totalPrice);

      // 保存後に前の画面に戻る
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('給油記録を保存しました。実績燃費が更新されました。')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('給油記録')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _fuelAmountController,
                decoration: const InputDecoration(
                  labelText: '給油量 (L)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '給油量を入力してください';
                  }
                  if (double.tryParse(value) == null) {
                    return '有効な数値を入力してください';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _paymentAmountController,
                decoration: const InputDecoration(
                  labelText: '支払金額 (円)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '支払金額を入力してください';
                  }
                  if (int.tryParse(value) == null) {
                    return '有効な数値を入力してください';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveRecord, // 保存メソッドを呼び出し
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
