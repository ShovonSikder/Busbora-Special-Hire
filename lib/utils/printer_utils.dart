class PrinterUtils{

  static String NO_PRINTER = "no_printer";
  static String getPrinterType(PrinterType type){
    switch(type){
      case PrinterType.Sunmi:
        return "Sunmi";
      case PrinterType.Q1Q2:
        return "Q1Q2";
      case PrinterType.BLUETOOTH:
        return "Bluetooth";
      default:
        return "no_printer";
    }
  }

  static String getIntToStringOfPrinterType(int type){
    switch(type){
      case 1:
        return "Sunmi";
      case 2:
        return "Q1Q2";
      case 3:
        return "Bluetooth";
      case 0:
        return "no_printer";
      default:
        return "no_printer";
    }
  }

  static int getStringToIntOfPrinterType(String type){
    switch(type){
      case "Sunmi":
        return 1;
      case "Q1Q2":
        return 2;
      case "Bluetooth":
        return 3;
      case "no_printer":
        return 0;
      default:
        return 0;
    }
  }

  static int getPrinterTypeInt(PrinterType type){
    switch(type){
      case PrinterType.Sunmi:
        return 1;
      case PrinterType.Q1Q2:
        return 2;
      case PrinterType.BLUETOOTH:
        return 3;
      case PrinterType.NoPrinter:
        return 0;
      default:
        return 0;
    }
  }


}



enum PrinterType{
  Sunmi,
  Q1Q2,
  BLUETOOTH,
  NoPrinter
}