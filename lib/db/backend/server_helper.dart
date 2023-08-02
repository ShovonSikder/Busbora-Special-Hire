import 'package:appscwl_specialhire/models/quotation/quotation_model.dart';
import 'package:appscwl_specialhire/models/reservation/expense/expense_init_model.dart';
import 'package:appscwl_specialhire/models/reservation/passenger_info_model.dart';
import 'package:appscwl_specialhire/utils/constants/api_constants/api_urls.dart';
import 'package:appscwl_specialhire/utils/constants/api_constants/json_keys.dart';
import 'package:appscwl_specialhire/utils/constants/constants.dart';
import 'package:appscwl_specialhire/utils/helper_function.dart';
import 'package:http/http.dart' as http;

class ServerHelper {
  static Future<http.Response> login(String username, String password) async =>
      await http.post(
        Uri.parse(baseApiPostUrl),
        body: {
          "module": "login",
          "username": username,
          "password": password,
          "version": "4",
        },
      );

  static Future<http.Response> quotationInit(String authCode) async =>
      await http.post(
        Uri.parse(baseApiPostUrl),
        body: {
          "module": " reservationQuotationAddInt",
          jsonKeyAuthCode: authCode,
        },
      );

  static Future<http.Response> districtsInit(String authCode) async =>
      await http.post(
        Uri.parse(baseApiPostUrl),
        body: {
          "module": " districtList",
          jsonKeyAuthCode: authCode,
          'ln': '3',
        },
      );

  static Future<http.Response> addReservationQuotation(
      String authCode, QuotationModel quotationModel) async {
    return await http.post(
      Uri.parse(baseApiPostUrl),
      body: generateAddQuotationRequestBody(authCode, quotationModel),
    );
  }

  static Map<String, String?> generateAddQuotationRequestBody(
      String authCode, QuotationModel quotationModel) {
    final Map<String, String?> map = {
      'module': 'reservationQuotationAdd',
      'authcode': authCode,
      //contact information
      'company': quotationModel.contactInformationModel!.companyName,
      'companyMobile': quotationModel.contactInformationModel!.mobile,
      'contactPerson': quotationModel.contactInformationModel!.name,
      'address': quotationModel.contactInformationModel!.address,
      'email': quotationModel.contactInformationModel!.email,
      'remarks': quotationModel.contactInformationModel!.remarks,

      //journey Information
      'origin': quotationModel.journeyInformationModel?.origin?.distID,
      'destination':
          quotationModel.journeyInformationModel?.destination?.distID,
      'pickUp': quotationModel.journeyInformationModel?.pickup,
      'dropping': quotationModel.journeyInformationModel?.dropping,
      'journeyDate': getFormattedDate(
          quotationModel.journeyInformationModel!.journeyDate!, 'dd-MM-yyyy'),
      'journeyTime': quotationModel.journeyInformationModel!.journeyTimeString,
      'returnDate': getFormattedDate(
          quotationModel.journeyInformationModel!.returnDate ?? DateTime.now(),
          'dd-MM-yyyy'),
      'returnTime': quotationModel.journeyInformationModel!.returnTimeString,
      'type': quotationModel.journeyInformationModel!.type!.id.toString(),
      'advance': quotationModel.advanced.toString(),
      'discount': quotationModel.discount.toString(),
      // for(var fleet in quotationModel.listOfFleets)
    };
    for (int i = 0; i < quotationModel.listOfFleets.length; i++) {
      final fleet = quotationModel.listOfFleets[i];
      map['ftID[$i]'] = fleet.fleetType?.ftID;
      map['fmID[$i]'] = fleet.makers?.fmID;
      map['stID[$i]'] = fleet.seatTemp?.stID;
      map['coachID[$i]'] = fleet.coach?.coachID;
      map['rent[$i]'] = fleet.rent.toString();
    }
    return map;
  }

  static Future<http.Response> getQuotationList(String authCode,
          {Map<String, String?> searchQuery = const {
            'id': '',
            'from': '',
            'to': '',
            'formDate': '',
            'toDate': '',
          }}) async =>
      await http.post(
        Uri.parse(baseApiPostUrl),
        body: {
          'module': 'reservationQuotationList',
          'authcode': authCode,
          ...searchQuery,
        },
      );

  static Future<http.Response> getReservationList(String authCode,
          {Map<String, String?> searchQuery = const {
            'id': '',
            'from': '',
            'to': '',
            'formDate': '',
            'toDate': '',
          }}) async =>
      await http.post(
        Uri.parse(baseApiPostUrl),
        body: {
          'module': 'reservationList',
          'authcode': authCode,
          ...searchQuery,
        },
      );

  static Future<http.Response> logOut(String authCode) async => await http.post(
        Uri.parse(baseApiPostUrl),
        body: {
          'module': 'logout',
          'mac': '',
          'authcode': authCode,
        },
      );

  static Future<http.Response> createReservationFromQuotation(
      String authCode, String id) async {
    return await http.post(Uri.parse(baseApiPostUrl), body: {
      'module': 'createReservationFromQuotation',
      'authcode': authCode,
      'qreID': id,
      'cpmID': '0',
    });
  }

  static Future<http.Response> getQuotationDetails(
          String authCode, String id) async =>
      await http.post(Uri.parse(baseApiPostUrl), body: {
        'module': ' reservationQuotationDetails',
        'authcode': authCode,
        'id': id,
      });

  static Future<http.Response> getReservationDetails(
          String authCode, String id) async =>
      await http.post(Uri.parse(baseApiPostUrl), body: {
        'module': ' reservationDetails',
        'authcode': authCode,
        'id': id,
      });

  static Future<http.Response> deleteReservation(
          String authCode, String reID) async =>
      await http.post(Uri.parse(baseApiPostUrl), body: {
        'module': 'reservationDelete',
        'authcode': authCode,
        'reID': reID,
      });

  static Future<http.Response> deleteQuotation(
          String authCode, String qreID) async =>
      await http.post(Uri.parse(baseApiPostUrl), body: {
        'module': 'reservationQuotationDelete',
        'authcode': authCode,
        'qreID': qreID,
      });

  static Future<http.Response> reservationTransition(
          String authCode,
          String reservationId,
          int transitionType,
          double amount,
          String note) async =>
      await http.post(Uri.parse(baseApiPostUrl), body: {
        'module': 'reservationTransition',
        'authcode': authCode,
        'reID': reservationId,
        'transitionType': transitionType.toString(),
        'amount': amount.toString(),
        'note': note,
      });

  static Future<http.Response> getTransitionHistory(
          String authCode, String reservationReId) async =>
      await http.post(Uri.parse(baseApiPostUrl), body: {
        'module': 'reservationTransitionHistory',
        'authcode': authCode,
        'reID': reservationReId,
      });

  static Future<http.Response> initExpense(
          String authCode, String reservationReId) async =>
      await http.post(Uri.parse(baseApiPostUrl), body: {
        'module': ' reservationExpenseInt',
        'authcode': authCode,
        'reID': reservationReId,
      });

  static Future<http.Response> addExpense(String authCode,
          ExpenseInitModel expenseSubmitModel, String reID) async =>
      await http.post(Uri.parse(baseApiPostUrl),
          body: generateReservationExpenseRequestBody(
              authCode, expenseSubmitModel, reID));

  static Map<String, String> generateReservationExpenseRequestBody(
      String authCode, ExpenseInitModel expenseSubmitModel, String reID) {
    Map<String, String> map = {
      'module': ' reservationExpense',
      'authcode': authCode,
      'reID': reID,
    };
    for (var i = 0; i < expenseSubmitModel.reservationFleets!.length; i++) {
      map['expenseData[$i][rfID]'] =
          expenseSubmitModel.reservationFleets![i].rfID ?? '';
      map['expenseData[$i][fID]'] =
          expenseSubmitModel.reservationFleets![i].fleet ?? '';
      map['expenseData[$i][driver]'] =
          expenseSubmitModel.reservationFleets![i].driver ?? '';
      map['expenseData[$i][helper]'] =
          expenseSubmitModel.reservationFleets![i].helper ?? '';
      map['expenseData[$i][guide]'] =
          expenseSubmitModel.reservationFleets![i].guide ?? '';
      map['expenseData[$i][remarks]'] =
          expenseSubmitModel.reservationFleets![i].remarks ?? '';
      map['expenseData[$i][driverAmount]'] =
          expenseSubmitModel.reservationFleets![i].driverAmount.toString();
      map['expenseData[$i][helperAmount]'] =
          expenseSubmitModel.reservationFleets![i].helperAmount.toString();
      map['expenseData[$i][guideAmount]'] =
          expenseSubmitModel.reservationFleets![i].guideAmount.toString();
    }

    return map;
  }

  static Future<http.Response> passengerInfoInit(
          String authCode, String rfID) async =>
      await http.post(Uri.parse(baseApiPostUrl), body: {
        'module': 'reservationPassengersInfoUpdateInt',
        'authcode': authCode,
        'rfID': rfID,
      });

  static Future<http.Response> updatePassengerInfo(String authCode,
          PassengerInfoModel passengerInfoModel, String rfID) async =>
      await http.post(
        Uri.parse(baseApiPostUrl),
        body: _generatePassengerInfoRequestBody(
            authCode, passengerInfoModel, rfID),
      );

  static Map<String, String> _generatePassengerInfoRequestBody(
      String authCode, PassengerInfoModel passengerInfoModel, String rfID) {
    Map<String, String> map = {
      'module': 'reservationPassengersInfoUpdate',
      'authcode': authCode,
      'rfID': rfID,
    };
    for (var i = 0; i < passengerInfoModel.passengerInfo!.length; i++) {
      map['passengerInfo[$i][id]'] =
          passengerInfoModel.passengerInfo![i].id ?? '';
      map['passengerInfo[$i][name]'] =
          passengerInfoModel.passengerInfo![i].name ?? '';
      map['passengerInfo[$i][number]'] =
          passengerInfoModel.passengerInfo![i].number ?? '';
      map['passengerInfo[$i][tftID]'] =
          passengerInfoModel.passengerInfo![i].tftID ?? '';
    }

    return map;
  }

  static Future<http.Response> updateReservationQuotation(
      String authCode, QuotationModel quotationModel,
      {isReservation}) async {
    return await http.post(
      Uri.parse(baseApiPostUrl),
      body: generateUpDateQuotationRequestBody(authCode, quotationModel,
          isReservation: isReservation),
    );
  }

  static Map<String, String?> generateUpDateQuotationRequestBody(
      String authCode, QuotationModel quotationModel,
      {isReservation}) {
    final Map<String, String?> map =
        generateAddQuotationRequestBody(authCode, quotationModel);
    map['module'] =
        isReservation ? 'reservationEdit' : 'reservationQuotationEdit';

    isReservation
        ? map['reID'] = quotationModel.reID
        : map['qreID'] = quotationModel.qreID;
    return map;
  }
}
