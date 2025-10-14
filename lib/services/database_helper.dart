import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast_web/sembast_web.dart';

// モデルクラスの定義
class VehicleSetting {
  final int id;
  double tankCapacity;
  double manualFuelEconomy;

  VehicleSetting(
      {required this.id,
      required this.tankCapacity,
      required this.manualFuelEconomy});

  Map<String, dynamic> toMap() => {
        'tankCapacity': tankCapacity,
        'manualFuelEconomy': manualFuelEconomy,
      };

  static VehicleSetting fromMap(int id, Map<String, dynamic> map) =>
      VehicleSetting(
        id: id,
        tankCapacity: map['tankCapacity'] as double,
        manualFuelEconomy: map['manualFuelEconomy'] as double,
      );
}

class Trip {
  final int id;
  final double distance;
  final String date;

  Trip({required this.id, required this.distance, required this.date});
  Map<String, dynamic> toMap() => {'distance': distance, 'date': date};
  static Trip fromMap(int id, Map<String, dynamic> map) => Trip(
      id: id, distance: map['distance'] as double, date: map['date'] as String);
}

class FuelRecord {
  final int id;
  final double fuelAmount;
  final double totalPrice;
  final String refuelDate;
  final double? calculatedFuelEconomy;

  FuelRecord(
      {required this.id,
      required this.fuelAmount,
      required this.totalPrice,
      required this.refuelDate,
      this.calculatedFuelEconomy});

  Map<String, dynamic> toMap() => {
        'fuelAmount': fuelAmount,
        'totalPrice': totalPrice,
        'refuelDate': refuelDate,
        'calculatedFuelEconomy': calculatedFuelEconomy,
      };

  static FuelRecord fromMap(int id, Map<String, dynamic> map) => FuelRecord(
        id: id,
        fuelAmount: map['fuelAmount'] as double,
        totalPrice: map['totalPrice'] as double,
        refuelDate: map['refuelDate'] as String,
        calculatedFuelEconomy: map['calculatedFuelEconomy'] as double?,
      );
}

//DatabaseHelper

class DatabaseHelper {
  static const String _dbName = 'gasorin_app.db';
  Database? _database;

  final _settingsStore = intMapStoreFactory.store('vehicle_settings');
  final _tripsStore = intMapStoreFactory.store('trips');
  final _fuelRecordsStore = intMapStoreFactory.store('fuel_records');

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final DatabaseFactory factory;
    if (kIsWeb) {
      factory = databaseFactoryWeb;
      return await factory.openDatabase(_dbName);
    } else {
      factory = databaseFactoryIo;
      final dir = await getApplicationDocumentsDirectory();
      final dbPath = join(dir.path, _dbName);
      return await factory.openDatabase(dbPath);
    }
  }

// VehicleSettings
  Future<int> createVehicleSettings(VehicleSetting settings) async {
    final db = await database;
    return await _settingsStore.add(db, settings.toMap());
  }

  Future<VehicleSetting?> getVehicleSettings() async {
    final db = await database;
    final record = await _settingsStore.findFirst(db);
    if (record != null) {
      return VehicleSetting.fromMap(record.key, record.value);
    }
    return null;
  }

  Future<int> updateVehicleSettings(VehicleSetting settings) async {
    final db = await database;
    final finder = Finder(filter: Filter.byKey(settings.id));
    return await _settingsStore.update(db, settings.toMap(), finder: finder);
  }

  //trip
  Future<int> createTrip(Trip trip) async {
    final db = await database;
    return await _tripsStore.add(db, trip.toMap());
  }

  Future<List<Trip>> getTripsSince(String? date) async {
    final db = await database;
    final finder = date != null
        ? Finder(
            filter: Filter.greaterThan('date', date),
            sortOrders: [SortOrder('date')])
        : Finder(sortOrders: [SortOrder('date')]);
    final records = await _tripsStore.find(db, finder: finder);
    return records
        .map((snapshot) => Trip.fromMap(snapshot.key, snapshot.value))
        .toList();
  }

  // FuelRecord
  Future<int> createFuelRecord(FuelRecord record) async {
    final db = await database;
    return await _fuelRecordsStore.add(db, record.toMap());
  }

  Future<List<FuelRecord>> getFuelRecords() async {
    final db = await database;
    final finder = Finder(sortOrders: [SortOrder('refuelDate', false)]);
    final records = await _fuelRecordsStore.find(db, finder: finder);
    return records
        .map((snapshot) => FuelRecord.fromMap(snapshot.key, snapshot.value))
        .toList();
  }

  Future<FuelRecord?> getLastFuelRecord() async {
    final db = await database;
    final finder =
        Finder(sortOrders: [SortOrder('refuelDate', false)], limit: 1);
    final record = await _fuelRecordsStore.findFirst(db, finder: finder);
    if (record != null) {
      return FuelRecord.fromMap(record.key, record.value);
    }
    return null;
  }
}
