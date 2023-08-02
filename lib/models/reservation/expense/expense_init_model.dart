class ExpenseInitModel {
  ExpenseInitModel({
    this.id,
    this.route,
    this.reservationFleets,
    this.fleets,
    this.staff,
  });

  ExpenseInitModel.fromJson(dynamic json) {
    id = json['id'];
    route = json['route'];
    if (json['reservationFleets'] != null) {
      reservationFleets = [];
      json['reservationFleets'].forEach((v) {
        reservationFleets?.add(ReservationFleets.fromJson(v));
      });
    }
    if (json['fleets'] != null) {
      fleets = [];
      json['fleets'].forEach((v) {
        fleets?.add(Fleets.fromJson(v));
      });
    }
    if (json['staff'] != null) {
      staff = [];
      json['staff'].forEach((v) {
        staff?.add(Staff.fromJson(v));
      });
    }
  }
  String? id;
  String? route;
  List<ReservationFleets>? reservationFleets;
  List<Fleets>? fleets;
  List<Staff>? staff;
  ExpenseInitModel copyWith({
    String? id,
    String? route,
    List<ReservationFleets>? reservationFleets,
    List<Fleets>? fleets,
    List<Staff>? staff,
  }) =>
      ExpenseInitModel(
        id: id ?? this.id,
        route: route ?? this.route,
        reservationFleets: reservationFleets ?? this.reservationFleets,
        fleets: fleets ?? this.fleets,
        staff: staff ?? this.staff,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['route'] = route;
    if (reservationFleets != null) {
      map['reservationFleets'] =
          reservationFleets?.map((v) => v.toJson()).toList();
    }
    if (fleets != null) {
      map['fleets'] = fleets?.map((v) => v.toJson()).toList();
    }
    if (staff != null) {
      map['staff'] = staff?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Staff {
  static const String typeDriver = '1';
  static const String typeGuide = '2';
  static const String typeHelper = '3';
  Staff({
    this.sID,
    this.sType,
    this.sName,
  });

  Staff.fromJson(dynamic json) {
    sID = json['sID'];
    sType = json['sType'];
    sName = json['sName'];
  }
  String? sID;
  String? sType;
  String? sName;
  bool isAvailable = true;
  Staff copyWith({
    String? sID,
    String? sType,
    String? sName,
  }) =>
      Staff(
        sID: sID ?? this.sID,
        sType: sType ?? this.sType,
        sName: sName ?? this.sName,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['sID'] = sID;
    map['sType'] = sType;
    map['sName'] = sName;
    return map;
  }

  @override
  String toString() {
    return sName ?? '';
  }
}

class Fleets {
  Fleets({
    this.fID,
    this.fRegNo,
  });

  Fleets.fromJson(dynamic json) {
    fID = json['fID'];
    fRegNo = json['fRegNo'];
  }
  String? fID;
  String? fRegNo;
  bool isAvailable = true;
  Fleets copyWith({
    String? fID,
    String? fRegNo,
  }) =>
      Fleets(
        fID: fID ?? this.fID,
        fRegNo: fRegNo ?? this.fRegNo,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['fID'] = fID;
    map['fRegNo'] = fRegNo;
    return map;
  }

  @override
  String toString() {
    return fRegNo ?? '';
  }
}

class ReservationFleets {
  ReservationFleets({
    this.rfID,
    this.fleet,
    this.driver,
    this.driverAmount,
    this.helper,
    this.helperAmount,
    this.guide,
    this.guideAmount,
    this.remarks,
  });

  ReservationFleets.fromJson(dynamic json) {
    rfID = json['rfID'];
    fleet = json['fleet'];
    driver = json['driver'];
    driverAmount = json['driverAmount'];
    helper = json['helper'];
    helperAmount = json['helperAmount'];
    guide = json['guide'];
    guideAmount = json['guideAmount'];
    remarks = json['remarks'];
  }
  String? rfID;
  String? fleet;
  String? driver;
  num? driverAmount;
  String? helper;
  num? helperAmount;
  String? guide;
  num? guideAmount;
  String? remarks;
  ReservationFleets copyWith({
    String? rfID,
    String? fleet,
    String? driver,
    num? driverAmount,
    String? helper,
    num? helperAmount,
    String? guide,
    num? guideAmount,
    String? remarks,
  }) =>
      ReservationFleets(
        rfID: rfID ?? this.rfID,
        fleet: fleet ?? this.fleet,
        driver: driver ?? this.driver,
        driverAmount: driverAmount ?? this.driverAmount,
        helper: helper ?? this.helper,
        helperAmount: helperAmount ?? this.helperAmount,
        guide: guide ?? this.guide,
        guideAmount: guideAmount ?? this.guideAmount,
        remarks: remarks ?? this.remarks,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['rfID'] = rfID;
    map['fleet'] = fleet;
    map['driver'] = driver;
    map['driverAmount'] = driverAmount;
    map['helper'] = helper;
    map['helperAmount'] = helperAmount;
    map['guide'] = guide;
    map['guideAmount'] = guideAmount;
    map['remarks'] = remarks;
    return map;
  }
}
