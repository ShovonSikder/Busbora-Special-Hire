class RSheetModel {
  RSheetModel({
    this.reservationDetails,
  });

  RSheetModel.fromJson(dynamic json) {
    reservationDetails = json['reservationDetails'] != null
        ? ReservationDetails.fromJson(json['reservationDetails'])
        : null;
  }
  ReservationDetails? reservationDetails;
  RSheetModel copyWith({
    ReservationDetails? reservationDetails,
  }) =>
      RSheetModel(
        reservationDetails: reservationDetails ?? this.reservationDetails,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (reservationDetails != null) {
      map['reservationDetails'] = reservationDetails?.toJson();
    }
    return map;
  }
}

class ReservationDetails {
  ReservationDetails({
    this.from,
    this.to,
    this.reID,
    this.id,
    this.company,
    this.companyMobile,
    this.contactPerson,
    this.mobile,
    this.address,
    this.email,
    this.remarks,
    this.origin,
    this.destination,
    this.pickUp,
    this.dropping,
    this.journeyDate,
    this.type,
    this.returnDate,
    this.fleetDetails,
    this.subtotal,
    this.discount,
    this.paid,
    this.TIN,
    this.pBox,
    this.WEB,
    this.bEmail,
    this.tel,
    this.vrn,
  });

  ReservationDetails.fromJson(dynamic json) {
    from = json['from'];
    to = json['to'];
    reID = json['reID'];
    id = json['id'];
    company = json['company'];
    companyMobile = json['companyMobile'];
    contactPerson = json['contactPerson'];
    mobile = json['mobile'];
    address = json['address'];
    email = json['email'];
    remarks = json['remarks'];
    origin = json['origin'];
    destination = json['destination'];
    pickUp = json['pickUp '];
    dropping = json['dropping '];
    journeyDate = json['journeyDate '];
    type = json['type'];
    returnDate = json['returnDate '];
    TIN = json['TIN'];
    pBox = json['pBox'];
    WEB = json['WEB'];
    bEmail = json['bEmail'];
    tel = json['tel'];
    vrn = json['vrn'];
    if (json['fleetDetails'] != null) {
      fleetDetails = [];
      json['fleetDetails'].forEach((v) {
        fleetDetails?.add(FleetDetails.fromJson(v));
      });
    }
    subtotal = json['subtotal'];
    discount = json['discount'];
    paid = json['paid'];
  }
  String? from;
  String? to;
  String? reID;
  String? id;
  String? company;
  String? companyMobile;
  String? contactPerson;
  String? mobile;
  String? address;
  String? email;
  String? remarks;
  String? origin;
  String? destination;
  String? pickUp;
  String? dropping;
  String? journeyDate;
  String? type;
  String? returnDate;
  String? TIN;
  String? pBox;
  String? WEB;
  String? tel;
  String? vrn;
  String? bEmail;
  List<FleetDetails>? fleetDetails;
  num? subtotal;
  num? discount;
  num? paid;
  ReservationDetails copyWith({
    String? from,
    String? to,
    String? reID,
    String? id,
    String? company,
    String? companyMobile,
    String? contactPerson,
    String? mobile,
    String? address,
    String? email,
    String? remarks,
    String? origin,
    String? destination,
    String? pickUp,
    String? dropping,
    String? journeyDate,
    String? type,
    String? returnDate,
    List<FleetDetails>? fleetDetails,
    num? subtotal,
    num? discount,
    num? paid,
  }) =>
      ReservationDetails(
        from: from ?? this.from,
        to: to ?? this.to,
        reID: reID ?? this.reID,
        id: id ?? this.id,
        company: company ?? this.company,
        companyMobile: companyMobile ?? this.companyMobile,
        contactPerson: contactPerson ?? this.contactPerson,
        mobile: mobile ?? this.mobile,
        address: address ?? this.address,
        email: email ?? this.email,
        remarks: remarks ?? this.remarks,
        origin: origin ?? this.origin,
        destination: destination ?? this.destination,
        pickUp: pickUp ?? this.pickUp,
        dropping: dropping ?? this.dropping,
        journeyDate: journeyDate ?? this.journeyDate,
        type: type ?? this.type,
        returnDate: returnDate ?? this.returnDate,
        fleetDetails: fleetDetails ?? this.fleetDetails,
        subtotal: subtotal ?? this.subtotal,
        discount: discount ?? this.discount,
        paid: paid ?? this.paid,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['from'] = from;
    map['to'] = to;
    map['reID'] = reID;
    map['id'] = id;
    map['company'] = company;
    map['companyMobile'] = companyMobile;
    map['contactPerson'] = contactPerson;
    map['mobile'] = mobile;
    map['address'] = address;
    map['email'] = email;
    map['remarks'] = remarks;
    map['origin'] = origin;
    map['destination'] = destination;
    map['pickUp '] = pickUp;
    map['dropping '] = dropping;
    map['journeyDate '] = journeyDate;
    map['type'] = type;
    map['returnDate '] = returnDate;
    if (fleetDetails != null) {
      map['fleetDetails'] = fleetDetails?.map((v) => v.toJson()).toList();
    }
    map['subtotal'] = subtotal;
    map['discount'] = discount;
    map['paid'] = paid;
    return map;
  }
}

class FleetDetails {
  FleetDetails({
    this.rfID,
    this.fleetType,
    this.ftID,
    this.fleetMakers,
    this.fmID,
    this.seatTemplate,
    this.stID,
    this.fleet,
    this.driver,
    this.helper,
    this.guide,
    this.passengers,
    this.remarks,
    this.rent,
  });

  FleetDetails.fromJson(dynamic json) {
    rfID = json['rfID'];
    fleetType = json['fleetType'];
    ftID = json['ftID'];
    fleetMakers = json['fleetMakers'];
    fmID = json['fmID'];
    seatTemplate = json['seatTemplate'];
    stID = json['stID'];
    fleet = json['fleet'];
    driver = json['driver'];
    helper = json['helper'];
    guide = json['guide'];
    if (json['passengers'] != null) {
      passengers = [];
      json['passengers'].forEach((v) {
        passengers?.add(Passengers.fromJson(v));
      });
    }
    remarks = json['remarks'];
    rent = json['rent'];
  }
  String? rfID;
  String? fleetType;
  String? ftID;
  String? fleetMakers;
  String? fmID;
  String? seatTemplate;
  String? stID;
  String? fleet;
  String? driver;
  String? helper;
  String? guide;
  List<Passengers>? passengers;
  String? remarks;
  num? rent;
  FleetDetails copyWith({
    String? rfID,
    String? fleetType,
    String? ftID,
    String? fleetMakers,
    String? fmID,
    String? seatTemplate,
    String? stID,
    String? fleet,
    String? driver,
    String? helper,
    String? guide,
    List<Passengers>? passengers,
    String? remarks,
    num? rent,
  }) =>
      FleetDetails(
        rfID: rfID ?? this.rfID,
        fleetType: fleetType ?? this.fleetType,
        ftID: ftID ?? this.ftID,
        fleetMakers: fleetMakers ?? this.fleetMakers,
        fmID: fmID ?? this.fmID,
        seatTemplate: seatTemplate ?? this.seatTemplate,
        stID: stID ?? this.stID,
        fleet: fleet ?? this.fleet,
        driver: driver ?? this.driver,
        helper: helper ?? this.helper,
        guide: guide ?? this.guide,
        passengers: passengers ?? this.passengers,
        remarks: remarks ?? this.remarks,
        rent: rent ?? this.rent,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['rfID'] = rfID;
    map['fleetType'] = fleetType;
    map['ftID'] = ftID;
    map['fleetMakers'] = fleetMakers;
    map['fmID'] = fmID;
    map['seatTemplate'] = seatTemplate;
    map['stID'] = stID;
    map['fleet'] = fleet;
    map['driver'] = driver;
    map['helper'] = helper;
    map['guide'] = guide;
    if (passengers != null) {
      map['passengers'] = passengers?.map((v) => v.toJson()).toList();
    }
    map['remarks'] = remarks;
    map['rent'] = rent;
    return map;
  }
}

class Passengers {
  Passengers({
    this.id,
    this.seatName,
    this.name,
    this.number,
    this.passengerType,
  });

  Passengers.fromJson(dynamic json) {
    id = json['id'];
    seatName = json['seatName'];
    name = json['name'];
    number = json['number'];
    passengerType = json['passengerType'];
  }
  String? id;
  String? seatName;
  String? name;
  String? number;
  String? passengerType;
  Passengers copyWith({
    String? id,
    String? seatName,
    String? name,
    String? number,
    String? passengerType,
  }) =>
      Passengers(
        id: id ?? this.id,
        seatName: seatName ?? this.seatName,
        name: name ?? this.name,
        number: number ?? this.number,
        passengerType: passengerType ?? this.passengerType,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['seatName'] = seatName;
    map['name'] = name;
    map['number'] = number;
    map['passengerType'] = passengerType;
    return map;
  }
}
