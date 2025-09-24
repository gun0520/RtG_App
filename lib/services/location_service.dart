import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

class LocationService with ChangeNotifier {
  double _tripDistance = 0.0; //今回の走行距離(km)
  bool _isTracking = false;
  Position? _lastPosition;

  StreamSubscription<Position>? _positionStreamSubscription;

  double get tripDistance => _tripDistance;
  bool get isTracking => _isTracking;

  //権限を確認・要求する
  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      //位置情報サービスが無効な場合のエラー処理
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        //権限が拒否された場合のエラー処理
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      //永久に拒否されている場合のエラー処理
      return false;
    }
    return true;
  }

  //走行距離の計測を開始する
  Future<void> startTracking() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;

    _isTracking = true;
    _tripDistance = 0.0;
    _lastPosition = null;

    //位置情報のストリームを購読
    _positionStreamSubscription =
        Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: 10, //仕様書に基づき10m移動したら更新
          ),
        ).listen((Position position) {
          if (_lastPosition != null) {
            //2点間の距離を計算 (Haversine formule)
            double distanceInMeters = Geolocator.distanceBetween(
              _lastPosition!.latitude,
              _lastPosition!.longitude,
              position.latitude,
              position.longitude,
            );
            _tripDistance += (distanceInMeters / 1000.0); //kmに変換して加算
          }
          _lastPosition = position;
          notifyListeners(); //UIに変更を通知
        });

    notifyListeners();
  }

  //走行距離の計測を停止する
  void stopTracking() {
    _isTracking = false;
    _positionStreamSubscription?.cancel(); //ストリームの購読を中止する
    notifyListeners();
  }
}
