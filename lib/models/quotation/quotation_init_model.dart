class QuotationInitModel {
  QuotationInitModel({
    this.brand,
    this.seats,
    this.fleetType,
    this.coach,
    this.fleetMakers,
    this.type,
  });

  QuotationInitModel.fromJson(dynamic json) {
    brand = json['brand'];
    if (json['seats'] != null) {
      seats = [];
      json['seats'].forEach((v) {
        seats?.add(Seats.fromJson(v));
      });
    }

    if (json['fleetType'] != null) {
      fleetType = [];
      json['fleetType'].forEach((v) {
        fleetType?.add(FleetType.fromJson(v));
      });
    }
    if (json['coach'] != null) {
      coach = [];
      json['coach'].forEach((v) {
        coach?.add(Coach.fromJson(v));
      });
    }
    if (json['fleetMakers'] != null) {
      fleetMakers = [];
      json['fleetMakers'].forEach((v) {
        fleetMakers?.add(FleetMakers.fromJson(v));
      });
    }
    if (json['type'] != null) {
      type = [];
      json['type'].forEach((v) {
        type?.add(Type.fromJson(v));
      });
    }
  }
  String? brand;
  List<Seats>? seats;
  // List<Districts>? districts;
  List<FleetType>? fleetType;
  List<Coach>? coach;
  List<FleetMakers>? fleetMakers;
  List<Type>? type;
  QuotationInitModel copyWith({
    String? brand,
    List<Seats>? seats,
    // List<Districts>? districts,
    List<FleetType>? fleetType,
    List<FleetMakers>? fleetMakers,
    List<Type>? type,
  }) =>
      QuotationInitModel(
        brand: brand ?? this.brand,
        seats: seats ?? this.seats,
        // districts: districts ?? this.districts,
        fleetType: fleetType ?? this.fleetType,
        coach: coach ?? this.coach,
        fleetMakers: fleetMakers ?? this.fleetMakers,
        type: type ?? this.type,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['brand'] = brand;
    if (seats != null) {
      map['seats'] = seats?.map((v) => v.toJson()).toList();
    }
    // if (districts != null) {
    //   map['districts'] = districts?.map((v) => v.toJson()).toList();
    // }
    if (fleetType != null) {
      map['fleetType'] = fleetType?.map((v) => v.toJson()).toList();
    }
    if (fleetMakers != null) {
      map['fleetMakers'] = fleetMakers?.map((v) => v.toJson()).toList();
    }
    if (type != null) {
      map['type'] = type?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Type {
  Type({
    this.id,
    this.title,
  });

  Type.fromJson(dynamic json) {
    id = json['id'];
    title = json['title'];
  }
  num? id;
  String? title;
  Type copyWith({
    num? id,
    String? title,
  }) =>
      Type(
        id: id ?? this.id,
        title: title ?? this.title,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['title'] = title;
    return map;
  }

  @override
  String toString() {
    return title ?? 'Instance of Type';
  }
}

class FleetMakers {
  FleetMakers({
    this.fmID,
    this.fmTitle,
  });

  FleetMakers.fromJson(dynamic json) {
    fmID = json['fmID'];
    fmTitle = json['fmTitle'];
  }
  String? fmID;
  String? fmTitle;
  FleetMakers copyWith({
    String? fmID,
    String? fmTitle,
  }) =>
      FleetMakers(
        fmID: fmID ?? this.fmID,
        fmTitle: fmTitle ?? this.fmTitle,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['fmID'] = fmID;
    map['fmTitle'] = fmTitle;
    return map;
  }

  @override
  String toString() {
    return fmTitle ?? 'Instance of FleetMakers';
  }
}

class FleetType {
  FleetType({
    this.ftID,
    this.ftTitle,
  });

  FleetType.fromJson(dynamic json) {
    ftID = json['ftID'];
    ftTitle = json['ftTitle'];
  }
  String? ftID;
  String? ftTitle;
  FleetType copyWith({
    String? ftID,
    String? ftTitle,
  }) =>
      FleetType(
        ftID: ftID ?? this.ftID,
        ftTitle: ftTitle ?? this.ftTitle,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['ftID'] = ftID;
    map['ftTitle'] = ftTitle;
    return map;
  }

  @override
  String toString() {
    return ftTitle ?? 'Instance of FleetType';
  }
}

class Coach {
  Coach({
    this.coachID,
    this.coachTitle,
  });

  Coach.fromJson(dynamic json) {
    coachID = json['coachID'];
    coachTitle = json['coachTitle'];
  }
  String? coachID;
  String? coachTitle;
  Coach copyWith({
    String? coachID,
    String? coachTitle,
  }) =>
      Coach(
        coachID: coachID ?? this.coachID,
        coachTitle: coachTitle ?? this.coachTitle,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['coachID'] = coachID;
    map['coachTitle'] = coachTitle;
    return map;
  }

  @override
  String toString() {
    return coachTitle ?? 'Instance of FleetType';
  }
}

// class Districts {
//   Districts({
//     this.distID,
//   });
//
//   Districts.fromJson(dynamic json) {
//     distID = json['distID'];
//   }
//   String? distID;
//   Districts copyWith({
//     String? distID,
//   }) =>
//       Districts(
//         distID: distID ?? this.distID,
//       );
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['distID'] = distID;
//     return map;
//   }
//
//   @override
//   String toString() {
//     return distID ?? 'Instance of Districts';
//   }
// }

class Seats {
  Seats({
    this.stID,
    this.stTitle,
  });

  Seats.fromJson(dynamic json) {
    stID = json['stID'];
    stTitle = json['stTitle'];
  }
  String? stID;
  String? stTitle;
  Seats copyWith({
    String? stID,
    String? stTitle,
  }) =>
      Seats(
        stID: stID ?? this.stID,
        stTitle: stTitle ?? this.stTitle,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['stID'] = stID;
    map['stTitle'] = stTitle;
    return map;
  }

  @override
  String toString() {
    return stTitle ?? 'Instance of Seats';
  }
}
