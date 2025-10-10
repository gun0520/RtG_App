import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/database.dart';
import '../services/database_helper.dart';

class FuelHistoryScreen extends StatefulWidget {
  const FuelHistoryScreen({super.key});

  @override
  State<FuelHistoryScreen> createState() => _FuelHistoryScreenState();
}

class _FuelHistoryScreenState extends State<FuelHistoryScreen> {
  // getFuelRecords()の結果を保持するためのFuture
  late Future<List<FuelRecord>> _fuelRecordsFuture;

  @override
  void initState() {
    super.initState();
    // 画面初期化時にデータベースから給油履歴を取得する
    _fuelRecordsFuture = DatabaseHelper.instance.getFuelRecords();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('給油履歴')),
      // FutureBuilderを使って非同期処理の結果に応じてUIを構築する
      body: FutureBuilder<List<FuelRecord>>(
        future: _fuelRecordsFuture,
        builder: (context, snapshot) {
          // 処理中の場合、ローディングインジケータを表示
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // エラーが発生した場合、エラーメッセージを表示
          if (snapshot.hasError) {
            return Center(child: Text('エラーが発生しました: ${snapshot.error}'));
          }
          // データがない（履歴が0件の）場合
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('給油履歴はありません。'));
          }

          // 正常にデータが取得できた場合、リストを表示
          final records = snapshot.data!;
          return ListView.builder(
            itemCount: records.length,
            itemBuilder: (context, index) {
              final record = records[index];
              final refuelDate = DateFormat(
                'yyyy/MM/dd',
              ).format(DateTime.parse(record.refuelDate));
              final economy =
                  record.calculatedFuelEconomy?.toStringAsFixed(1) ?? '---';

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: ListTile(
                  leading: const Icon(
                    Icons.local_gas_station,
                    color: Colors.blue,
                  ),
                  title: Text(
                    '$refuelDate - ${record.fuelAmount.toStringAsFixed(1)}L',
                  ),
                  subtitle: Text(
                    '支払金額: ${record.totalPrice.toStringAsFixed(0)}円',
                  ),
                  trailing: Text(
                    '$economy km/L',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
