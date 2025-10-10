import 'package:drift/drift.dart';
import 'package:drift/wasm.dart';
import 'package:flutter/foundation.dart';

// Web用のDB接続を返す関数
QueryExecutor openConnection() {
  return DatabaseConnection.delayed(
    Future(() async {
      final result = await WasmDatabase.open(
        databaseName: 'rtg-db',
        sqlite3Uri: Uri.parse('sqlite3.wasm'),
        driftWorkerUri: Uri.parse('drift_worker.js'),
      );

      if (result.missingFeatures.isNotEmpty) {
        debugPrint(
          'Using ${result.chosenImplementation} due to unsupported features (${result.missingFeatures})',
        );
      }
      return result.resolvedExecutor;
    }),
  );
}
