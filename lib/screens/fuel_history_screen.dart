import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/database_helper.dart';
import '../models/fuel_record.dart';

class FuelHistoryScreen extends StatefulWidget {
  const FuelHistoryScreen({super.key});

  @override
  State<FuelHistoryScreen> createState() => _FuelHistoryScreenState();
}

class _FuelHistoryScreenState extends State<FuelHistoryScreen> {
  late Future<List<FuelRecord>> _fuelRecordsFuture;

  @override
  void initState() {
    super.initState();
    _fuelRecordsFuture = DatabaseHelper.instance.getFuelRecords();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('給油履歴一覧'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context), //戻るボタン
        ),
      ),
      body: FutureBuilder<List<FuelRecord>>(
        future: _fuelRecordsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('給油履歴はありません.'));
          }

          final records = snapshot.data!;
          return ListView.builder(
            itemCount: records.length,
            itemBuilder: (context, index) {
              final record = records[index];
              final gasPrice = record.paymentAmount / record.fuelAmount;
              final refuelDate = DateFormat(
                'yyyy/MM/dd',
              ).format(DateTime.parse(record.refuelDate));

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: ListTile(
                  title: Text(
                    '$refuelDate - ${record.fuelAmount.toStringAsFixed(2)}L',
                  ),
                  subtitle: Text(
                    '支払: ${record.paymentAmount}円 | 単価: ${gasPrice.toStringAsFixed(1)}円/L\n'
                    '期間走行距離: ${record.distanceSinceLastRefuel.toStringAsFixed(1)}km | 実績燃費: ${record.calculatedFuelEconomy.toStringAsFixed(1)}km/L',
                  ),
                  isThreeLine: true,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
