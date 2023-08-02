class QuotationDetailsModel {
  QuotationDetailsModel({
    this.quotationDetails,
  });

  QuotationDetailsModel.fromJson(dynamic json) {
    quotationDetails = json['quotationDetails'] != null
        ? QuotationDetails.fromJson(json['quotationDetails'])
        : null;
  }
  QuotationDetails? quotationDetails;
  QuotationDetailsModel copyWith({
    QuotationDetails? quotationDetails,
  }) =>
      QuotationDetailsModel(
        quotationDetails: quotationDetails ?? this.quotationDetails,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (quotationDetails != null) {
      map['quotationDetails'] = quotationDetails?.toJson();
    }
    return map;
  }
}

class QuotationDetails {
  QuotationDetails({
    this.from,
    this.to,
    this.qreID,
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
    this.due,
    this.paidStatus,
    this.advance,
    this.pdfLink,
    this.vfdLink,
    this.vfdCode,
    this.TIN,
    this.pBox,
    this.WEB,
    this.bEmail,
    this.tel,
    this.vrn,
  });

  QuotationDetails.fromJson(dynamic json) {
    from = json['from'];
    to = json['to'];
    qreID = json['qreID'];
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
    paidStatus = json['paidStatus'];
    advance = json['advance'];
    returnDate = json['returnDate '];
    pdfLink = json['pdf_link'];
    vfdLink = json['vfdLink'];
    vfdCode = json['vfdCode'];
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
    subtotal = json['subtotal'] != null
        ? double.parse(json['subtotal'].toStringAsFixed(2))
        : null;
    discount = json['discount'] != null
        ? double.parse(json['discount'].toStringAsFixed(2))
        : null;
    paid = json['paid'] != null
        ? double.parse(json['paid'].toStringAsFixed(2))
        : null;
    due = json['due'] != null
        ? double.parse(json['due'].toStringAsFixed(2))
        : null;
  }
  String? from;
  String? to;
  String? qreID;
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
  String? pdfLink;
  String? vfdLink;
  String? vfdCode;
  String? TIN;
  String? pBox;
  String? WEB;
  String? tel;
  String? vrn;
  String? bEmail;
  List<FleetDetails>? fleetDetails;
  double? subtotal;
  double? discount;
  double? paid;
  double? due;
  num? paidStatus;
  num? advance;
  QuotationDetails copyWith({
    String? from,
    String? to,
    String? qreID,
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
    String? pdfLink,
    List<FleetDetails>? fleetDetails,
    double? subtotal,
    double? discount,
    double? paid,
    num? paidStatus,
  }) =>
      QuotationDetails(
        from: from ?? this.from,
        to: to ?? this.to,
        qreID: qreID ?? this.qreID,
        reID: qreID ?? this.reID,
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
        paidStatus: paidStatus ?? this.paidStatus,
        pdfLink: pdfLink ?? this.pdfLink,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['from'] = from;
    map['to'] = to;
    map['qreID'] = qreID;
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
    map['pdf_link '] = pdfLink;
    if (fleetDetails != null) {
      map['fleetDetails'] = fleetDetails?.map((v) => v.toJson()).toList();
    }
    map['subtotal'] = subtotal.toString();
    map['discount'] = discount.toString();
    map['paid'] = paid.toString();
    map['paidStatus'] = paidStatus.toString();
    return map;
  }
}

class FleetDetails {
  FleetDetails({
    this.rfID,
    this.fleetType,
    this.coachTitle,
    this.coachID,
    this.ftID,
    this.fleetMakers,
    this.fmID,
    this.seatTemplate,
    this.stID,
    this.rent,
  });

  FleetDetails.fromJson(dynamic json) {
    rfID = json['rfID'];
    fleetType = json['fleetType'];
    coachID = json['coachID'];
    coachTitle = json['coachTitle'];
    ftID = json['ftID'];
    fleetMakers = json['fleetMakers'];
    fmID = json['fmID'];
    seatTemplate = json['seatTemplate'];
    stID = json['stID'];
    rent = json['rent'] != null
        ? double.parse(json['rent'].toStringAsFixed(2))
        : null;
  }
  String? rfID;
  String? fleetType;
  String? coachID;
  String? coachTitle;
  String? ftID;
  String? fleetMakers;
  String? fmID;
  String? seatTemplate;
  String? stID;
  double? rent;
  FleetDetails copyWith({
    String? rfID,
    String? fleetType,
    String? coachID,
    String? coachTitle,
    String? ftID,
    String? fleetMakers,
    String? fmID,
    String? seatTemplate,
    String? stID,
    double? rent,
  }) =>
      FleetDetails(
        rfID: rfID ?? this.rfID,
        fleetType: fleetType ?? this.fleetType,
        coachTitle: coachTitle ?? this.coachTitle,
        coachID: coachID ?? this.coachID,
        ftID: ftID ?? this.ftID,
        fleetMakers: fleetMakers ?? this.fleetMakers,
        fmID: fmID ?? this.fmID,
        seatTemplate: seatTemplate ?? this.seatTemplate,
        stID: stID ?? this.stID,
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
    map['rent'] = rent.toString();
    return map;
  }
}
