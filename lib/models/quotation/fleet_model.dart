import 'package:appscwl_specialhire/models/quotation/quotation_init_model.dart';

class FleetModel {
  FleetType? fleetType;
  Coach? coach;
  FleetMakers? makers;
  Seats? seatTemp;
  double? rent;
  double? total;

  FleetModel({
    this.fleetType,
    this.coach,
    this.makers,
    this.seatTemp,
    this.rent = 0,
    this.total = 0,
  });
  factory FleetModel.fromJson(Map<String, dynamic> map) => FleetModel(
      fleetType: FleetType.fromJson(map['fleetType']),
      makers: FleetMakers.fromJson(map['makers']),
      seatTemp: Seats.fromJson(map['seats']),
      rent: map['rent']);
}
