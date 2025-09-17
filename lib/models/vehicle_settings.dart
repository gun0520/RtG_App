class VehicleSettings {
  final int id;
  double tankCapacity;
  double manualFuelEconomy;
  final String updatedAt;

  VehicleSettings({
    this.id = 1,
    required this.tankCapacity,
    required this.manualFuelEconomy,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tank_capacity': tankCapacity,
      'manual_fuel_economy': manualFuelEconomy,
      'updated_at': updatedAt,
    };
  }
}
