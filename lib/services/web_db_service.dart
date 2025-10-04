import 'package:drift/web.dart';
import 'package:drift/drift.dart';

// Web用のDB接続を返す関数
QueryExecutor openConnection() {
  return LazyDatabase(() async {
    // IndexedDBをストレージとして使用するWebDatabaseを返すように指定
    return WebDatabase.withStorage(await DriftWebStorage.indexedDb('db'));
  });
}
