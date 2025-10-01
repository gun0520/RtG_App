import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/database_helper.dart';
import '../services/location_service.dart';
import '../services/notification_service.dart';

class DrivingViewModel with ChangeNotifier {
  final LocationService _locationService;
  final NotificationService _notificationService = NotificationService();
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  VehicleSettings? settings;
  double _remainingFuel = 0.0;
  double _range = 0.0;
  bool _isLoading = true;
  bool _lowFuelNotificationSent = false;

  // UIに公開するゲッター
  double get remainingFuel => _remainingFuel;
  double get range => _range;
  double get tripDistance => _locationService.tripDistance;
  bool get isTracking => _locationService.isTracking;
  bool get isLoading => _isLoading;
  double get fuelPercentage => (settings != null && settings!.tankCapacity > 0)
      ? _remainingFuel / settings!.tankCapacity
      : 0.0;

  DrivingViewModel(this._locationService) {
    //LocationServiceからの変更通知をリッスンする
    _locationService.addListener(_onDistanceUpdated);
  }

  //初期データを読み込む
  Future<void> loadingInitialData() async {
    _isLoading = true;
    notifyListeners();

    settings = await _dbHelper.getVehicleSettings();

    //SharedPreferences1からの前回のガソリン残量を読み込む
    final prefs = await SharedPreferences.getInstance();
    _remainingFuel =
        prefs.getDouble('remainingFuel') ?? settings?.tankCapacity ?? 0.0;

    _updateRange();
    _isLoading = false;
    notifyListeners();
  }
}
