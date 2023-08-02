package tz.co.busbora.hire

import android.app.Activity
import android.content.Context
import android.util.Log
import tz.co.busbora.hire.utils.ViewDialog
import tz.co.busbora.hire.sunmi_utils.SunmiPrintHelper
import com.google.gson.Gson
import org.json.JSONObject
import java.util.*
import kotlin.collections.ArrayList
import kotlin.collections.HashMap

class SunmiPrinterTask {
    companion object {
        const val CHANNEL = "com.busbora.specialhire/printer"
        var sunmiPrintHelper = SunmiPrintHelper.getInstance()
    }


    fun initialize(context: Context):String {
       // sunmiPrintHelper.initSunmiPrinterService(context)
        when (sunmiPrintHelper.sunmiPrinter) {
            SunmiPrintHelper.NoSunmiPrinter -> {
                return "No printer"
            }
            SunmiPrintHelper.CheckSunmiPrinter -> {
                return "Connecting"
            }
            SunmiPrintHelper.FoundSunmiPrinter -> {
               return "Sunmi"
            }
            else -> {
                SunmiPrintHelper.getInstance()
                    .initSunmiPrinterService(context)
                return "Initializing"
            }
        }
    }


    fun printManifest(
        jsonData:HashMap<*,*>,
        context: Context,
        activity: Activity,
        viewLoadingDialog: ViewDialog
    ) {

        viewLoadingDialog.show()

        Log.d("SunmiPrinterTask", "printManifest")
        Log.d("SunmiPrinterTask", "${jsonData}")
        val bTitle= jsonData["bTitle"] as String
        val address= jsonData["address"] as String
        val email= jsonData["email"] as String
        val tel= jsonData["tel"] as String
        val tin= jsonData["tin"] as String
        val vrn= jsonData["vrn"] as String


        val spHireNo= jsonData["spHireNo"] as String



        val route= jsonData["route"] as String
        val depDateTime= jsonData["depDateTime"] as String
        val retDateTime= jsonData["retDateTime"] as String
        val remark= jsonData["remark"] as String

        val rSheet=jsonData["rSheet"] as String

        val printDate = jsonData["printDate"] as String

        val findUs= jsonData["findUs"] as String
        val downloadApp= jsonData["downloadApp"] as String


        var content: String ="**SPECIAL HIRE MANIFEST**\n"
        if (bTitle != "") {
            content += "$bTitle\n"
        }
        if (address != "") {
            content += "$address\n"
        }
        if (email != "") {
            content += "Email: $email\n"
        }
        if (tel != "") {
            content += "Tel: $tel\n"
        }
        content += "TIN: "
        content += if (tin != "") {
            "$tin\n"
        }else{
            "\n"
        }
        content += "VRN: "
        content += if (vrn != "") {
            "$vrn\n"
        }else{
            "\n"
        }

        Log.d("SunmiPrinterTask", "content:$content")
        content+="--------------------------------\n"




        var content2 = "SPECIAL HIRE NO: $spHireNo\n\n"

        var content3 = "TRIP DETAILS\n"


        if(route != ""){
            content3+= "Route: $route\n"
        }
        if(depDateTime != ""){
            content3+= "Departure Date & time: $depDateTime\n"
        }
        if(retDateTime != ""){
            content3+= "Return Date & time: $retDateTime\n"
        }
        if(remark != ""){
            content3+= "Remark(Purpose): $remark\n"
        }
        content3+= "\n"

        var content4=""
        if (rSheet!=""){
            content4+="$rSheet"
        }



       var content5=""
        if(printDate!=""){
            content5+="Print at: $printDate"
        }
        content5+="--------------------------------\n"
        if(findUs != ""){
            content5+= "Find us: $findUs\n"
        }
        if(downloadApp != ""){
            content5+= "Download our app: $downloadApp\n"
        }
        content5+= "\n"


        val size: Float = 24.0F


        SunmiPrintHelper.getInstance().printText(content, size, false, false)
        SunmiPrintHelper.getInstance().printText(content2, size, false, false)
        SunmiPrintHelper.getInstance().printText(content3, size, false, false)
        SunmiPrintHelper.getInstance().printText(content4, size, false, false)
        SunmiPrintHelper.getInstance().printText(content5, size, false, false)
        SunmiPrintHelper.getInstance().feedPaper()
        viewLoadingDialog.dismiss()


    }

    fun printQuotation(
        jsonData:HashMap<*,*>,
        context: Context,
        activity: Activity,
        viewLoadingDialog: ViewDialog
    ) {

        viewLoadingDialog.show()

        Log.d("SunmiPrinterTask", "printQuotation")
        Log.d("SunmiPrinterTask", "${jsonData}")
        val bTitle= jsonData["bTitle"] as String
        val address= jsonData["address"] as String
        val email= jsonData["email"] as String
        val tel= jsonData["tel"] as String
        val tin= jsonData["tin"] as String
        val vrn= jsonData["vrn"] as String


        val spHireNo= jsonData["spHireNo"] as String
        val cusName= jsonData["cusName"] as String
        val company= jsonData["company"] as String
        val cusPhone= jsonData["cusPhone"] as String
        val cusAddress= jsonData["cusAddress"] as String


        val route= jsonData["route"] as String
        val pickUp= jsonData["pickUp"] as String
        val dropOff= jsonData["dropOff"] as String
        val depDateTime= jsonData["depDateTime"] as String
        val retDateTime= jsonData["retDateTime"] as String
        val remark= jsonData["remark"] as String


        val fleetType= jsonData["fleetType"] as String
        val ftMaker= jsonData["ftMaker"] as String
        val seatCapacity= jsonData["seatCapacity"] as String
        val coachNo= jsonData["coachNo"] as String

        val rentPrice= jsonData["rentPrice"] as String
        val amountPaid= jsonData["amountPaid"] as String
        val amountDue= jsonData["amountDue"] as String
        val servedBy= jsonData["servedBy"] as String
        val printDate = jsonData["printDate"] as String

        val findUs= jsonData["findUs"] as String
        val downloadApp= jsonData["downloadApp"] as String


        var content: String ="**SPECIAL HIRE QUOTATION**\n"
        if (bTitle != "") {
            content += "$bTitle\n"
        }
        if (address != "") {
            content += "$address\n"
        }
        if (email != "") {
            content += "Email: $email\n"
        }
        if (tel != "") {
            content += "Tel: $tel\n"
        }
        content += "TIN: "
        content += if (tin != "") {
            "$tin\n"
        }else{
            "\n"
        }
        content += "VRN: "
        content += if (vrn != "") {
            "$vrn\n"
        }else{
            "\n"
        }

        Log.d("SunmiPrinterTask", "content: $content")
        content+="--------------------------------\n"




        var content2 = "SPECIAL HIRE NO: $spHireNo\n\n"
        content2+= "CUSTOMER DETAILS\n"
        if(company != ""){
            content2+= "$company\n"
        }
        if(cusName != ""){
            content2+= "$cusName\n"
        }
        if(cusPhone != ""){
            content2+= "$cusPhone\n"
        }
        if(cusAddress != ""){
            content2+= "$cusAddress\n"
        }
        content2+= "\n"

        var content3 = "TRIP DETAILS\n"


        if(route != ""){
            content3+= "$route\n"
        }
        if(pickUp != ""){
            content3+= "Picking at: $pickUp\n"
        }
        if(dropOff != ""){
            content3+= "Dropping at: $dropOff\n"
        }
        if(depDateTime != ""){
            content3+= "Departure Date & time: $depDateTime\n"
        }
        if(retDateTime != ""){
            content3+= "Return Date & time: $retDateTime\n"
        }
        if(remark != ""){
            content3+= "Remark(Purpose): $remark\n"
        }
        content3+= "\n"

        var content4= "FLEET DETAILS\n"


        if(coachNo != ""){
            content4+= "Coach No: $coachNo\n"
        }
        if(fleetType != ""){
            content4+= "Class: $fleetType\n"
        }
        if(ftMaker != ""){
            content4+= "Maker: $ftMaker\n"
        }
        if(seatCapacity != ""){
            content4+= "Seat capacity: $seatCapacity\n"
        }

       content4+= "\n"

        var content5= "PAYMENT DETAILS\n"


        if(rentPrice != ""){
            content5+= "Rent price: $rentPrice\n"

        }
        if(amountPaid != ""){
            content5+= "Amount paid: $amountPaid\n"

        }
        if(amountDue != ""){
            content5+= "Amount due: $amountDue\n"

        }
        if(servedBy != ""){
            content5+= "Served by: $servedBy\n"
        }
        if(printDate!=""){
            content5+="Print at: $printDate\n"
        }

        content5+="--------------------------------\n"
        if(findUs != ""){
            content5+= "Find us: $findUs\n"
        }
        if(downloadApp != ""){
            content5+= "Download our app: $downloadApp\n"
        }

            content5+= "THIS IS NOT A RECEIPT\n"

        content5+= "\n"






        val size: Float = 24.0F



        SunmiPrintHelper.getInstance().printText(content, size, false, false)
        SunmiPrintHelper.getInstance().printText(content2, size, false, false)
        SunmiPrintHelper.getInstance().printText(content3, size, false, false)
        SunmiPrintHelper.getInstance().printText(content4, size, false, false)
        SunmiPrintHelper.getInstance().printText(content5, size, false, false)
        SunmiPrintHelper.getInstance().feedPaper()
        viewLoadingDialog.dismiss()


    }

    fun printTransactionHistory(
        jsonData:HashMap<*,*>,
        context: Context,
        activity: Activity,
        viewLoadingDialog: ViewDialog
    ) {
        Log.d("SunmiPrinterTask", "printTransactionHistory")
        viewLoadingDialog.show()

        Log.d("SunmiPrinterTask", "printTransactionHistory")
        Log.d("SunmiPrinterTask", "${jsonData}")
        val bTitle= jsonData["bTitle"] as String
        val address= jsonData["address"] as String
        val email= jsonData["email"] as String
        val tel= jsonData["tel"] as String
        val tin= jsonData["tin"] as String
        val vrn= jsonData["vrn"] as String


        val spHireNo= jsonData["spHireNo"] as String
        val cusName= jsonData["cusName"] as String
        val company= jsonData["company"] as String
        val cusPhone= jsonData["cusPhone"] as String


        val route= jsonData["route"] as String
        val depDateTime= jsonData["depDateTime"] as String
        val retDateTime= jsonData["retDateTime"] as String
        val remark= jsonData["remark"] as String

        val payHistory=jsonData["payHistory"] as String

        val rentPrice= jsonData["rentPrice"] as String
        val amountPaid= jsonData["amountPaid"] as String
        val amountDue= jsonData["amountDue"] as String
        val printDate = jsonData["printDate"] as String

        val vcode = jsonData["vcode"] as String
        val qrData = jsonData["qrData"] as String

        val findUs= jsonData["findUs"] as String
        val downloadApp= jsonData["downloadApp"] as String


        var content: String ="**TRANSACTION HISTORY**\n"
        if (bTitle != "") {
            content += "$bTitle\n"
        }
        if (address != "") {
            content += "$address\n"
        }
        if (email != "") {
            content += "Email: $email\n"
        }
        if (tel != "") {
            content += "Tel: $tel\n"
        }
        content += "TIN: "
        content += if (tin != "") {
            "$tin\n"
        }else{
            "\n"
        }
        content += "VRN: "
        content += if (vrn != "") {
            "$vrn\n"
        }else{
            "\n"
        }
        Log.d("SunmiPrinterTask", "content: $content")
        content+="--------------------------------\n"




        var content2 = "SPECIAL HIRE NO: $spHireNo\n\n"
        content2+= "CUSTOMER DETAILS\n"
        if(company != ""){
            content2+= "$company\n"
        }
        if(cusName != ""){
            content2+= "$cusName\n"
        }
        if(cusPhone != ""){
            content2+= "$cusPhone\n"
        }
        content2+= "\n"

        var content3 = "TRIP DETAILS\n"


        if(route != ""){
            content3+= "$route\n"
        }
        if(depDateTime != ""){
            content3+= "Departure Date & time: $depDateTime\n"
        }
        if(retDateTime != ""){
            content3+= "Return Date & time: $retDateTime\n"
        }
        if(remark != ""){
            content3+= "Remark(Purpose): $remark\n"
        }
        content3+= "\n"

        var content4=""
        if (payHistory!=""){
            content4+="$payHistory"
        }

        var content5= "PAYMENT DETAILS\n"
        if(rentPrice != ""){
            content5+= "Rent price: $rentPrice\n"

        }
        if(amountPaid != ""){
            content5+= "Amount paid: $amountPaid\n"

        }
        if(amountDue != ""){
            content5+= "Amount due: $amountDue\n"

        }
        if(printDate!=""){
            content5+="Print at: $printDate"
        }

        var content6= ""

        if(vcode != ""){
            content6+="--------------------------------\n"
            content6+= "Receipt Verification Code\n$vcode\n"
        }

        content6+= "\n"

        var content7=""
        content7+="--------------------------------\n"
        if(findUs != ""){
            content7+= "Find us: $findUs\n"
        }
        if(downloadApp != ""){
            content7+= "Download our app: $downloadApp\n"
        }
        content7+= "\n"




        val size: Float = 24.0F



        SunmiPrintHelper.getInstance().printText(content, size, false, false)
        SunmiPrintHelper.getInstance().printText(content2, size, false, false)
        SunmiPrintHelper.getInstance().printText(content3, size, false, false)
        SunmiPrintHelper.getInstance().printText(content4, size, false, false)
        SunmiPrintHelper.getInstance().printText(content5, size, false, false)
        SunmiPrintHelper.getInstance().printText(content6, size, false, false)
        SunmiPrintHelper.getInstance().printQr(qrData, 10, 1)
        SunmiPrintHelper.getInstance().printText(content7, size, false, false)
        SunmiPrintHelper.getInstance().feedPaper()
        viewLoadingDialog.dismiss()


    }


    fun printPayment(
        jsonData:HashMap<*,*>,
        context: Context,
        activity: Activity,
        viewLoadingDialog: ViewDialog
    ) {

        viewLoadingDialog.show()

        Log.d("SunmiPrinterTask", "printQuotation")
        Log.d("SunmiPrinterTask", "${jsonData}")
        val bTitle= jsonData["bTitle"] as String
        val address= jsonData["address"] as String
        val email= jsonData["email"] as String
        val tel= jsonData["tel"] as String
        val tin= jsonData["tin"] as String
        val vrn= jsonData["vrn"] as String


        val spHireNo= jsonData["spHireNo"] as String
        val cusName= jsonData["cusName"] as String
        val company= jsonData["company"] as String
        val cusPhone= jsonData["cusPhone"] as String
        val cusAddress= jsonData["cusAddress"] as String


        val route= jsonData["route"] as String
        val pickUp= jsonData["pickUp"] as String
        val dropOff= jsonData["dropOff"] as String
        val depDateTime= jsonData["depDateTime"] as String
        val retDateTime= jsonData["retDateTime"] as String
        val remark= jsonData["remark"] as String


        val fleetType= jsonData["fleetType"] as String
        val ftMaker= jsonData["ftMaker"] as String
        val seatCapacity= jsonData["seatCapacity"] as String
        val coachNo= jsonData["coachNo"] as String

        val rentPrice= jsonData["rentPrice"] as String
        val paidAmmount= jsonData["paidAmmount"] as String
        val totalPaid= jsonData["totalPaid"] as String
        val amountDue= jsonData["amountDue"] as String
        val note= jsonData["note"] as String
        val servedBy= jsonData["servedBy"] as String
        val printDate = jsonData["printDate"] as String

        val rePrint= jsonData["rePrintDate"] as String
        val vcode= jsonData["vcode"] as String
        val qrData= jsonData["qrData"] as String
        val findUs= jsonData["findUs"] as String
        val downloadApp= jsonData["downloadApp"] as String


        var content: String ="**SPECIAL HIRE PAYMENT**\n"
        if (bTitle != "") {
            content += "$bTitle\n"
        }
        if (address != "") {
            content += "$address\n"
        }
        if (email != "") {
            content += "Email: $email\n"
        }
        if (tel != "") {
            content += "Tel: $tel\n"
        }
        content += "TIN: "
        content += if (tin != "") {
            "$tin\n"
        }else{
            "\n"
        }
        content += "VRN: "
        content += if (vrn != "") {
            "$vrn\n"
        }else{
            "\n"
        }

        Log.d("SunmiPrinterTask", "content: $content")
        content+="--------------------------------\n"




        var content2 = "SPECIAL HIRE NO: $spHireNo\n\n"
        content2+="CUSTOMER DETAILS\n"
        if(company != ""){
            content2+= "$company\n"
        }
        if(cusName != ""){
            content2+= "$cusName\n"
        }
        if(cusPhone != ""){
            content2+= "$cusPhone\n"
        }
        if(cusAddress != ""){
            content2+= "$cusAddress\n"
        }
        content2+= "\n"

        var content3 = "TRIP DETAILS\n"


        if(route != ""){
            content3+= "$route\n"
        }
        if(pickUp != ""){
            content3+= "Picking at: $pickUp\n"
        }
        if(dropOff != ""){
            content3+= "Dropping at: $dropOff\n"
        }
        if(depDateTime != ""){
            content3+= "Departure Date & time: $depDateTime\n"
        }
        if(retDateTime != ""){
            content3+= "Return Date & time: $retDateTime\n"
        }
        if(remark != ""){
            content3+= "Remark(Purpose): $remark\n"
        }
        content3+= "\n"

        var content4= "FLEET DETAILS\n"


        if(coachNo != ""){
            content4+= "Coach No: $coachNo\n"
        }

        if(fleetType != ""){
            content4+= "Class: $fleetType\n"
        }
        if(ftMaker != ""){
            content4+= "Maker: $ftMaker\n"
        }
        if(seatCapacity != ""){
            content4+= "Seat capacity: $seatCapacity\n"
        }
        content4+= "\n"

        var content5= "PAYMENT DETAILS\n"

        if(rentPrice != ""){
            content5+= "Rent price: $rentPrice\n"

        }
        if(paidAmmount != ""){
            content5+= "Amount paid: $paidAmmount\n"
        }
        if(totalPaid != ""){
            content5+= "Total paid: $totalPaid\n"
        }
        if(amountDue != ""){
            content5+= "Amount due: $amountDue\n"
        }
        if(note != ""){
            content5+= "Note: $note\n"
        }
        if(servedBy != ""){
            content5+= "Served by: $servedBy\n"
        }
        if(rePrint != ""){
            content5+= "Re-print date: $rePrint\n"
        }
        if(printDate != ""){
            content5+= "Print at: $printDate\n"
        }


        var content6= ""

        if(vcode != ""){
            content6+="--------------------------------\n"
            content6+= "Receipt Verification Code\n$vcode\n"
        }

        content6+= "\n"




        var content7=""
        content7+="--------------------------------\n"
        if(findUs != ""){
            content7+= "Find us: $findUs\n"
        }
        if(downloadApp != ""){
            content7+= "Download our app: $downloadApp\n"
        }
        content7+= "\n"






        val size: Float = 24.0F



        SunmiPrintHelper.getInstance().printText(content, size, false, false)
        SunmiPrintHelper.getInstance().printText(content2, size, false, false)
        SunmiPrintHelper.getInstance().printText(content3, size, false, false)
        SunmiPrintHelper.getInstance().printText(content4, size, false, false)
        SunmiPrintHelper.getInstance().printText(content5, size, false, false)
        SunmiPrintHelper.getInstance().printText(content6, size, false, false)
        SunmiPrintHelper.getInstance().printQr(qrData, 10, 1)
//        SunmiPrintHelper.getInstance().printText("\n", size, false, false)
        SunmiPrintHelper.getInstance().printText(content7, size, false, false)
        SunmiPrintHelper.getInstance().feedPaper()
        viewLoadingDialog.dismiss()


    }


    fun printInvoice(
        jsonData:HashMap<*,*>,
        context: Context,
        activity: Activity,
        viewLoadingDialog: ViewDialog
    ) {

        viewLoadingDialog.show()

        Log.d("SunmiPrinterTask", "printQuotation")
        Log.d("SunmiPrinterTask", "${jsonData}")
        val bTitle= jsonData["bTitle"] as String
        val address= jsonData["address"] as String
        val email= jsonData["email"] as String
        val tel= jsonData["tel"] as String
        val tin= jsonData["tin"] as String
        val vrn= jsonData["vrn"] as String


        val spHireNo= jsonData["spHireNo"] as String
        val cusName= jsonData["cusName"] as String
        val company= jsonData["company"] as String
        val cusPhone= jsonData["cusPhone"] as String
        val cusAddress= jsonData["cusAddress"] as String


        val route= jsonData["route"] as String
        val pickUp= jsonData["pickUp"] as String
        val dropOff= jsonData["dropOff"] as String
        val depDateTime= jsonData["depDateTime"] as String
        val retDateTime= jsonData["retDateTime"] as String
        val remark= jsonData["remark"] as String


        val fleetType= jsonData["fleetType"] as String
        val ftMaker= jsonData["ftMaker"] as String
        val seatCapacity= jsonData["seatCapacity"] as String
        val coachNo= jsonData["coachNo"] as String

        val rentPrice= jsonData["rentPrice"] as String
        val amountPaid= jsonData["amountPaid"] as String
        val amountDue= jsonData["amountDue"] as String
        val servedBy= jsonData["servedBy"] as String
        val printDate = jsonData["printDate"] as String

        val vcode= jsonData["vcode"] as String
        val qrData= jsonData["qrData"] as String

        val findUs= jsonData["findUs"] as String
        val downloadApp= jsonData["downloadApp"] as String


        var content: String ="**SPECIAL HIRE INVOICE**\n"
        if (bTitle != "") {
            content += "$bTitle\n"
        }
        if (address != "") {
            content += "$address\n"
        }
        if (email != "") {
            content += "Email: $email\n"
        }
        if (tel != "") {
            content += "Tel: $tel\n"
        }
        content += "TIN: "
        content += if (tin != "") {
            "$tin\n"
        }else{
            "\n"
        }
        content += "VRN: "
        content += if (vrn != "") {
            "$vrn\n"
        }else{
            "\n"
        }

        Log.d("SunmiPrinterTask", "content: $content")
          content+="--------------------------------\n"




        var content2 = "SPECIAL HIRE NO: $spHireNo\n\n"
        content2+="CUSTOMER DETAILS\n"
        if(company != ""){
            content2+= "$company\n"
        }
        if(cusName != ""){
            content2+= "$cusName\n"
        }
        if(cusPhone != ""){
            content2+= "$cusPhone\n"
        }
        if(cusAddress != ""){
            content2+= "$cusAddress\n"
        }
        content2+= "\n"

        var content3 = "TRIP DETAILS\n"


        if(route != ""){
            content3+= "$route\n"
        }
        if(pickUp != ""){
            content3+= "Picking at: $pickUp\n"
        }
        if(dropOff != ""){
            content3+= "Dropping at: $dropOff\n"
        }
        if(depDateTime != ""){
            content3+= "Departure Date & time: $depDateTime\n"
        }
        if(retDateTime != ""){
            content3+= "Return Date & time: $retDateTime\n"
        }
        if(remark != ""){
            content3+= "Remark(Purpose): $remark\n"
        }
        content3+= "\n"

        var content4= "FLEET DETAILS\n"

        if(coachNo != ""){
            content4+= "Coach No: $coachNo\n"
        }
        if(fleetType != ""){
            content4+= "Class: $fleetType\n"
        }
        if(ftMaker != ""){
            content4+= "Maker: $ftMaker\n"
        }
        if(seatCapacity != ""){
            content4+= "Seat capacity: $seatCapacity\n"
        }

        content4+= "\n"

        var content5= "PAYMENT DETAILS\n"

        if(rentPrice != ""){
            content5+= "Rent price: $rentPrice\n"

        }
        if(amountPaid != ""){
            content5+= "Amount paid: $amountPaid\n"

        }
        if(amountDue != ""){
            content5+= "Amount due: $amountDue\n"

        }

        if(servedBy != ""){
            content5+= "Served by: $servedBy\n"
        }
        if(printDate != ""){
            content5+= "Print at: $printDate\n"
        }

        if(vcode!=""){
            content5+="--------------------------------\n"
            content5+="Receipt Verification Code\n$vcode\n\n"
        }

        var content7=""
        content7+="--------------------------------\n"
        if(findUs != ""){
            content7+= "Find us: $findUs\n"
        }
        if(downloadApp != ""){
            content7+= "Download our app: $downloadApp\n"
        }
        content7+= "\n"






        val size: Float = 24.0F



        SunmiPrintHelper.getInstance().printText(content, size, false, false)
        SunmiPrintHelper.getInstance().printText(content2, size, false, false)
        SunmiPrintHelper.getInstance().printText(content3, size, false, false)
        SunmiPrintHelper.getInstance().printText(content4, size, false, false)
        SunmiPrintHelper.getInstance().printText(content5, size, false, false)
        if (qrData!="")
            SunmiPrintHelper.getInstance().printQr(qrData, 10, 1)
        SunmiPrintHelper.getInstance().printText(content7, size, false, false)
        SunmiPrintHelper.getInstance().feedPaper()
        viewLoadingDialog.dismiss()


    }

}