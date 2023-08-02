import 'package:appscwl_specialhire/models/quotation/contact_information_model.dart';
import 'package:appscwl_specialhire/models/quotation/fleet_model.dart';
import 'package:appscwl_specialhire/models/quotation/journey_information_model.dart';

class QuotationModel {
  String? qreID;
  String? reID;
  String? quotationNo;
  ContactInformationModel? contactInformationModel;
  JourneyInformationModel? journeyInformationModel;
  List<FleetModel> listOfFleets = [];
  double? subTotal;
  double? discount;
  double? totalPayable;
  double? advanced;
  double? due;
  QuotationModel({
    this.qreID,
    this.reID,
    this.quotationNo,
    this.contactInformationModel,
    this.journeyInformationModel,
    this.subTotal = 0,
    this.discount = 0,
    this.totalPayable = 0,
    this.advanced = 0,
    this.due = 0,
  });

  //Api key is not consistent so this fromJson has no ff works
  factory QuotationModel.fromJson(Map<String, dynamic> map) => QuotationModel(
        qreID: map['qreID'],
        quotationNo: map['id'],
        contactInformationModel: ContactInformationModel.fromJson({
          'company': map['company'],
          'contactPerson': map['contactPerson'],
          'mobile': map['mobile'],
          'address': map['address'],
          'email': map['email'],
          'remarks': map['remarks'],
        }),
        journeyInformationModel: JourneyInformationModel.fromJson({
          'origin': map['origin'],
          'destination': map['destination'],
          'pickUp': map['pickUp'],
          'dropping': map['dropping'],
          'returnDate': map['returnDate'],
          'journeyDate': map['journeyDate'],
        }),
      );
  Map<String, dynamic> validateFleetRents() {
    bool status = true;
    String msg = '';
    for (var fleet in listOfFleets) {
      if (fleet.rent! <= 0) {
        status = false;
        msg = fleet.coach!.coachTitle ?? '';
        break;
      }
    }
    return {'status': status, 'msg': msg};
  }
}
