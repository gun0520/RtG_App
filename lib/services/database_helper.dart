import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
// ▼▼▼【修正点②】モデルファイルをインポートする ▼▼▼
import '../models/vehicle_settings.dart';

class DatabaseHelper {
  static const _databaseName = "realtime_gasorin.db";
  static const _databaseVersion = 1;

  // 各テーブル名
  static const tableVehicleSettings = 'vehicle_settings';
  static const tableFuelRecords = 'fuel_records';
  static const tableTrips = 'trips';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _createDB,
    );
  }

  // データベースのテーブルを作成する
  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableVehicleSettings(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        tank_capacity REAL NOT NULL,
        manual_fuel_economy REAL NOT NULL,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        updated_at TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');
    await db.execute('''
      CREATE TABLE $tableFuelRecords(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        fuel_amount REAL NOT NULL,
        total_price REAL NOT NULL,
        refuel_date TEXT NOT NULL,
        calculated_fuel_economy REAL,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');
    await db.execute('''
      CREATE TABLE $tableTrips(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        distance REAL NOT NULL,
        date TEXT NOT NULL,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');
  }

  // --- VehicleSettings CRUD ---
  Future<int> createVehicleSettings(VehicleSettings settings) async {
    final db = await instance.database;
    return await db.insert(tableVehicleSettings, settings.toMap());
  }

  Future<VehicleSettings?> getVehicleSettings() async {
    final db = await instance.database;
    final maps = await db.query(tableVehicleSettings, limit: 1);
    if (maps.isNotEmpty) {
      return VehicleSettings.fromMap(maps.first);
    }
    return null;
  }

  // ▼▼▼【修正点①】不要なupdatedAtの更新処理を削除 ▼▼▼
  Future<int> updateVehicleSettings(VehicleSettings settings) async {
    final db = await instance.database;
    return await db.update(
      tableVehicleSettings,
      settings.toMap(),
      where: 'id = ?',
      whereArgs: [settings.id],
    );
  }

  // --- FuelRecord CRUD (Tripも同様に定義) ---
  Future<int> createFuelRecord(FuelRecord record) async {
    final db = await instance.database;
    return await db.insert(tableFuelRecords, record.toMap());
  }

  Future<List<FuelRecord>> getFuelRecords() async {
    final db = await instance.database;
    final maps = await db.query(tableFuelRecords, orderBy: 'refuel_date DESC');
    return List.generate(maps.length, (i) {
      // ここはFuelRecord.fromMapを実装する必要があります
      // 今回はtoMapしか使っていないため、暫定的にtoMapを流用します
      return FuelRecord.fromMap(maps[i]);
    });
  }

  Future<String?> getLastFuelRecordDate() async {
    final db = await instance.database;
    final maps = await db.query(
      tableFuelRecords,
      columns: ['refuel_date'],
      orderBy: 'refuel_date DESC',
      limit: 1,
    );
    if (maps.isNotEmpty) {
      return maps.first['refuel_date'] as String?;
    }
    return null;
  }

  // --- Trip CRUD ---
  Future<int> createTrip(Trip trip) async {
    final db = await instance.database;
    return await db.insert(tableTrips, trip.toMap());
  }

  Future<List<Trip>> getTripsSince(String? date) async {
    final db = await instance.database;
    List<Map<String, dynamic>> maps;
    if (date != null) {
      maps = await db.query(tableTrips, where: 'date > ?', whereArgs: [date]);
    } else {
      maps = await db.query(tableTrips);
    }
    return List.generate(maps.length, (i) {
      return Trip(
        id: maps[i]['id'] as int,
        distance: maps[i]['distance'] as double,
        date: maps[i]['date'] as String,
      );
    });
  }

  // --- バッチ処理 ---
  Future<void> deleteOldData() async {
    final db = await instance.database;
    final oneYearAgo = DateTime.now()
        .subtract(const Duration(days: 365))
        .toIso8601String();
    await db.delete(
      tableFuelRecords,
      where: 'refuel_date < ?',
      whereArgs: [oneYearAgo],
    );
    await db.delete(tableTrips, where: 'date < ?', whereArgs: [oneYearAgo]);
  }
}
