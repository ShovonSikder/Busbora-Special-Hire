class QuotationBriefModel {
  QuotationBriefModel({
    this.reservationQuotationList,
  });

  QuotationBriefModel.fromJson(dynamic json) {
    if (json['reservationQuotation'] != null) {
      reservationQuotationList = [];
      json['reservationQuotation'].forEach((v) {
        reservationQuotationList?.add(ReservationQuotation.fromJson(v));
      });
    }
  }
  List<ReservationQuotation>? reservationQuotationList;
  QuotationBriefModel copyWith({
    List<ReservationQuotation>? reservationQuotation,
  }) =>
      QuotationBriefModel(
        reservationQuotationList:
            reservationQuotation ?? reservationQuotationList,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (reservationQuotationList != null) {
      map['reservationQuotation'] =
          reservationQuotationList?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class ReservationQuotation {
  ReservationQuotation({
    this.reID,
    this.qreID,
    this.id,
    this.jDate,
    this.rDate,
    this.route,
    this.company,
    this.contPerson,
    this.mobile,
    this.type,
    this.totalAmount,
    this.payAmount,
    this.dueAmount,
    this.paidStatus,
  });

  ReservationQuotation.fromJson(dynamic json) {
    //for quotation list
    qreID = json['qreID'];

    //for reservation list
    reID = json['reID'];
    id = json['id'];
    jDate = json['jDate'];
    rDate = json['rDate'];
    route = json['route'];
    company = json['company'];
    contPerson = json['contPerson'];
    mobile = json['mobile'];
    type = json['type'];
    paidStatus = json['paidStatus'];
    totalAmount = json['totalAmount'] != null
        ? double.parse(json['totalAmount'].toStringAsFixed(2))
        : null;
    dueAmount = json['dueAmount'] != null
        ? double.parse(json['dueAmount'].toStringAsFixed(2))
        : null;
    payAmount = json['payAmount'] != null
        ? double.parse(json['payAmount'].toStringAsFixed(2))
        : null;
  }
  String? reID;
  String? qreID;
  String? id;
  String? jDate;
  String? rDate;
  String? route;
  String? company;
  String? contPerson;
  String? mobile;
  String? type;
  double? totalAmount;
  double? payAmount;
  double? dueAmount;
  num? paidStatus;

  ReservationQuotation copyWith({
    String? reID,
    String? qreID,
    String? id,
    String? jDate,
    String? rDate,
    String? route,
    String? company,
    String? contPerson,
    String? mobile,
    String? type,
    double? totalAmount,
    double? payAmount,
    double? dueAmount,
    num? paidStatus,
  }) =>
      ReservationQuotation(
        reID: reID ?? this.reID,
        qreID: qreID ?? this.qreID,
        id: id ?? this.id,
        jDate: jDate ?? this.jDate,
        rDate: rDate ?? this.rDate,
        route: route ?? this.route,
        company: company ?? this.company,
        contPerson: contPerson ?? this.contPerson,
        mobile: mobile ?? this.mobile,
        type: type ?? this.type,
        totalAmount: totalAmount ?? this.totalAmount,
        dueAmount: dueAmount ?? this.dueAmount,
        payAmount: payAmount ?? this.payAmount,
        paidStatus: paidStatus ?? this.paidStatus,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['reID'] = reID;
    map['qreID'] = qreID;
    map['id'] = id;
    map['jDate'] = jDate;
    map['rDate'] = rDate;
    map['route'] = route;
    map['company'] = company;
    map['contPerson'] = contPerson;
    map['mobile'] = mobile;
    map['type'] = type;
    map['payAmount'] = payAmount;
    map['totalAmount'] = totalAmount;
    map['dueAmount'] = dueAmount;
    map['paidStatus'] = paidStatus;

    return map;
  }
}
