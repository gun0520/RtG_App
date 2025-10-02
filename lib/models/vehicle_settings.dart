// lib/models/vehicle_settings.dart (新規ファイル)

class VehicleSettings {
  final int? id;
  double tankCapacity; // タンク容量
  double manualFuelEconomy; // 登録燃費

  VehicleSettings({
    this.id,
    required this.tankCapacity,
    required this.manualFuelEconomy,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tank_capacity': tankCapacity,
      'manual_fuel_economy': manualFuelEconomy,
    };
  }

  factory VehicleSettings.fromMap(Map<String, dynamic> map) {
    return VehicleSettings(
      id: map['id'],
      tankCapacity: map['tank_capacity'],
      manualFuelEconomy: map['manual_fuel_economy'],
    );
  }
}

class Trip {
  final int? id;
  final double distance;
  final String date;

  Trip({this.id, required this.distance, required this.date});

  Map<String, dynamic> toMap() {
    return {'id': id, 'distance': distance, 'date': date};
  }
}

class FuelRecord {
  final int? id;
  final double fuelAmount;
  final double totalPrice;
  final String refuelDate;
  final double? calculatedFuelEconomy;

  FuelRecord({
    this.id,
    required this.fuelAmount,
    required this.totalPrice,
    required this.refuelDate,
    this.calculatedFuelEconomy,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fuel_amount': fuelAmount,
      'total_price': totalPrice,
      'refuel_date': refuelDate,
      'calculated_fuel_economy': calculatedFuelEconomy,
    };
  }

  factory FuelRecord.fromMap(Map<String, dynamic> map) {
    return FuelRecord(
      id: map['id'],
      fuelAmount: map['fuel_amount'],
      totalPrice: map['total_price'],
      refuelDate: map['refuel_date'],
      calculatedFuelEconomy: map['calculated_fuel_economy'],
    );
  }
}
