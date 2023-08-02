import 'package:appscwl_specialhire/utils/permission_manager.dart';
import 'package:bluetooth_thermal_printer/bluetooth_thermal_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothPrinter {
  static Future<String> connectByMacAddress(String mac) async {
    if (await PermissionManager.bluetoothAccessDiba()) {
      if (!await FlutterBluePlus.instance.isOn) {
        await FlutterBluePlus.instance.turnOn();
      }
      final String result = await BluetoothThermalPrinter.connect(mac) ?? '';
      print("state conneected $result");
      return result;
    } else {
      return 'access_denied';
    }
  }

  static Future<String?> isConnected() async =>
      await BluetoothThermalPrinter.connectionStatus;
  static Future<bool> disconnect() async {
    await BluetoothThermalPrinter.disConnect('mac');
    return await FlutterBluePlus.instance.turnOff();
  }

  static Future<List<int>> _cutPaper() async {
    List<int> bytes = [];
    CapabilityProfile profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile);

    bytes += generator.cut();

    return bytes;
  }

  static Future<List<int>> stringToBytes(String text) async {
    List<int> bytes = [];
    CapabilityProfile profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile);

    bytes += generator.text(
      text,
      styles: const PosStyles(
        align: PosAlign.left,
      ),
    );

    return bytes;
  }

  static Future<List<int>> stringToQR(String text) async {
    List<int> bytes = [];
    CapabilityProfile profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile);

    bytes += generator.qrcode(
      text,
      align: PosAlign.left,
      size: QRSize(0x0A),
    );

    return bytes;
  }

  //print quotation
  static Future<void> printQuotation(Map<String, Object> jsonData) async {
    // log(jsonEncode(jsonData));
    var bTitle = jsonData["bTitle"] as String;
    var address = jsonData["address"] as String;
    var email = jsonData["email"] as String;
    var tel = jsonData["tel"] as String;
    var tin = jsonData["tin"] as String;
    var vrn = jsonData["vrn"] as String;

    var spHireNo = jsonData["spHireNo"] as String;
    var cusName = jsonData["cusName"] as String;
    var company = jsonData["company"] as String;
    var cusPhone = jsonData["cusPhone"] as String;
    var cusAddress = jsonData["cusAddress"] as String;

    var route = jsonData["route"] as String;
    var pickUp = jsonData["pickUp"] as String;
    var dropOff = jsonData["dropOff"] as String;
    var depDateTime = jsonData["depDateTime"] as String;
    var retDateTime = jsonData["retDateTime"] as String;
    var remark = jsonData["remark"] as String;

    var fleetType = jsonData["fleetType"] as String;
    var ftMaker = jsonData["ftMaker"] as String;
    var seatCapacity = jsonData["seatCapacity"] as String;
    var coachNo = jsonData["coachNo"] as String;

    var rentPrice = jsonData["rentPrice"] as String;
    var amountPaid = jsonData["amountPaid"] as String;
    var amountDue = jsonData["amountDue"] as String;
    var servedBy = jsonData["servedBy"] as String;
    var printDate = jsonData["printDate"] as String;
    var findUs = jsonData["findUs"] as String;
    var downloadApp = jsonData["downloadApp"] as String;

    String content = "";
    content += "**SPECIAL HIRE QUOTATION**\n";
    if (bTitle != "") {
      content += "$bTitle\n";
    }
    if (address != "") {
      content += "$address\n";
    }
    if (email != "") {
      content += "Email: $email\n";
    }
    if (tel != "") {
      content += "Tel: $tel\n";
    }
    content += "TIN: ";
    if (tin != "") {
      content += "$tin\n";
    } else {
      content += "\n";
    }
    content += "VRN: ";
    if (vrn != "") {
      content += "$vrn\n";
    } else {
      content += "\n";
    }

    content += "--------------------------------";

    var content2 = "SPECIAL HIRE NO: $spHireNo\n\n";
    content2 += "CUSTOMER DETAILS\n";
    if (company != "") {
      content2 += "$company\n";
    }
    if (cusName != "") {
      content2 += "$cusName\n";
    }
    if (cusPhone != "") {
      content2 += "$cusPhone\n";
    }
    if (cusAddress != "") {
      content2 += "$cusAddress\n";
    }
    content2 += "\n";

    var content3 = "TRIP DETAILS\n";

    if (route != "") {
      content3 += "$route\n";
    }
    if (pickUp != "") {
      content3 += "Picking at: $pickUp\n";
    }
    if (dropOff != "") {
      content3 += "Dropping at: $dropOff\n";
    }
    if (depDateTime != "") {
      content3 += "Departure Date & time: $depDateTime\n";
    }
    if (retDateTime != "") {
      content3 += "Return Date & time:$retDateTime\n";
    }
    if (remark != "") {
      content3 += "Remark(Purpose): $remark\n";
    }
    content3 += "\n";

    var content4 = "FLEET DETAILS\n";
    if (coachNo != "") {
      content4 += "Coach No: $coachNo\n";
    }
    if (fleetType != "") {
      content4 += "Class: $fleetType\n";
    }
    if (ftMaker != "") {
      content4 += "Maker: $ftMaker\n";
    }
    if (seatCapacity != "") {
      content4 += "Seat capacity: $seatCapacity\n";
    }

    content4 += "\n";

    var content5 = "PAYMENT DETAILS\n";

    if (rentPrice != "") {
      content5 += "Rent price: $rentPrice\n";
    }
    if (amountPaid != "") {
      content5 += "Amount paid: $amountPaid\n";
    }
    if (amountDue != "") {
      content5 += "Amount due: $amountDue\n";
    }
    if (servedBy != "") {
      content5 += "Served by: $servedBy\n";
    }
    if (printDate != "") {
      content5 += "Print at: $printDate\n";
    }
    content5 += "--------------------------------\n";
    if (findUs != "") {
      content5 += "Find us: $findUs\n";
    }
    if (downloadApp != "") {
      content5 += "Download our app: $downloadApp\n";
    }
    content5 += "THIS IS NOT A RECEIPT";

//TODO call printer
    await BluetoothThermalPrinter.writeBytes(await stringToBytes(content));
    // BluetoothThermalPrinter.writeText(content);
    await BluetoothThermalPrinter.writeText(content2);
    await BluetoothThermalPrinter.writeText(content3);
    await BluetoothThermalPrinter.writeText(content4);
    await BluetoothThermalPrinter.writeText(content5);
    await BluetoothThermalPrinter.writeBytes(await _cutPaper());
  }

  //print invoice
  static Future<void> printInvoice(Map<String, Object> jsonData) async {
    var bTitle = jsonData["bTitle"] as String;
    var address = jsonData["address"] as String;
    var email = jsonData["email"] as String;
    var tel = jsonData["tel"] as String;
    var tin = jsonData["tin"] as String;
    var vrn = jsonData["vrn"] as String;

    var spHireNo = jsonData["spHireNo"] as String;
    var cusName = jsonData["cusName"] as String;
    var company = jsonData["company"] as String;
    var cusPhone = jsonData["cusPhone"] as String;
    var cusAddress = jsonData["cusAddress"] as String;

    var route = jsonData["route"] as String;
    var pickUp = jsonData["pickUp"] as String;
    var dropOff = jsonData["dropOff"] as String;
    var depDateTime = jsonData["depDateTime"] as String;
    var retDateTime = jsonData["retDateTime"] as String;
    var remark = jsonData["remark"] as String;

    var fleetType = jsonData["fleetType"] as String;
    var ftMaker = jsonData["ftMaker"] as String;
    var seatCapacity = jsonData["seatCapacity"] as String;
    var coachNo = jsonData["coachNo"] as String;

    var rentPrice = jsonData["rentPrice"] as String;
    var amountPaid = jsonData["amountPaid"] as String;
    var amountDue = jsonData["amountDue"] as String;
    var servedBy = jsonData["servedBy"] as String;
    var printDate = jsonData["printDate"] as String;

    var vcode = jsonData["vcode"] as String;
    var qrData = jsonData["qrData"] as String;

    var findUs = jsonData["findUs"] as String;
    var downloadApp = jsonData["downloadApp"] as String;

    var content = "";
    content += "**SPECIAL HIRE INVOICE**\n";
    if (bTitle != "") {
      content += "$bTitle\n";
    }
    if (address != "") {
      content += "$address\n";
    }
    if (email != "") {
      content += "Email: $email\n";
    }
    if (tel != "") {
      content += "Tel: $tel\n";
    }

    content += "TIN: ";
    if (tin != "") {
      content += "$tin\n";
    } else {
      content += "\n";
    }
    content += "VRN: ";
    if (vrn != "") {
      content += "$vrn\n";
    } else {
      content += "\n";
    }

    content += "--------------------------------";

    var content2 = "SPECIAL HIRE NO: $spHireNo\n\n";
    content2 += "CUSTOMER DETAILS\n";
    if (company != "") {
      content2 += "$company\n";
    }
    if (cusName != "") {
      content2 += "$cusName\n";
    }
    if (cusPhone != "") {
      content2 += "$cusPhone\n";
    }
    if (cusAddress != "") {
      content2 += "$cusAddress\n";
    }
    content2 += "\n";

    var content3 = "TRIP DETAILS\n";

    if (route != "") {
      content3 += "$route\n";
    }
    if (pickUp != "") {
      content3 += "Picking at: $pickUp\n";
    }
    if (dropOff != "") {
      content3 += "Dropping at: $dropOff\n";
    }
    if (depDateTime != "") {
      content3 += "Departure Date & time: $depDateTime\n";
    }
    if (retDateTime != "") {
      content3 += "Return Date & time: $retDateTime\n";
    }
    if (remark != "") {
      content3 += "Remark(Purpose): $remark\n";
    }
    content3 += "\n";

    var content4 = "FLEET DETAILS\n";
    if (coachNo != "") {
      content4 += "Coach No: $coachNo\n";
    }
    if (fleetType != "") {
      content4 += "Class: $fleetType\n";
    }
    if (ftMaker != "") {
      content4 += "Maker: $ftMaker\n";
    }
    if (seatCapacity != "") {
      content4 += "Seat capacity: $seatCapacity\n";
    }

    content4 += "\n";

    var content5 = "PAYMENT DETAILS\n";

    if (rentPrice != "") {
      content5 += "Rent price: $rentPrice\n";
    }
    if (amountPaid != "") {
      content5 += "Amount paid: $amountPaid\n";
    }
    if (amountDue != "") {
      content5 += "Amount due: $amountDue\n";
    }

    if (servedBy != "") {
      content5 += "Served by: $servedBy\n";
    }
    if (printDate != "") {
      content5 += "Print at: $printDate\n";
    }
    if (vcode != "") {
      content5 += "--------------------------------\n";
      content5 += "Receipt Verification Code\n$vcode\n";
    }

    var content7 = "";
    content7 += "--------------------------------\n";
    if (findUs != "") {
      content7 += "Find us: $findUs\n";
    }
    if (downloadApp != "") {
      content7 += "Download our app: $downloadApp";
    }

    await BluetoothThermalPrinter.writeBytes(await stringToBytes(content));
    await BluetoothThermalPrinter.writeText(content2);
    await BluetoothThermalPrinter.writeText(content3);
    await BluetoothThermalPrinter.writeText(content4);
    await BluetoothThermalPrinter.writeText(content5);
    if (qrData != "") {
      await BluetoothThermalPrinter.writeBytes(await stringToQR(qrData));
    }
    await BluetoothThermalPrinter.writeText(content7);
    await BluetoothThermalPrinter.writeBytes(await _cutPaper());
  }

  //print payment
  static Future<void> printPayment(Map<String, Object> jsonData) async {
    var bTitle = jsonData["bTitle"] as String;
    var address = jsonData["address"] as String;
    var email = jsonData["email"] as String;
    var tel = jsonData["tel"] as String;
    var tin = jsonData["tin"] as String;
    var vrn = jsonData["vrn"] as String;

    var spHireNo = jsonData["spHireNo"] as String;
    var cusName = jsonData["cusName"] as String;
    var company = jsonData["company"] as String;
    var cusPhone = jsonData["cusPhone"] as String;
    var cusAddress = jsonData["cusAddress"] as String;

    var route = jsonData["route"] as String;
    var pickUp = jsonData["pickUp"] as String;
    var dropOff = jsonData["dropOff"] as String;
    var depDateTime = jsonData["depDateTime"] as String;
    var retDateTime = jsonData["retDateTime"] as String;
    var remark = jsonData["remark"] as String;

    var fleetType = jsonData["fleetType"] as String;
    var ftMaker = jsonData["ftMaker"] as String;
    var seatCapacity = jsonData["seatCapacity"] as String;
    var coachNo = jsonData["coachNo"] as String;

    var rentPrice = jsonData["rentPrice"] as String;
    var paidAmmount = jsonData["paidAmmount"] as String;
    var totalPaid = jsonData["totalPaid"] as String;
    var amountDue = jsonData["amountDue"] as String;
    var note = jsonData["note"] as String;
    var servedBy = jsonData["servedBy"] as String;
    var printDate = jsonData["printDate"] as String;
    var rePrint = jsonData["rePrintDate"] as String;
    var vcode = jsonData["vcode"] as String;
    var qrData = jsonData["qrData"] as String;
    var findUs = jsonData["findUs"] as String;
    var downloadApp = jsonData["downloadApp"] as String;

    var content = "";
    content += "**SPECIAL HIRE PAYMENT**\n";
    if (bTitle != "") {
      content += "$bTitle\n";
    }
    if (address != "") {
      content += "$address\n";
    }
    if (email != "") {
      content += "Email: $email\n";
    }
    if (tel != "") {
      content += "Tel: $tel\n";
    }
    content += "TIN: ";
    if (tin != "") {
      content += "$tin\n";
    } else {
      content += "\n";
    }
    content += "VRN: ";
    if (vrn != "") {
      content += "$vrn\n";
    } else {
      content += "\n";
    }

    content += "--------------------------------";

    var content2 = "SPECIAL HIRE NO: $spHireNo\n\n";
    content2 += "CUSTOMER DETAILS\n";
    if (company != "") {
      content2 += "$company\n";
    }
    if (cusName != "") {
      content2 += "$cusName\n";
    }
    if (cusPhone != "") {
      content2 += "$cusPhone\n";
    }
    if (cusAddress != "") {
      content2 += "$cusAddress\n";
    }
    content2 += "\n";

    var content3 = "TRIP DETAILS\n";

    if (route != "") {
      content3 += "$route\n";
    }
    if (pickUp != "") {
      content3 += "Picking at: $pickUp\n";
    }
    if (dropOff != "") {
      content3 += "Dropping at: $dropOff\n";
    }
    if (depDateTime != "") {
      content3 += "Departure Date & time: $depDateTime\n";
    }
    if (retDateTime != "") {
      content3 += "Return Date & time: $retDateTime\n";
    }
    if (remark != "") {
      content3 += "Remark(Purpose): $remark\n";
    }
    content3 += "\n";

    var content4 = "FLEET DETAILS\n";
    if (coachNo != "") {
      content4 += "Coach No: $coachNo\n";
    }
    if (fleetType != "") {
      content4 += "Class: $fleetType\n";
    }
    if (ftMaker != "") {
      content4 += "Maker: $ftMaker\n";
    }
    if (seatCapacity != "") {
      content4 += "Seat capacity: $seatCapacity\n";
    }

    content4 += "\n";

    var content5 = "PAYMENT DETAILS\n";

    if (rentPrice != "") {
      content5 += "Rent price: $rentPrice\n";
    }
    if (paidAmmount != "") {
      content5 += "Amount paid: $paidAmmount\n";
    }
    if (totalPaid != "") {
      content5 += "Total paid: $totalPaid\n";
    }
    if (amountDue != "") {
      content5 += "Amount due: $amountDue\n";
    }
    if (note != "") {
      content5 += "Note: $note\n";
    }
    if (servedBy != "") {
      content5 += "Served by: $servedBy\n";
    }
    if (printDate != "") {
      content5 += "Print at: $printDate\n";
    }

    if (rePrint != "") {
      content5 += "Re-print date: $rePrint\n";
    }
    content5 += "--------------------------------";

    var content6 = "Receipt Verification Code\n";

    if (vcode != "") {
      content6 += "$vcode\n";
    }

    var content7 = "";
    content7 += "--------------------------------\n";
    if (findUs != "") {
      content7 += "Find us: $findUs\n";
    }
    if (downloadApp != "") {
      content7 += "Download our app: $downloadApp";
    }

    await BluetoothThermalPrinter.writeBytes(await stringToBytes(content));
    await BluetoothThermalPrinter.writeText(content2);
    await BluetoothThermalPrinter.writeText(content3);
    await BluetoothThermalPrinter.writeText(content4);
    await BluetoothThermalPrinter.writeText(content5);
    await BluetoothThermalPrinter.writeText(content6);
    if (qrData != "") {
      await BluetoothThermalPrinter.writeBytes(await stringToQR(qrData));
    }
    await BluetoothThermalPrinter.writeText(content7);
    await BluetoothThermalPrinter.writeBytes(await _cutPaper());
  }

  //print transaction history
  static Future<void> printTransactionHistory(
      Map<String, Object> jsonData) async {
    var bTitle = jsonData["bTitle"] as String;
    var address = jsonData["address"] as String;
    var email = jsonData["email"] as String;
    var tel = jsonData["tel"] as String;
    var tin = jsonData["tin"] as String;
    var vrn = jsonData["vrn"] as String;

    var spHireNo = jsonData["spHireNo"] as String;
    var cusName = jsonData["cusName"] as String;
    var company = jsonData["company"] as String;
    var cusPhone = jsonData["cusPhone"] as String;

    var route = jsonData["route"] as String;
    var depDateTime = jsonData["depDateTime"] as String;
    var retDateTime = jsonData["retDateTime"] as String;
    var remark = jsonData["remark"] as String;

    var payHistory = jsonData["payHistory"] as String;

    var rentPrice = jsonData["rentPrice"] as String;
    var amountPaid = jsonData["amountPaid"] as String;
    var amountDue = jsonData["amountDue"] as String;

    var vcode = jsonData["vcode"] as String;
    var qrData = jsonData["qrData"] as String;
    var printDate = jsonData["printDate"] as String;

    var findUs = jsonData["findUs"] as String;
    var downloadApp = jsonData["downloadApp"] as String;

    var content = "";
    content += "**TRANSACTION HISTORY**\n";
    if (bTitle != "") {
      content += "$bTitle\n";
    }
    if (address != "") {
      content += "$address\n";
    }
    if (email != "") {
      content += "Email: $email\n";
    }
    if (tel != "") {
      content += "Tel: $tel\n";
    }
    content += "TIN: ";
    if (tin != "") {
      content += "$tin\n";
    } else {
      content += "\n";
    }
    content += "VRN: ";
    if (vrn != "") {
      content += "$vrn\n";
    } else {
      content += "\n";
    }
    content += "--------------------------------";

    var content2 = "SPECIAL HIRE NO: $spHireNo\n\n";
    content2 += "CUSTOMER DETAILS\n";
    if (company != "") {
      content2 += "$company\n";
    }
    if (cusName != "") {
      content2 += "$cusName\n";
    }
    if (cusPhone != "") {
      content2 += "$cusPhone\n";
    }
    content2 += "\n";

    var content3 = "TRIP DETAILS\n";

    if (route != "") {
      content3 += "$route\n";
    }
    if (depDateTime != "") {
      content3 += "Departure Date & time: $depDateTime\n";
    }
    if (retDateTime != "") {
      content3 += "Return Date & time: $retDateTime\n";
    }
    if (remark != "") {
      content3 += "Remark(Purpose): $remark\n";
    }
    content3 += "\n";

    var content4 = "";
    if (payHistory != "") {
      content4 += "$payHistory";
    }

    var content5 = "PAYMENT DETAILS\n";
    if (rentPrice != "") {
      content5 += "Rent price: $rentPrice\n";
    }
    if (amountPaid != "") {
      content5 += "Amount paid: $amountPaid\n";
    }
    if (amountDue != "") {
      content5 += "Amount due: $amountDue\n";
    }
    if (printDate != "") {
      content5 += "Print at: $printDate\n";
    }

    var content6 = "";
    if (vcode != "") {
      content5 += "--------------------------------\n";
      content6 += "Receipt verification code\n$vcode\n";
    }
    var content7 = "";
    content7 += "--------------------------------\n";
    if (findUs != "") {
      content7 += "Find us: $findUs\n";
    }
    if (downloadApp != "") {
      content7 += "Download our app: $downloadApp";
    }

    await BluetoothThermalPrinter.writeBytes(await stringToBytes(content));
    await BluetoothThermalPrinter.writeText(content2);
    await BluetoothThermalPrinter.writeText(content3);
    await BluetoothThermalPrinter.writeText(content4);
    await BluetoothThermalPrinter.writeText(content5);
    await BluetoothThermalPrinter.writeText(content6);
    if (qrData != "") {
      await BluetoothThermalPrinter.writeBytes(await stringToQR(qrData));
    }
    await BluetoothThermalPrinter.writeText(content7);
    await BluetoothThermalPrinter.writeBytes(await _cutPaper());
  }

  //print r sheet (manifest)
  static Future<void> printManifest(Map<String, Object> jsonData) async {
    var bTitle = jsonData["bTitle"] as String;
    var address = jsonData["address"] as String;
    var email = jsonData["email"] as String;
    var tel = jsonData["tel"] as String;
    var tin = jsonData["tin"] as String;
    var vrn = jsonData["vrn"] as String;

    var spHireNo = jsonData["spHireNo"] as String;

    var route = jsonData["route"] as String;
    var depDateTime = jsonData["depDateTime"] as String;
    var retDateTime = jsonData["retDateTime"] as String;
    var remark = jsonData["remark"] as String;

    var rSheet = jsonData["rSheet"] as String;

    var printDate = jsonData["printDate"] as String;

    var findUs = jsonData["findUs"] as String;
    var downloadApp = jsonData["downloadApp"] as String;

    var content = "";
    content += "**SPECIAL HIRE MANIFEST**\n";
    if (bTitle != "") {
      content += "$bTitle\n";
    }
    if (address != "") {
      content += "$address\n";
    }
    if (email != "") {
      content += "Email: $email\n";
    }
    if (tel != "") {
      content += "Tel: $tel\n";
    }
    content += "TIN: ";
    if (tin != "") {
      content += "$tin\n";
    } else {
      content += "\n";
    }
    content += "VRN: ";
    if (vrn != "") {
      content += "$vrn\n";
    } else {
      content += "\n";
    }
    content += "--------------------------------";

    var content2 = "SPECIAL HIRE NO: $spHireNo\n\n";

    var content3 = "TRIP DETAILS\n";

    if (route != "") {
      content3 += "Route: $route\n";
    }
    if (depDateTime != "") {
      content3 += "Departure Date & time: $depDateTime\n";
    }
    if (retDateTime != "") {
      content3 += "Return Date & time: $retDateTime\n";
    }
    if (remark != "") {
      content3 += "Remark(Purpose): $remark\n";
    }
    content3 += "\n";

    var content4 = "";
    if (rSheet != "") {
      content4 += "$rSheet";
    }

    var content5 = "";
    if (printDate != "") {
      content5 += "Print at: $printDate\n";
    }
    content5 += "--------------------------------\n";
    if (findUs != "") {
      content5 += "Find us: $findUs\n";
    }
    if (downloadApp != "") {
      content5 += "Download our app: $downloadApp";
    }

    await BluetoothThermalPrinter.writeBytes(await stringToBytes(content));
    await BluetoothThermalPrinter.writeText(content2);
    await BluetoothThermalPrinter.writeText(content3);
    await BluetoothThermalPrinter.writeText(content4);
    await BluetoothThermalPrinter.writeText(content5);
    await BluetoothThermalPrinter.writeBytes(await _cutPaper());
  }
}
