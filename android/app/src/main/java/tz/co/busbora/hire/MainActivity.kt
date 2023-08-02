package tz.co.busbora.hire

import android.content.Context
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.content.ContextWrapper
import android.content.Intent
import android.content.IntentFilter
import android.os.*
import android.util.Log
import android.widget.Toast
import tz.co.busbora.hire.sunmi_utils.BluetoothUtil
import tz.co.busbora.hire.utils.Q1Q2PrinterTask
import tz.co.busbora.hire.utils.ViewDialog
import tz.co.busbora.hire.utils.qtwopos.HandlerUtils
import com.iposprinter.iposprinterservice.IPosPrinterCallback
import io.flutter.embedding.engine.plugins.broadcastreceiver.BroadcastReceiverAware
import io.flutter.embedding.engine.plugins.broadcastreceiver.BroadcastReceiverPluginBinding

class MainActivity: FlutterActivity(), BroadcastReceiverAware {
    private val CHANNEL = "com.busbora.specialhire/printer"
    var sunmiPrinterTask =  SunmiPrinterTask();

    private val handler = Handler()


    private val MSG_TEST = 1
    private val MSG_IS_NORMAL = 2
    private val MSG_IS_BUSY = 3
    private val MSG_PAPER_LESS = 4
    private val MSG_PAPER_EXISTS = 5
    private val MSG_THP_HIGH_TEMP = 6
    private val MSG_THP_TEMP_NORMAL = 7
    private val MSG_MOTOR_HIGH_TEMP = 8
    private val MSG_MOTOR_HIGH_TEMP_INIT_PRINTER = 9
    private val MSG_CURRENT_TASK_PRINT_COMPLETE = 10

    private val PRINTER_NORMAL = 0
    private val PRINTER_PAPERLESS = 1
    private val PRINTER_THP_HIGH_TEMPERATURE = 2
    private val PRINTER_MOTOR_HIGH_TEMPERATURE = 3
    private val PRINTER_IS_BUSY = 4
    private val PRINTER_ERROR_UNKNOWN = 5

    public val iHandlerIntent =
        HandlerUtils.IHandlerIntent { msg ->

            Log.d("TAG", "onCreate: $msg")
            when (msg.what) {
                MSG_TEST -> {
                }
                MSG_IS_NORMAL -> if (Q1Q2PrinterTask().getPrinterStatus() == PRINTER_NORMAL) {
                    // loopPrint(loopPrintFlag)
                }
                MSG_IS_BUSY -> Toast.makeText(
                    this,
                    "Printer is working",
                    Toast.LENGTH_SHORT
                ).show()
                MSG_PAPER_LESS -> {
                   // loopPrintFlag = DEFAULT_LOOP_PRINT
                    Toast.makeText(
                        this,
                        "Printer is out of paper",
                        Toast.LENGTH_SHORT
                    ).show()
                }
                MSG_PAPER_EXISTS -> Toast.makeText(
                    this,
                    "Printer has paper",
                    Toast.LENGTH_SHORT
                ).show()
                MSG_THP_HIGH_TEMP -> Toast.makeText(
                    this,
                   "Printer is too hot, please wait for a while",
                    Toast.LENGTH_SHORT
                ).show()
                MSG_MOTOR_HIGH_TEMP -> {
                   // loopPrintFlag = DEFAULT_LOOP_PRINT
                    Toast.makeText(
                        this,
                       "Printer is too hot, please wait for a while",
                        Toast.LENGTH_SHORT
                    ).show()
                    handler!!.sendEmptyMessageDelayed(
                        MSG_MOTOR_HIGH_TEMP_INIT_PRINTER,
                        180000
                    ) //马达高温报警，等待3分钟后复位打印机
                }
                MSG_MOTOR_HIGH_TEMP_INIT_PRINTER -> Q1Q2PrinterTask().printerInit()
                MSG_CURRENT_TASK_PRINT_COMPLETE -> Toast.makeText(
                    this,
                    "Print complete",
                    Toast.LENGTH_SHORT
                ).show()
                else -> {
                }
            }
        }




    override fun onCreate(savedInstanceState: Bundle?, persistentState: PersistableBundle?) {
        super.onCreate(savedInstanceState, persistentState)
    }
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {

        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
                call, result ->
            if(call.method == "initialize"){
                val args = call.arguments as Map<*, *>
                val printerType = args["printerType"] as String
                Log.d("printerType", printerType)
                if(printerType == "Sunmi"){
                    SunmiPrinterTask.sunmiPrintHelper.initSunmiPrinterService(this)
                    Handler().postDelayed({
                        var rs= SunmiPrinterTask.sunmiPrintHelper.sunmiPrinter
                        Log.d("SunmiPrinterTask", rs.toString())

                        result.success(rs)
                    }, 1000)
                }
                else if (printerType == "Q1Q2") {


                    Q1Q2PrinterTask().pojQ1Q2Init(window, iHandlerIntent,this)
                    Handler().postDelayed({
                        var rs= Q1Q2PrinterTask().getPrinterStatus()
                        Log.d("Q1Q2PrinterTask", rs.toString())

                        result.success(rs)
                    }, 1000)
//                    Q1Q2PrinterTask().pojQ1Q2Init(window, iHandlerIntent,this,object :IPosPrinterCallback.Stub(){
//                        @Throws(RemoteException::class)
//                        override fun onRunResult(isSuccess: Boolean) {
//                         Log.e("IPosPrinterCallback", "IPosPrinterCallback:$isSuccess\n")
//                            var status=   Q1Q2PrinterTask().getPrinterStatus()
//                           Log.d("Q1Q2PrinterTask", status.toString())
//                             }
//
//                       @Throws(RemoteException::class)
//                        override fun onReturnString(value: String) {
//                            Log.e("IPosPrinterCallback", "IPosPrinterCallback:$value\n")
//                           var status=   Q1Q2PrinterTask().getPrinterStatus()
//                           Log.d("Q1Q2PrinterTask", status.toString())
//                            }
//
//                    })
//                    Handler().postDelayed({
//                          Q1Q2PrinterTask().printerInit()
//
//                        Handler().postDelayed({
//                            var status=   Q1Q2PrinterTask().getPrinterStatus()
//                            Log.d("Q1Q2PrinterTask", status.toString())
//
//
//                        }, 5000)
//                      //  result.success(status)
//                    }, 2000)

//                    var status=   Q1Q2PrinterTask().getPrinterStatus()
//                   Log.d("Q1Q2PrinterTask", status.toString())
//                    if(status == PRINTER_NORMAL) {
//                        result.success("Q1Q2")
//                    }else{
//                        result.success("No printer")
//                    }

                }
                else if(printerType=="Bluetooth"){
                    //TODO: call BTPrinterTask

                    BluetoothUtil.getDevice(BluetoothUtil.getBTAdapter())
                    Log.d("Bluetooth:->","$printerType printer init")
                }
                else{
                    result.success("No printer")
                }

            }
            else if(call.method == "printQuotation"){
                val args = call.arguments as Map<*, *>
                val printerType = args["printerType"] as String
                if(printerType == "Sunmi"){
                   var res= sunmiPrinterTask.initialize(this)
                    if(res == "Sunmi"){
                        sunmiPrinterTask.printQuotation(args["jsonData"] as HashMap<*, *>, this, this, ViewDialog(this))
                    }else{
                        Toast.makeText(this, res, Toast.LENGTH_SHORT).show()
                        Handler().postDelayed({
                           var rs= SunmiPrinterTask.sunmiPrintHelper.sunmiPrinter
                            Log.d("SunmiPrinterTask", rs.toString())
                           sunmiPrinterTask.printQuotation(args["jsonData"] as HashMap<*, *>, this, this, ViewDialog(this))
                        }, 2000)
                    }
                }else if (printerType == "Q1Q2") {
                    val status= Q1Q2PrinterTask().getPrinterStatus()
                    Log.d("Q1Q2PrinterTask", status.toString())
                    if(status == PRINTER_NORMAL) {
                        Q1Q2PrinterTask().printQuotation(
                            args["jsonData"] as HashMap<*, *>,
                            this,
                            this,
                            ViewDialog(this)
                        )
                    }else{
                        Toast.makeText(this, "No printer", Toast.LENGTH_SHORT).show()
                    }
                }

            }
            else if(call.method=="printPayment"){
                val args = call.arguments as Map<*, *>
                val printerType = args["printerType"] as String
                if(printerType=="Sunmi"){
                    var res= sunmiPrinterTask.initialize(this)
                    if(res == "Sunmi"){
                        sunmiPrinterTask.printPayment(args["jsonData"] as HashMap<*, *>, this, this, ViewDialog(this))
                    }else{
                        Toast.makeText(this, res, Toast.LENGTH_SHORT).show()
                        Handler().postDelayed({
                            var rs= SunmiPrinterTask.sunmiPrintHelper.sunmiPrinter
                            Log.d("SunmiPrinterTask", rs.toString())
                            sunmiPrinterTask.printPayment(args["jsonData"] as HashMap<*, *>, this, this, ViewDialog(this))
                        }, 2000)
                    }
                }else if(printerType=="Q1Q2"){

                    val status= Q1Q2PrinterTask().getPrinterStatus()
                    Log.d("Q1Q2PrinterTask", status.toString())
                    if(status == PRINTER_NORMAL) {
                        Q1Q2PrinterTask().printPayment(args["jsonData"] as HashMap<*, *>, this, this, ViewDialog(this))
                    }else{
                        Toast.makeText(this, "Printer is not ready", Toast.LENGTH_SHORT).show()
                    }
                }
                else{
                    //other printer
                }
            }

            else if(call.method=="printInvoice"){
                    val args = call.arguments as Map<*, *>
                    val printerType = args["printerType"] as String
                    if(printerType=="Sunmi"){
                        var res= sunmiPrinterTask.initialize(this)
                        if(res == "Sunmi"){
                            sunmiPrinterTask.printInvoice(args["jsonData"] as HashMap<*, *>, this, this, ViewDialog(this))
                        }else{
                            Toast.makeText(this, res, Toast.LENGTH_SHORT).show()
                            Handler().postDelayed({
                                var rs= SunmiPrinterTask.sunmiPrintHelper.sunmiPrinter
                                Log.d("SunmiPrinterTask", rs.toString())
                                sunmiPrinterTask.printInvoice(args["jsonData"] as HashMap<*, *>, this, this, ViewDialog(this))
                            }, 2000)
                        }
                    }else if(printerType=="Q1Q2"){

                        val status= Q1Q2PrinterTask().getPrinterStatus()
                        Log.d("Q1Q2PrinterTask", status.toString())
                        if(status == PRINTER_NORMAL) {
                            Q1Q2PrinterTask().printInvoice(args["jsonData"] as HashMap<*, *>, this, this, ViewDialog(this))
                        }else{
                            Toast.makeText(this, "Printer not found", Toast.LENGTH_SHORT).show()
                        }
                    }
                    else{
                        //other printer
                    }
                }

            else if(call.method=="printManifest"){
                    val args = call.arguments as Map<*, *>
                    val printerType = args["printerType"] as String
                    if(printerType=="Sunmi"){
                        var res= sunmiPrinterTask.initialize(this)
                        if(res == "Sunmi"){
                            sunmiPrinterTask.printManifest(args["jsonData"] as HashMap<*, *>, this, this, ViewDialog(this))
                        }else{
                            Toast.makeText(this, res, Toast.LENGTH_SHORT).show()
                            Handler().postDelayed({
                                var rs= SunmiPrinterTask.sunmiPrintHelper.sunmiPrinter
                                Log.d("SunmiPrinterTask", rs.toString())
                                sunmiPrinterTask.printManifest(args["jsonData"] as HashMap<*, *>, this, this, ViewDialog(this))
                            }, 2000)
                        }
                    }
                    else if(printerType=="Q1Q2"){

                        val status= Q1Q2PrinterTask().getPrinterStatus()
                        Log.d("Q1Q2PrinterTask", status.toString())
                        if(status == PRINTER_NORMAL) {
                            Q1Q2PrinterTask().printManifest(args["jsonData"] as HashMap<*, *>, this, this, ViewDialog(this))
                        }else{
                            Toast.makeText(this, "Printer not found", Toast.LENGTH_SHORT).show()
                        }
                    }
                    else{
                        //other printer
                    }
                }
            else if(call.method=="printTransactionHistory"){
                    val args = call.arguments as Map<*, *>
                    val printerType = args["printerType"] as String
                    if(printerType=="Sunmi"){
                        var res= sunmiPrinterTask.initialize(this)
                        if(res == "Sunmi"){
                            sunmiPrinterTask.printTransactionHistory(args["jsonData"] as HashMap<*, *>, this, this, ViewDialog(this))
                        }else{
                            Toast.makeText(this, res, Toast.LENGTH_SHORT).show()
                            Handler().postDelayed({
                                var rs= SunmiPrinterTask.sunmiPrintHelper.sunmiPrinter
                                Log.d("SunmiPrinterTask", rs.toString())
                                sunmiPrinterTask.printTransactionHistory(args["jsonData"] as HashMap<*, *>, this, this, ViewDialog(this))
                            }, 2000)
                        }
                    }
                    else if(printerType=="Q1Q2"){

                        val status= Q1Q2PrinterTask().getPrinterStatus()
                        Log.d("Q1Q2PrinterTask", status.toString())
                        if(status == PRINTER_NORMAL) {
                            Q1Q2PrinterTask().printTransactionHistory(args["jsonData"] as HashMap<*, *>, this, this, ViewDialog(this))
                        }else{
                            Toast.makeText(this, "Printer not found", Toast.LENGTH_SHORT).show()
                        }
                    }
                    else{
                        //other printer
                    }
                }

            else {
                result.notImplemented()
            }
        }
    }

    override fun onResume() {
        try{
            Q1Q2PrinterTask().bindService(this)
        }catch (e:Exception){
            e.printStackTrace()
        }
        super.onResume()
    }

    override fun onPause() {
        try{
            Q1Q2PrinterTask().unbindService(this)
        }catch (e:Exception){
            e.printStackTrace()
        }
        super.onPause()
    }


    override fun onDestroy() {
        try{
            Q1Q2PrinterTask().unbindService(this)
        }catch (e:Exception){
            e.printStackTrace()
        }
        super.onDestroy()
    }
    override fun onStop() {
        try{
            Q1Q2PrinterTask().unbindService(this)
        }catch (e:Exception){
            e.printStackTrace()
        }

        super.onStop()
    }




    private fun getBatteryLevel(): Int {
        val batteryLevel: Int
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            val batteryManager = getSystemService(Context.BATTERY_SERVICE) as BatteryManager
            batteryLevel = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
        } else {
            val intent = ContextWrapper(applicationContext).registerReceiver(null, IntentFilter(Intent.ACTION_BATTERY_CHANGED))
            batteryLevel = intent!!.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) * 100 / intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1)
        }

        return batteryLevel
    }

    override fun onAttachedToBroadcastReceiver(binding: BroadcastReceiverPluginBinding) {
        Log.d("oReceiver", "onAttachedToBroadcastReceiver")
    }

    override fun onDetachedFromBroadcastReceiver() {
        Log.d("oReceiver", "onDetachedFromBroadcastReceiver")
    }
}
