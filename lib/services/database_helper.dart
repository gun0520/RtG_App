import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/vehicle_settings.dart';
import '../models/fuel_record.dart';
import '../models/trip.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
}
