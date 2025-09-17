// Corresponds to TBL-03: Trips
class Trip {
  final int? id;
  final String tripDate;
  final double distance;
  final String createdAt;

  Trip({
    this.id,
    required this.tripDate,
    required this.distance,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'trip_date': tripDate,
      'distance': distance,
      'created_at': createdAt,
    };
  }
}
