// drift本体と、Web対応用のライブラリをインポート
import 'package:drift/drift.dart';
import 'package:drift/web.dart';
// モバイル用のライブラリを条件付きでインポート
import 'package:realtime_gasorin_app/services/native_db_service.dart'
    if (dart.library.html) 'package:realtime_gasorin_app/services/web_db_service.dart';

// 生成されるコードを読み込むためのpartディレクティブ
part 'database.g.dart';

// --- テーブル定義 ---
@DataClassName('VehicleSetting') // 生成されるデータクラス名を指定
class VehicleSettings extends Table {
  IntColumn get id => integer().autoIncrement()();
  RealColumn get tankCapacity => real().named('tank_capacity')();
  RealColumn get manualFuelEconomy => real().named('manual_fuel_economy')();
}

@DataClassName('Trip')
class Trips extends Table {
  IntColumn get id => integer().autoIncrement()();
  RealColumn get distance => real()();
  TextColumn get date => text()();
}

@DataClassName('FuelRecord')
class FuelRecords extends Table {
  IntColumn get id => integer().autoIncrement()();
  RealColumn get fuelAmount => real().named('fuel_amount')();
  RealColumn get totalPrice => real().named('total_price')();
  TextColumn get refuelDate => text().named('refuel_date')();
  RealColumn get calculatedFuelEconomy =>
      real().named('calculated_fuel_economy').nullable()();
}

// --- データベースクラスの定義 ---
@DriftDatabase(tables: [VehicleSettings, Trips, FuelRecords])
class AppDatabase extends _$AppDatabase {
  // コンストラクタでプラットフォームに応じた接続処理を呼び出す
  AppDatabase() : super(openConnection());

  @override
  int get schemaVersion => 1;
}
