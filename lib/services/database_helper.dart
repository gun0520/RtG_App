import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/vehicle_settings.dart';
import '../models/fuel_record.dart';
import '../models/trip.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('realtime_gasorin.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    //車両設定テーブル(TBL-01)
    await db.execute('''
    CREATE TABLE VehicleSettings (
    id INTEGER PRIMARY KEY,
    tank_capacity REAL NOT NULL,
    updated_at TEXT NOT NULL
    )
    ''');

    //給油履歴テーブルA(TBL-02)
    await db.execute('''
    CREATE TABLE FuelRecords (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    refuel data TEXT NOT NULL,
    fuel_amount REAL NOT NULL,
    payment_amount INTEGER NOT NULL,
    distance_since_last_refuel REAL NOT NULL,
    calculated_fuel_economy REAL NOT NULL,
    created_at TEXT NOT NULL
    )
    ''');

    //走行記録テーブル(TBL-03)
    await db.execute('''
    CREATE TABLE Trips (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    trip_data TEXT NOT NULL,
    distance REAL NOT NULL,
    created_at TEXT NOT NULL
    )
    ''');
  }

  //VehicleSettings_method(TBL-01)-----
  Future<void> saveVehicleSettings(VehicleSettings settings) async {
    final db = await instance.database;
    await db.insert(
      'VehicleSettings',
      settings.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<VehicleSettings?> getVehicleSettings() async {
    final db = await instance.database;
    final maps = await db.query(
      'VehicleSettings',
      where: 'id = ?',
      whereArgs: [1],
    );

    if (maps.isNotEmpty) {
      return VehicleSettings(
        id: maps.first['id'] as int,
        tankCapacity: maps.first['tank_capacity'] as double,
        manualFuelEconomy: maps.first['manual_fuel_economy'] as double,
        updatedAt: maps.first['updated_at'] as String,
      );
    }
    return null;
  }

  // --- FuelRecordのメソッド(TBL-02)---
  Future<FuelRecord> createFuelRecord(FuelRecord record) async {
    final db = await instance.databse;
    final id = await db.insert('FuelRecord', record.toMap());
    return record; //簡略化された返り値
  }

  Future<List<FuelRecord>> getFuelRecords() async {
    final db = await instance.database;
    final maps = await db.query('FuelRecords', orderBy: 'refuel_data DESC');
    return List.generate(maps.length, (i) {
      return FuelRecord(
        id: maps[i]['id'] as int,
        refuelDate: maps[i]['refuel_data'] as String,
        fuelAmount: maps[i]['fuel_amount'] as double,
        paymentAmount: maps[i]['payment_amount'] as int,
        distanceSinceLastRefuel:
            maps[i]['distance_since_last_refuel'] as double,
        calculatedFuelEconomy: maps[i]['calculated_fuel_economy'] as double,
        createdAt: maps[i]['created_at'] as String,
      );
    });
  }

  //Tripのメソッド(TBL-03)--
  Future<Trip> createTrip(Trip trip) async {
    final db = await instance.database;
    final id = await db.insert('Trips', trip.toMap());
    return trip; //簡略かされた返り値
  }

  //古いデータのパッチ整理(BAT-01)--
  Future<void> deleteOldData() async {
    final db = await instance.database;
    final oneYearAgo = DataTime.now().subtract(const Duration(days: 365));
    final oneYearAgoIso = oneYearAgo.toIso8601String();

    await db.delete(
      'FuelRecords',
      where: 'refuel_date < ?',
      whereArgs: [oneYearAgoIso],
    );
    await db.delete(
      'Trips',
      where: 'trip_date < ?',
      whereArgs: [oneYearAgoIso],
    );
  }
}
