// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $VehicleSettingsTable extends VehicleSettings
    with TableInfo<$VehicleSettingsTable, VehicleSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VehicleSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _tankCapacityMeta = const VerificationMeta(
    'tankCapacity',
  );
  @override
  late final GeneratedColumn<double> tankCapacity = GeneratedColumn<double>(
    'tank_capacity',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _manualFuelEconomyMeta = const VerificationMeta(
    'manualFuelEconomy',
  );
  @override
  late final GeneratedColumn<double> manualFuelEconomy =
      GeneratedColumn<double>(
        'manual_fuel_economy',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: true,
      );
  @override
  List<GeneratedColumn> get $columns => [id, tankCapacity, manualFuelEconomy];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'vehicle_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<VehicleSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('tank_capacity')) {
      context.handle(
        _tankCapacityMeta,
        tankCapacity.isAcceptableOrUnknown(
          data['tank_capacity']!,
          _tankCapacityMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_tankCapacityMeta);
    }
    if (data.containsKey('manual_fuel_economy')) {
      context.handle(
        _manualFuelEconomyMeta,
        manualFuelEconomy.isAcceptableOrUnknown(
          data['manual_fuel_economy']!,
          _manualFuelEconomyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_manualFuelEconomyMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  VehicleSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VehicleSetting(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      tankCapacity: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}tank_capacity'],
      )!,
      manualFuelEconomy: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}manual_fuel_economy'],
      )!,
    );
  }

  @override
  $VehicleSettingsTable createAlias(String alias) {
    return $VehicleSettingsTable(attachedDatabase, alias);
  }
}

class VehicleSetting extends DataClass implements Insertable<VehicleSetting> {
  final int id;
  final double tankCapacity;
  final double manualFuelEconomy;
  const VehicleSetting({
    required this.id,
    required this.tankCapacity,
    required this.manualFuelEconomy,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['tank_capacity'] = Variable<double>(tankCapacity);
    map['manual_fuel_economy'] = Variable<double>(manualFuelEconomy);
    return map;
  }

  VehicleSettingsCompanion toCompanion(bool nullToAbsent) {
    return VehicleSettingsCompanion(
      id: Value(id),
      tankCapacity: Value(tankCapacity),
      manualFuelEconomy: Value(manualFuelEconomy),
    );
  }

  factory VehicleSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VehicleSetting(
      id: serializer.fromJson<int>(json['id']),
      tankCapacity: serializer.fromJson<double>(json['tankCapacity']),
      manualFuelEconomy: serializer.fromJson<double>(json['manualFuelEconomy']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'tankCapacity': serializer.toJson<double>(tankCapacity),
      'manualFuelEconomy': serializer.toJson<double>(manualFuelEconomy),
    };
  }

  VehicleSetting copyWith({
    int? id,
    double? tankCapacity,
    double? manualFuelEconomy,
  }) => VehicleSetting(
    id: id ?? this.id,
    tankCapacity: tankCapacity ?? this.tankCapacity,
    manualFuelEconomy: manualFuelEconomy ?? this.manualFuelEconomy,
  );
  VehicleSetting copyWithCompanion(VehicleSettingsCompanion data) {
    return VehicleSetting(
      id: data.id.present ? data.id.value : this.id,
      tankCapacity: data.tankCapacity.present
          ? data.tankCapacity.value
          : this.tankCapacity,
      manualFuelEconomy: data.manualFuelEconomy.present
          ? data.manualFuelEconomy.value
          : this.manualFuelEconomy,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VehicleSetting(')
          ..write('id: $id, ')
          ..write('tankCapacity: $tankCapacity, ')
          ..write('manualFuelEconomy: $manualFuelEconomy')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, tankCapacity, manualFuelEconomy);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VehicleSetting &&
          other.id == this.id &&
          other.tankCapacity == this.tankCapacity &&
          other.manualFuelEconomy == this.manualFuelEconomy);
}

class VehicleSettingsCompanion extends UpdateCompanion<VehicleSetting> {
  final Value<int> id;
  final Value<double> tankCapacity;
  final Value<double> manualFuelEconomy;
  const VehicleSettingsCompanion({
    this.id = const Value.absent(),
    this.tankCapacity = const Value.absent(),
    this.manualFuelEconomy = const Value.absent(),
  });
  VehicleSettingsCompanion.insert({
    this.id = const Value.absent(),
    required double tankCapacity,
    required double manualFuelEconomy,
  }) : tankCapacity = Value(tankCapacity),
       manualFuelEconomy = Value(manualFuelEconomy);
  static Insertable<VehicleSetting> custom({
    Expression<int>? id,
    Expression<double>? tankCapacity,
    Expression<double>? manualFuelEconomy,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tankCapacity != null) 'tank_capacity': tankCapacity,
      if (manualFuelEconomy != null) 'manual_fuel_economy': manualFuelEconomy,
    });
  }

  VehicleSettingsCompanion copyWith({
    Value<int>? id,
    Value<double>? tankCapacity,
    Value<double>? manualFuelEconomy,
  }) {
    return VehicleSettingsCompanion(
      id: id ?? this.id,
      tankCapacity: tankCapacity ?? this.tankCapacity,
      manualFuelEconomy: manualFuelEconomy ?? this.manualFuelEconomy,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (tankCapacity.present) {
      map['tank_capacity'] = Variable<double>(tankCapacity.value);
    }
    if (manualFuelEconomy.present) {
      map['manual_fuel_economy'] = Variable<double>(manualFuelEconomy.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VehicleSettingsCompanion(')
          ..write('id: $id, ')
          ..write('tankCapacity: $tankCapacity, ')
          ..write('manualFuelEconomy: $manualFuelEconomy')
          ..write(')'))
        .toString();
  }
}

class $TripsTable extends Trips with TableInfo<$TripsTable, Trip> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TripsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _distanceMeta = const VerificationMeta(
    'distance',
  );
  @override
  late final GeneratedColumn<double> distance = GeneratedColumn<double>(
    'distance',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, distance, date];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'trips';
  @override
  VerificationContext validateIntegrity(
    Insertable<Trip> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('distance')) {
      context.handle(
        _distanceMeta,
        distance.isAcceptableOrUnknown(data['distance']!, _distanceMeta),
      );
    } else if (isInserting) {
      context.missing(_distanceMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Trip map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Trip(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      distance: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}distance'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
    );
  }

  @override
  $TripsTable createAlias(String alias) {
    return $TripsTable(attachedDatabase, alias);
  }
}

class Trip extends DataClass implements Insertable<Trip> {
  final int id;
  final double distance;
  final String date;
  const Trip({required this.id, required this.distance, required this.date});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['distance'] = Variable<double>(distance);
    map['date'] = Variable<String>(date);
    return map;
  }

  TripsCompanion toCompanion(bool nullToAbsent) {
    return TripsCompanion(
      id: Value(id),
      distance: Value(distance),
      date: Value(date),
    );
  }

  factory Trip.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Trip(
      id: serializer.fromJson<int>(json['id']),
      distance: serializer.fromJson<double>(json['distance']),
      date: serializer.fromJson<String>(json['date']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'distance': serializer.toJson<double>(distance),
      'date': serializer.toJson<String>(date),
    };
  }

  Trip copyWith({int? id, double? distance, String? date}) => Trip(
    id: id ?? this.id,
    distance: distance ?? this.distance,
    date: date ?? this.date,
  );
  Trip copyWithCompanion(TripsCompanion data) {
    return Trip(
      id: data.id.present ? data.id.value : this.id,
      distance: data.distance.present ? data.distance.value : this.distance,
      date: data.date.present ? data.date.value : this.date,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Trip(')
          ..write('id: $id, ')
          ..write('distance: $distance, ')
          ..write('date: $date')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, distance, date);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Trip &&
          other.id == this.id &&
          other.distance == this.distance &&
          other.date == this.date);
}

class TripsCompanion extends UpdateCompanion<Trip> {
  final Value<int> id;
  final Value<double> distance;
  final Value<String> date;
  const TripsCompanion({
    this.id = const Value.absent(),
    this.distance = const Value.absent(),
    this.date = const Value.absent(),
  });
  TripsCompanion.insert({
    this.id = const Value.absent(),
    required double distance,
    required String date,
  }) : distance = Value(distance),
       date = Value(date);
  static Insertable<Trip> custom({
    Expression<int>? id,
    Expression<double>? distance,
    Expression<String>? date,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (distance != null) 'distance': distance,
      if (date != null) 'date': date,
    });
  }

  TripsCompanion copyWith({
    Value<int>? id,
    Value<double>? distance,
    Value<String>? date,
  }) {
    return TripsCompanion(
      id: id ?? this.id,
      distance: distance ?? this.distance,
      date: date ?? this.date,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (distance.present) {
      map['distance'] = Variable<double>(distance.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TripsCompanion(')
          ..write('id: $id, ')
          ..write('distance: $distance, ')
          ..write('date: $date')
          ..write(')'))
        .toString();
  }
}

class $FuelRecordsTable extends FuelRecords
    with TableInfo<$FuelRecordsTable, FuelRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FuelRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _fuelAmountMeta = const VerificationMeta(
    'fuelAmount',
  );
  @override
  late final GeneratedColumn<double> fuelAmount = GeneratedColumn<double>(
    'fuel_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalPriceMeta = const VerificationMeta(
    'totalPrice',
  );
  @override
  late final GeneratedColumn<double> totalPrice = GeneratedColumn<double>(
    'total_price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _refuelDateMeta = const VerificationMeta(
    'refuelDate',
  );
  @override
  late final GeneratedColumn<String> refuelDate = GeneratedColumn<String>(
    'refuel_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _calculatedFuelEconomyMeta =
      const VerificationMeta('calculatedFuelEconomy');
  @override
  late final GeneratedColumn<double> calculatedFuelEconomy =
      GeneratedColumn<double>(
        'calculated_fuel_economy',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    fuelAmount,
    totalPrice,
    refuelDate,
    calculatedFuelEconomy,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'fuel_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<FuelRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('fuel_amount')) {
      context.handle(
        _fuelAmountMeta,
        fuelAmount.isAcceptableOrUnknown(data['fuel_amount']!, _fuelAmountMeta),
      );
    } else if (isInserting) {
      context.missing(_fuelAmountMeta);
    }
    if (data.containsKey('total_price')) {
      context.handle(
        _totalPriceMeta,
        totalPrice.isAcceptableOrUnknown(data['total_price']!, _totalPriceMeta),
      );
    } else if (isInserting) {
      context.missing(_totalPriceMeta);
    }
    if (data.containsKey('refuel_date')) {
      context.handle(
        _refuelDateMeta,
        refuelDate.isAcceptableOrUnknown(data['refuel_date']!, _refuelDateMeta),
      );
    } else if (isInserting) {
      context.missing(_refuelDateMeta);
    }
    if (data.containsKey('calculated_fuel_economy')) {
      context.handle(
        _calculatedFuelEconomyMeta,
        calculatedFuelEconomy.isAcceptableOrUnknown(
          data['calculated_fuel_economy']!,
          _calculatedFuelEconomyMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FuelRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FuelRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      fuelAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fuel_amount'],
      )!,
      totalPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_price'],
      )!,
      refuelDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}refuel_date'],
      )!,
      calculatedFuelEconomy: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}calculated_fuel_economy'],
      ),
    );
  }

  @override
  $FuelRecordsTable createAlias(String alias) {
    return $FuelRecordsTable(attachedDatabase, alias);
  }
}

class FuelRecord extends DataClass implements Insertable<FuelRecord> {
  final int id;
  final double fuelAmount;
  final double totalPrice;
  final String refuelDate;
  final double? calculatedFuelEconomy;
  const FuelRecord({
    required this.id,
    required this.fuelAmount,
    required this.totalPrice,
    required this.refuelDate,
    this.calculatedFuelEconomy,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['fuel_amount'] = Variable<double>(fuelAmount);
    map['total_price'] = Variable<double>(totalPrice);
    map['refuel_date'] = Variable<String>(refuelDate);
    if (!nullToAbsent || calculatedFuelEconomy != null) {
      map['calculated_fuel_economy'] = Variable<double>(calculatedFuelEconomy);
    }
    return map;
  }

  FuelRecordsCompanion toCompanion(bool nullToAbsent) {
    return FuelRecordsCompanion(
      id: Value(id),
      fuelAmount: Value(fuelAmount),
      totalPrice: Value(totalPrice),
      refuelDate: Value(refuelDate),
      calculatedFuelEconomy: calculatedFuelEconomy == null && nullToAbsent
          ? const Value.absent()
          : Value(calculatedFuelEconomy),
    );
  }

  factory FuelRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FuelRecord(
      id: serializer.fromJson<int>(json['id']),
      fuelAmount: serializer.fromJson<double>(json['fuelAmount']),
      totalPrice: serializer.fromJson<double>(json['totalPrice']),
      refuelDate: serializer.fromJson<String>(json['refuelDate']),
      calculatedFuelEconomy: serializer.fromJson<double?>(
        json['calculatedFuelEconomy'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'fuelAmount': serializer.toJson<double>(fuelAmount),
      'totalPrice': serializer.toJson<double>(totalPrice),
      'refuelDate': serializer.toJson<String>(refuelDate),
      'calculatedFuelEconomy': serializer.toJson<double?>(
        calculatedFuelEconomy,
      ),
    };
  }

  FuelRecord copyWith({
    int? id,
    double? fuelAmount,
    double? totalPrice,
    String? refuelDate,
    Value<double?> calculatedFuelEconomy = const Value.absent(),
  }) => FuelRecord(
    id: id ?? this.id,
    fuelAmount: fuelAmount ?? this.fuelAmount,
    totalPrice: totalPrice ?? this.totalPrice,
    refuelDate: refuelDate ?? this.refuelDate,
    calculatedFuelEconomy: calculatedFuelEconomy.present
        ? calculatedFuelEconomy.value
        : this.calculatedFuelEconomy,
  );
  FuelRecord copyWithCompanion(FuelRecordsCompanion data) {
    return FuelRecord(
      id: data.id.present ? data.id.value : this.id,
      fuelAmount: data.fuelAmount.present
          ? data.fuelAmount.value
          : this.fuelAmount,
      totalPrice: data.totalPrice.present
          ? data.totalPrice.value
          : this.totalPrice,
      refuelDate: data.refuelDate.present
          ? data.refuelDate.value
          : this.refuelDate,
      calculatedFuelEconomy: data.calculatedFuelEconomy.present
          ? data.calculatedFuelEconomy.value
          : this.calculatedFuelEconomy,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FuelRecord(')
          ..write('id: $id, ')
          ..write('fuelAmount: $fuelAmount, ')
          ..write('totalPrice: $totalPrice, ')
          ..write('refuelDate: $refuelDate, ')
          ..write('calculatedFuelEconomy: $calculatedFuelEconomy')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    fuelAmount,
    totalPrice,
    refuelDate,
    calculatedFuelEconomy,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FuelRecord &&
          other.id == this.id &&
          other.fuelAmount == this.fuelAmount &&
          other.totalPrice == this.totalPrice &&
          other.refuelDate == this.refuelDate &&
          other.calculatedFuelEconomy == this.calculatedFuelEconomy);
}

class FuelRecordsCompanion extends UpdateCompanion<FuelRecord> {
  final Value<int> id;
  final Value<double> fuelAmount;
  final Value<double> totalPrice;
  final Value<String> refuelDate;
  final Value<double?> calculatedFuelEconomy;
  const FuelRecordsCompanion({
    this.id = const Value.absent(),
    this.fuelAmount = const Value.absent(),
    this.totalPrice = const Value.absent(),
    this.refuelDate = const Value.absent(),
    this.calculatedFuelEconomy = const Value.absent(),
  });
  FuelRecordsCompanion.insert({
    this.id = const Value.absent(),
    required double fuelAmount,
    required double totalPrice,
    required String refuelDate,
    this.calculatedFuelEconomy = const Value.absent(),
  }) : fuelAmount = Value(fuelAmount),
       totalPrice = Value(totalPrice),
       refuelDate = Value(refuelDate);
  static Insertable<FuelRecord> custom({
    Expression<int>? id,
    Expression<double>? fuelAmount,
    Expression<double>? totalPrice,
    Expression<String>? refuelDate,
    Expression<double>? calculatedFuelEconomy,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (fuelAmount != null) 'fuel_amount': fuelAmount,
      if (totalPrice != null) 'total_price': totalPrice,
      if (refuelDate != null) 'refuel_date': refuelDate,
      if (calculatedFuelEconomy != null)
        'calculated_fuel_economy': calculatedFuelEconomy,
    });
  }

  FuelRecordsCompanion copyWith({
    Value<int>? id,
    Value<double>? fuelAmount,
    Value<double>? totalPrice,
    Value<String>? refuelDate,
    Value<double?>? calculatedFuelEconomy,
  }) {
    return FuelRecordsCompanion(
      id: id ?? this.id,
      fuelAmount: fuelAmount ?? this.fuelAmount,
      totalPrice: totalPrice ?? this.totalPrice,
      refuelDate: refuelDate ?? this.refuelDate,
      calculatedFuelEconomy:
          calculatedFuelEconomy ?? this.calculatedFuelEconomy,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (fuelAmount.present) {
      map['fuel_amount'] = Variable<double>(fuelAmount.value);
    }
    if (totalPrice.present) {
      map['total_price'] = Variable<double>(totalPrice.value);
    }
    if (refuelDate.present) {
      map['refuel_date'] = Variable<String>(refuelDate.value);
    }
    if (calculatedFuelEconomy.present) {
      map['calculated_fuel_economy'] = Variable<double>(
        calculatedFuelEconomy.value,
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FuelRecordsCompanion(')
          ..write('id: $id, ')
          ..write('fuelAmount: $fuelAmount, ')
          ..write('totalPrice: $totalPrice, ')
          ..write('refuelDate: $refuelDate, ')
          ..write('calculatedFuelEconomy: $calculatedFuelEconomy')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $VehicleSettingsTable vehicleSettings = $VehicleSettingsTable(
    this,
  );
  late final $TripsTable trips = $TripsTable(this);
  late final $FuelRecordsTable fuelRecords = $FuelRecordsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    vehicleSettings,
    trips,
    fuelRecords,
  ];
}

typedef $$VehicleSettingsTableCreateCompanionBuilder =
    VehicleSettingsCompanion Function({
      Value<int> id,
      required double tankCapacity,
      required double manualFuelEconomy,
    });
typedef $$VehicleSettingsTableUpdateCompanionBuilder =
    VehicleSettingsCompanion Function({
      Value<int> id,
      Value<double> tankCapacity,
      Value<double> manualFuelEconomy,
    });

class $$VehicleSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $VehicleSettingsTable> {
  $$VehicleSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get tankCapacity => $composableBuilder(
    column: $table.tankCapacity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get manualFuelEconomy => $composableBuilder(
    column: $table.manualFuelEconomy,
    builder: (column) => ColumnFilters(column),
  );
}

class $$VehicleSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $VehicleSettingsTable> {
  $$VehicleSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get tankCapacity => $composableBuilder(
    column: $table.tankCapacity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get manualFuelEconomy => $composableBuilder(
    column: $table.manualFuelEconomy,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$VehicleSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $VehicleSettingsTable> {
  $$VehicleSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get tankCapacity => $composableBuilder(
    column: $table.tankCapacity,
    builder: (column) => column,
  );

  GeneratedColumn<double> get manualFuelEconomy => $composableBuilder(
    column: $table.manualFuelEconomy,
    builder: (column) => column,
  );
}

class $$VehicleSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $VehicleSettingsTable,
          VehicleSetting,
          $$VehicleSettingsTableFilterComposer,
          $$VehicleSettingsTableOrderingComposer,
          $$VehicleSettingsTableAnnotationComposer,
          $$VehicleSettingsTableCreateCompanionBuilder,
          $$VehicleSettingsTableUpdateCompanionBuilder,
          (
            VehicleSetting,
            BaseReferences<
              _$AppDatabase,
              $VehicleSettingsTable,
              VehicleSetting
            >,
          ),
          VehicleSetting,
          PrefetchHooks Function()
        > {
  $$VehicleSettingsTableTableManager(
    _$AppDatabase db,
    $VehicleSettingsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VehicleSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VehicleSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VehicleSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<double> tankCapacity = const Value.absent(),
                Value<double> manualFuelEconomy = const Value.absent(),
              }) => VehicleSettingsCompanion(
                id: id,
                tankCapacity: tankCapacity,
                manualFuelEconomy: manualFuelEconomy,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required double tankCapacity,
                required double manualFuelEconomy,
              }) => VehicleSettingsCompanion.insert(
                id: id,
                tankCapacity: tankCapacity,
                manualFuelEconomy: manualFuelEconomy,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$VehicleSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $VehicleSettingsTable,
      VehicleSetting,
      $$VehicleSettingsTableFilterComposer,
      $$VehicleSettingsTableOrderingComposer,
      $$VehicleSettingsTableAnnotationComposer,
      $$VehicleSettingsTableCreateCompanionBuilder,
      $$VehicleSettingsTableUpdateCompanionBuilder,
      (
        VehicleSetting,
        BaseReferences<_$AppDatabase, $VehicleSettingsTable, VehicleSetting>,
      ),
      VehicleSetting,
      PrefetchHooks Function()
    >;
typedef $$TripsTableCreateCompanionBuilder =
    TripsCompanion Function({
      Value<int> id,
      required double distance,
      required String date,
    });
typedef $$TripsTableUpdateCompanionBuilder =
    TripsCompanion Function({
      Value<int> id,
      Value<double> distance,
      Value<String> date,
    });

class $$TripsTableFilterComposer extends Composer<_$AppDatabase, $TripsTable> {
  $$TripsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get distance => $composableBuilder(
    column: $table.distance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TripsTableOrderingComposer
    extends Composer<_$AppDatabase, $TripsTable> {
  $$TripsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get distance => $composableBuilder(
    column: $table.distance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TripsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TripsTable> {
  $$TripsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get distance =>
      $composableBuilder(column: $table.distance, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);
}

class $$TripsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TripsTable,
          Trip,
          $$TripsTableFilterComposer,
          $$TripsTableOrderingComposer,
          $$TripsTableAnnotationComposer,
          $$TripsTableCreateCompanionBuilder,
          $$TripsTableUpdateCompanionBuilder,
          (Trip, BaseReferences<_$AppDatabase, $TripsTable, Trip>),
          Trip,
          PrefetchHooks Function()
        > {
  $$TripsTableTableManager(_$AppDatabase db, $TripsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TripsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TripsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TripsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<double> distance = const Value.absent(),
                Value<String> date = const Value.absent(),
              }) => TripsCompanion(id: id, distance: distance, date: date),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required double distance,
                required String date,
              }) =>
                  TripsCompanion.insert(id: id, distance: distance, date: date),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TripsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TripsTable,
      Trip,
      $$TripsTableFilterComposer,
      $$TripsTableOrderingComposer,
      $$TripsTableAnnotationComposer,
      $$TripsTableCreateCompanionBuilder,
      $$TripsTableUpdateCompanionBuilder,
      (Trip, BaseReferences<_$AppDatabase, $TripsTable, Trip>),
      Trip,
      PrefetchHooks Function()
    >;
typedef $$FuelRecordsTableCreateCompanionBuilder =
    FuelRecordsCompanion Function({
      Value<int> id,
      required double fuelAmount,
      required double totalPrice,
      required String refuelDate,
      Value<double?> calculatedFuelEconomy,
    });
typedef $$FuelRecordsTableUpdateCompanionBuilder =
    FuelRecordsCompanion Function({
      Value<int> id,
      Value<double> fuelAmount,
      Value<double> totalPrice,
      Value<String> refuelDate,
      Value<double?> calculatedFuelEconomy,
    });

class $$FuelRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $FuelRecordsTable> {
  $$FuelRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fuelAmount => $composableBuilder(
    column: $table.fuelAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalPrice => $composableBuilder(
    column: $table.totalPrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get refuelDate => $composableBuilder(
    column: $table.refuelDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get calculatedFuelEconomy => $composableBuilder(
    column: $table.calculatedFuelEconomy,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FuelRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $FuelRecordsTable> {
  $$FuelRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fuelAmount => $composableBuilder(
    column: $table.fuelAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalPrice => $composableBuilder(
    column: $table.totalPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get refuelDate => $composableBuilder(
    column: $table.refuelDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get calculatedFuelEconomy => $composableBuilder(
    column: $table.calculatedFuelEconomy,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FuelRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FuelRecordsTable> {
  $$FuelRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get fuelAmount => $composableBuilder(
    column: $table.fuelAmount,
    builder: (column) => column,
  );

  GeneratedColumn<double> get totalPrice => $composableBuilder(
    column: $table.totalPrice,
    builder: (column) => column,
  );

  GeneratedColumn<String> get refuelDate => $composableBuilder(
    column: $table.refuelDate,
    builder: (column) => column,
  );

  GeneratedColumn<double> get calculatedFuelEconomy => $composableBuilder(
    column: $table.calculatedFuelEconomy,
    builder: (column) => column,
  );
}

class $$FuelRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FuelRecordsTable,
          FuelRecord,
          $$FuelRecordsTableFilterComposer,
          $$FuelRecordsTableOrderingComposer,
          $$FuelRecordsTableAnnotationComposer,
          $$FuelRecordsTableCreateCompanionBuilder,
          $$FuelRecordsTableUpdateCompanionBuilder,
          (
            FuelRecord,
            BaseReferences<_$AppDatabase, $FuelRecordsTable, FuelRecord>,
          ),
          FuelRecord,
          PrefetchHooks Function()
        > {
  $$FuelRecordsTableTableManager(_$AppDatabase db, $FuelRecordsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FuelRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FuelRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FuelRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<double> fuelAmount = const Value.absent(),
                Value<double> totalPrice = const Value.absent(),
                Value<String> refuelDate = const Value.absent(),
                Value<double?> calculatedFuelEconomy = const Value.absent(),
              }) => FuelRecordsCompanion(
                id: id,
                fuelAmount: fuelAmount,
                totalPrice: totalPrice,
                refuelDate: refuelDate,
                calculatedFuelEconomy: calculatedFuelEconomy,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required double fuelAmount,
                required double totalPrice,
                required String refuelDate,
                Value<double?> calculatedFuelEconomy = const Value.absent(),
              }) => FuelRecordsCompanion.insert(
                id: id,
                fuelAmount: fuelAmount,
                totalPrice: totalPrice,
                refuelDate: refuelDate,
                calculatedFuelEconomy: calculatedFuelEconomy,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FuelRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FuelRecordsTable,
      FuelRecord,
      $$FuelRecordsTableFilterComposer,
      $$FuelRecordsTableOrderingComposer,
      $$FuelRecordsTableAnnotationComposer,
      $$FuelRecordsTableCreateCompanionBuilder,
      $$FuelRecordsTableUpdateCompanionBuilder,
      (
        FuelRecord,
        BaseReferences<_$AppDatabase, $FuelRecordsTable, FuelRecord>,
      ),
      FuelRecord,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$VehicleSettingsTableTableManager get vehicleSettings =>
      $$VehicleSettingsTableTableManager(_db, _db.vehicleSettings);
  $$TripsTableTableManager get trips =>
      $$TripsTableTableManager(_db, _db.trips);
  $$FuelRecordsTableTableManager get fuelRecords =>
      $$FuelRecordsTableTableManager(_db, _db.fuelRecords);
}
