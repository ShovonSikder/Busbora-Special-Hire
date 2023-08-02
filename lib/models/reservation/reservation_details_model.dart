import '../quotation/quotation_details_model.dart';

class ReservationDetailsModel {
  ReservationDetailsModel({
    this.quotationDetails,
  });

  ReservationDetailsModel.fromJson(dynamic json) {
    quotationDetails = json['reservationDetails'] != null
        ? QuotationDetails.fromJson(json['reservationDetails'])
        : null;
  }
  QuotationDetails? quotationDetails;
  ReservationDetailsModel copyWith({
    QuotationDetails? quotationDetails,
  }) =>
      ReservationDetailsModel(
        quotationDetails: quotationDetails ?? this.quotationDetails,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (quotationDetails != null) {
      map['reservationDetails'] = quotationDetails?.toJson();
    }
    return map;
  }
}
