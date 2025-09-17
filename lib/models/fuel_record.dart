// Corresponds to TBL-02: FuelRecords
class FuelRecord {
  final int? id;
  final String refuelDate;
  final double fuelAmount;
  final int paymentAmount;
  final double distanceSinceLastRefuel;
  final double calculatedFuelEconomy;
  final String createdAt;

  FuelRecord({
    this.id,
    required this.refuelDate,
    required this.fuelAmount,
    required this.paymentAmount,
    required this.distanceSinceLastRefuel,
    required this.calculatedFuelEconomy,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'refuel_date': refuelDate,
      'fuel_amount': fuelAmount,
      'payment_amount': paymentAmount,
      'distance_since_last_refuel': distanceSinceLastRefuel,
      'calculated_fuel_economy': calculatedFuelEconomy,
      'created_at': createdAt,
    };
  }
}
