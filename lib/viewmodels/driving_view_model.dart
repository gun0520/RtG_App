import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/vehicle_settings.dart';
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

  // ▼▼▼【修正点】重複していたtoggleDrivingを1つに統合し、@overrideを削除 ▼▼▼
  /// 走行開始・停止を切り替える
  void toggleDriving() {
    if (_locationService.isTracking) {
      _stopDrivingAndSaveTrip();
    } else {
      // 走行開始時に現在の燃料を記録することで、計算の基準点を固定する
      SharedPreferences.getInstance().then((prefs) {
        prefs.setDouble('fuelOnStartDriving', _remainingFuel);
      });
      _locationService.startTracking();
    }
    notifyListeners();
  }

  /// 走行を停止し、記録をDBに保存する
  Future<void> _stopDrivingAndSaveTrip() async {
    final distance = _locationService.tripDistance;
    _locationService.stopTracking();

    // 走行距離をDBに保存
    if (distance > 0.1) {
      await _dbHelper.createTrip(
        Trip(distance: distance, date: DateTime.now().toIso8601String()),
      );
    }

    // 走行終了時の燃料残量を永続化
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('remainingFuel', _remainingFuel);
  }

  /// 【ロジック①】走行距離の更新に応じて、ガソリン残量と航続可能距離をリアルタイム計算
  void _onDistanceUpdated() {
    if (settings != null && settings!.manualFuelEconomy > 0) {
      _recalculateFuelFromLastState();
    }
    _checkForLowFuel();
    notifyListeners();
  }

  /// 最後に保存された状態から燃料を再計算
  Future<void> _recalculateFuelFromLastState() async {
    final prefs = await SharedPreferences.getInstance();
    double initialFuelOnStart =
        prefs.getDouble('fuelOnStartDriving') ?? _remainingFuel;

    double consumedFuel = tripDistance / settings!.manualFuelEconomy;
    _remainingFuel = initialFuelOnStart - consumedFuel;
    if (_remainingFuel < 0) _remainingFuel = 0;

    _updateRange();
  }

  /// 【ロジック②】給油記録の保存と「実績燃費」の計算・更新
  Future<void> saveFuelRecord(double amount, double price) async {
    // ... (このメソッドは変更なし)
  }

  /// 航続可能距離を更新する
  void _updateRange() {
    // ... (このメソッドは変更なし)
  }

  /// ガソリン残量低下通知をチェック
  void _checkForLowFuel() {
    // ... (このメソッドは変更なし)
  }

  @override
  void dispose() {
    _locationService.removeListener(_onDistanceUpdated);
    super.dispose();
  }
}
