import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
// driftが生成したデータクラスやデータベース本体をインポート
import '../services/database_helper.dart';
import '../services/location_service.dart';
import '../services/notification_service.dart';

class DrivingViewModel with ChangeNotifier {
  final LocationService _locationService;
  final NotificationService _notificationService = NotificationService();
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  // モデルの型をdriftが生成したものに変更
  VehicleSetting? settings;
  double _remainingFuel = 0.0;
  double _range = 0.0;
  bool _isLoading = true;
  bool _lowFuelNotificationSent = false;

  double get remainingFuel => _remainingFuel;
  double get range => _range;
  double get tripDistance => _locationService.tripDistance;
  bool get isTracking => _locationService.isTracking;
  bool get isLoading => _isLoading;
  double get fuelPercentage => (settings != null && settings!.tankCapacity > 0)
      ? _remainingFuel / settings!.tankCapacity
      : 0.0;

  DrivingViewModel(this._locationService) {
    _locationService.addListener(_onDistanceUpdated);
  }

  Future<void> loadInitialData() async {
    _isLoading = true;
    notifyListeners();
    settings = await _dbHelper.getVehicleSettings();
    final prefs = await SharedPreferences.getInstance();
    _remainingFuel =
        prefs.getDouble('remainingFuel') ?? settings?.tankCapacity ?? 0.0;
    _updateRange();
    _isLoading = false;
    notifyListeners();
  }

  void toggleDriving() {
    if (_locationService.isTracking) {
      _stopDrivingAndSaveTrip();
    } else {
      SharedPreferences.getInstance().then((prefs) {
        prefs.setDouble('fuelOnStartDriving', _remainingFuel);
      });
      _locationService.startTracking();
    }
    notifyListeners();
  }

  Future<void> _stopDrivingAndSaveTrip() async {
    final distance = _locationService.tripDistance;
    _locationService.stopTracking();
    if (distance > 0.1) {
      // データの挿入には`Companion`を使う
      final trip = Trip(
          id: 0, distance: distance, date: DateTime.now().toIso8601String());
      await _dbHelper.createTrip(trip);
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('remainingFuel', _remainingFuel);
  }

  void _onDistanceUpdated() {
    if (settings != null && settings!.manualFuelEconomy > 0) {
      _recalculateFuelFromLastState();
    }
    _checkForLowFuel();
    notifyListeners();
  }

  Future<void> _recalculateFuelFromLastState() async {
    final prefs = await SharedPreferences.getInstance();
    double initialFuelOnStart =
        prefs.getDouble('fuelOnStartDriving') ?? _remainingFuel;
    double consumedFuel = tripDistance / settings!.manualFuelEconomy;
    _remainingFuel = initialFuelOnStart - consumedFuel;
    if (_remainingFuel < 0) _remainingFuel = 0;
    _updateRange();
  }

  Future<void> saveFuelRecord(double amount, double price) async {
    final lastRecord = await _dbHelper.getLastFuelRecord();
    final trips = await _dbHelper.getTripsSince(lastRecord?.refuelDate);
    double totalDistance = trips.fold(0.0, (sum, trip) => sum + trip.distance);
    double actualEconomy = 0.0;
    if (amount > 0 && totalDistance > 0) {
      actualEconomy = totalDistance / amount;
    }
    final newRecord = FuelRecord(
      id: 0,
      fuelAmount: amount,
      totalPrice: price,
      refuelDate: DateTime.now().toIso8601String(),
      calculatedFuelEconomy: actualEconomy > 0 ? actualEconomy : null,
    );
    await _dbHelper.createFuelRecord(newRecord);

    if (actualEconomy > 0 && settings != null) {
      settings!.manualFuelEconomy = actualEconomy;
      await _dbHelper.updateVehicleSettings(settings!);
    }
    _remainingFuel = settings?.tankCapacity ?? 0.0;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('remainingFuel', _remainingFuel);
    _lowFuelNotificationSent = false;
    _updateRange();
    notifyListeners();
  }

  void _updateRange() {
    if (settings != null && settings!.manualFuelEconomy > 0) {
      _range = _remainingFuel * settings!.manualFuelEconomy;
    } else {
      _range = 0.0;
    }
  }

  void _checkForLowFuel() {
    if (settings == null) return;
    if (fuelPercentage < 0.15 && !_lowFuelNotificationSent) {
      _notificationService.showLowFuelAlert();
      _lowFuelNotificationSent = true;
    }
  }

  @override
  void dispose() {
    _locationService.removeListener(_onDistanceUpdated);
    super.dispose();
  }
}
