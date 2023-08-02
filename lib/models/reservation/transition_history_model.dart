class TransitionHistoryModel {
  TransitionHistoryModel({
    this.reReservationId,
    this.reContPerson,
    this.history,
    this.TIN,
    this.pBox,
    this.WEB,
    this.email,
    this.tel,
    this.vrn,
    this.vfdLink,
    this.vfdCode,
  });

  TransitionHistoryModel.fromJson(dynamic json) {
    reReservationId = json['reReservationId'];
    reContPerson = json['reContPerson'];
    TIN = json['TIN'];
    pBox = json['pBox'];
    WEB = json['WEB'];
    email = json['bEmail'];
    tel = json['tel'];
    vrn = json['vrn'];
    vfdLink = json['vfdLink'];
    vfdCode = json['vfdCode'];
    if (json['history'] != null) {
      history = [];
      json['history'].forEach((v) {
        history?.add(History.fromJson(v));
      });
    }
  }
  String? reReservationId;
  String? reContPerson;
  String? TIN;
  String? pBox;
  String? WEB;
  String? tel;
  String? vrn;
  String? email;
  String? vfdCode;
  String? vfdLink;
  List<History>? history;
  TransitionHistoryModel copyWith({
    String? reReservationId,
    String? reContPerson,
    List<History>? history,
  }) =>
      TransitionHistoryModel(
        reReservationId: reReservationId ?? this.reReservationId,
        reContPerson: reContPerson ?? this.reContPerson,
        history: history ?? this.history,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['reReservationId'] = reReservationId;
    map['reContPerson'] = reContPerson;
    if (history != null) {
      map['history'] = history?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class History {
  History({
    this.date,
    this.time,
    this.p,
    this.user,
    this.amount,
    this.due,
    this.totalPay,
  });

  History.fromJson(dynamic json) {
    date = json['date'];
    time = json['time'];
    p = json['p'];
    user = json['user'];
    amount = json['amount'] != null
        ? double.parse(json['amount'].toStringAsFixed(2))
        : null;
    totalPay = json['totalPay'] != null
        ? double.parse(json['totalPay'].toStringAsFixed(2))
        : null;
    due = json['due'] != null
        ? double.parse(json['due'].toStringAsFixed(2))
        : null;
  }
  String? date;
  String? time;
  String? p;
  String? user;
  double? amount;
  double? due;
  double? totalPay;
  History copyWith({
    String? date,
    String? time,
    String? p,
    String? user,
    double? amount,
  }) =>
      History(
        date: date ?? this.date,
        time: time ?? this.time,
        p: p ?? this.p,
        user: user ?? this.user,
        amount: amount ?? this.amount,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['date'] = date;
    map['time'] = time;
    map['p'] = p;
    map['user'] = user;
    map['amount'] = amount.toString();
    return map;
  }
}
