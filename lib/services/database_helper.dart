import 'package:realtime_gasorin_app/services/database.dart';
import 'package:drift/drift.dart';

class DatabaseHelper {
  final AppDatabase _db;

  DatabaseHelper._privateConstructor() : _db = AppDatabase();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // --- VehicleSettings CRUD ---
  Future<VehicleSetting?> getVehicleSettings() {
    return (_db.select(_db.vehicleSettings)..limit(1)).getSingleOrNull();
  }

  Future<int> createVehicleSettings(VehicleSettingsCompanion settings) {
    return _db.into(_db.vehicleSettings).insert(settings);
  }

  Future<int> updateVehicleSettings(VehicleSettingsCompanion settings) {
    return (_db.update(_db.vehicleSettings)).write(settings);
  }

  // --- FuelRecord CRUD ---
  Future<List<FuelRecord>> getFuelRecords() {
    return (_db.select(_db.fuelRecords)..orderBy([
          (t) =>
              OrderingTerm(expression: t.refuelDate, mode: OrderingMode.desc),
        ]))
        .get();
  }

  Future<int> createFuelRecord(FuelRecordsCompanion record) {
    return _db.into(_db.fuelRecords).insert(record);
  }

  Future<FuelRecord?> getLastFuelRecord() {
    return (_db.select(_db.fuelRecords)
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.refuelDate, mode: OrderingMode.desc),
          ])
          ..limit(1))
        .getSingleOrNull();
  }

  // --- Trip CRUD ---
  Future<int> createTrip(TripsCompanion trip) {
    return _db.into(_db.trips).insert(trip);
  }

  Future<List<Trip>> getTripsSince(String? date) {
    final query = _db.select(_db.trips);
    if (date != null) {
      query.where((tbl) => tbl.date.isBiggerThanValue(date));
    }
    return query.get();
  }

  // --- バッチ処理 ---
  Future<void> deleteOldData() async {
    final oneYearAgo = DateTime.now().subtract(const Duration(days: 365));
    await (_db.delete(_db.fuelRecords)..where(
          (tbl) =>
              tbl.refuelDate.isSmallerThanValue(oneYearAgo.toIso8601String()),
        ))
        .go();
    await (_db.delete(_db.trips)..where(
          (tbl) => tbl.date.isSmallerThanValue(oneYearAgo.toIso8601String()),
        ))
        .go();
  }
}
