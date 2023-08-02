import 'package:appscwl_specialhire/models/quotation/quotation_brief_model.dart';

class ReservationBriefModel {
  List<ReservationQuotation>? reservationList;
  ReservationBriefModel.fromJson(dynamic json) {
    if (json['reservation'] != null) {
      reservationList = [];
      json['reservation'].forEach((v) {
        reservationList?.add(ReservationQuotation.fromJson(v));
      });
    }
  }
}
