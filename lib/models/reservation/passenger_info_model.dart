class PassengerInfoModel {
  PassengerInfoModel({
    this.ticketFairType,
    this.passengerInfo,
  });

  PassengerInfoModel.fromJson(dynamic json) {
    if (json['ticketFairType'] != null) {
      ticketFairType = [];
      json['ticketFairType'].forEach((v) {
        ticketFairType?.add(TicketFairType.fromJson(v));
      });
    }
    if (json['passengerInfo'] != null) {
      passengerInfo = [];
      json['passengerInfo'].forEach((v) {
        passengerInfo?.add(PassengerInfo.fromJson(v));
      });
    }
  }
  List<TicketFairType>? ticketFairType;
  List<PassengerInfo>? passengerInfo;
  PassengerInfoModel copyWith({
    List<TicketFairType>? ticketFairType,
    List<PassengerInfo>? passengerInfo,
  }) =>
      PassengerInfoModel(
        ticketFairType: ticketFairType ?? this.ticketFairType,
        passengerInfo: passengerInfo ?? this.passengerInfo,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (ticketFairType != null) {
      map['ticketFairType'] = ticketFairType?.map((v) => v.toJson()).toList();
    }
    if (passengerInfo != null) {
      map['passengerInfo'] = passengerInfo?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class PassengerInfo {
  PassengerInfo({
    this.id,
    this.seatName,
    this.name,
    this.number,
    this.tftID,
  });

  PassengerInfo.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    number = json['number'];
    tftID = json['tftID'];
    seatName = json['seatName'];
  }
  String? id;
  String? seatName;
  String? name;
  String? number;
  String? tftID;
  PassengerInfo copyWith({
    String? id,
    String? seatName,
    String? name,
    String? number,
    String? tftID,
  }) =>
      PassengerInfo(
        id: id ?? this.id,
        name: name ?? this.name,
        seatName: seatName ?? this.seatName,
        number: number ?? this.number,
        tftID: tftID ?? this.tftID,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['seatName'] = seatName;
    map['name'] = name;
    map['number'] = number;
    map['tftID'] = tftID;
    return map;
  }
}

class TicketFairType {
  TicketFairType({
    this.tftID,
    this.tftTitle,
  });

  TicketFairType.fromJson(dynamic json) {
    tftID = json['tftID'];
    tftTitle = json['tftTitle'];
  }
  String? tftID;
  String? tftTitle;
  TicketFairType copyWith({
    String? tftID,
    String? tftTitle,
  }) =>
      TicketFairType(
        tftID: tftID ?? this.tftID,
        tftTitle: tftTitle ?? this.tftTitle,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['tftID'] = tftID;
    map['tftTitle'] = tftTitle;
    return map;
  }

  @override
  String toString() {
    return tftTitle ?? '';
  }
}
