import 'package:appscwl_specialhire/models/quotation/quotation_init_model.dart';
import 'package:flutter/material.dart';

import '../all_districts_model.dart';

class JourneyInformationModel {
  Districts? origin;
  Districts? destination;
  Type? type;
  String? pickup;
  String? dropping;
  DateTime? journeyDate;
  String? journeyDateString;
  String? journeyTimeString;

  DateTime? returnDate;
  String? returnDateString;
  String? returnTimeString;

  Map<String, dynamic> toJson() => {};
  JourneyInformationModel({
    this.origin,
    this.destination,
    this.type,
    this.pickup,
    this.dropping,
    this.journeyDate,
    this.journeyDateString,
    this.returnTimeString,
    this.journeyTimeString,
    this.returnDate,
    this.returnDateString,
  });

  factory JourneyInformationModel.fromJson(Map<String, dynamic> map) =>
      JourneyInformationModel(
        origin: Districts.fromJson(map['origin']),
        destination: Districts.fromJson(map['destination']),
        type: Type.fromJson(map['type']),
        pickup: map['pickUp'],
        dropping: map['dropping'],
        journeyDateString: map['journeyDate'],
        returnDateString: map['returnDate'],
      );
}
