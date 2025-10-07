import 'package:drift/drift.dart';

// ▼▼▼【最重要修正点】プラットフォームによってインポートするファイルを切り替える ▼▼▼
import 'db/native.dart' if (dart.library.html) 'db/web.dart';

part 'database.g.dart';

// --- テーブル定義 (変更なし) ---
@DataClassName('VehicleSetting')
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
  // コンストラクタで、条件付きインポートされた openConnection を呼び出す
  AppDatabase() : super(openConnection());

  @override
  int get schemaVersion => 1;
}
