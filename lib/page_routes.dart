import 'package:appscwl_specialhire/customewidgets/printer/connect_bluetooth_devices.dart';
import 'package:appscwl_specialhire/pages/add_quotation/add_contact_information_page.dart';
import 'package:appscwl_specialhire/pages/add_quotation/add_fleet_details_page.dart';
import 'package:appscwl_specialhire/pages/add_quotation/add_journey_information_page.dart';
import 'package:appscwl_specialhire/pages/add_quotation/quotation_add_page.dart';
import 'package:appscwl_specialhire/pages/home_page.dart';
import 'package:appscwl_specialhire/pages/launcher_page.dart';
import 'package:appscwl_specialhire/pages/login_page.dart';
import 'package:appscwl_specialhire/pages/profile/profile_page.dart';
import 'package:appscwl_specialhire/pages/reservation/expense_add_page.dart';
import 'package:appscwl_specialhire/pages/reservation/r_sheet_page.dart';
import 'package:appscwl_specialhire/pages/reservation/reservation_list_page.dart';
import 'package:appscwl_specialhire/pages/reservation/seat_view_page.dart';
import 'package:appscwl_specialhire/pages/reservation/transition_history_page.dart';
import 'package:appscwl_specialhire/pages/side_menu/about_us_page.dart';
import 'package:appscwl_specialhire/pages/side_menu/contact_us_page.dart';
import 'package:appscwl_specialhire/pages/side_menu/terms_and_conditions_page.dart';
import 'package:appscwl_specialhire/pages/side_menu/vehicle_register_page.dart';
import 'package:appscwl_specialhire/pages/view_quotation/quotation_details_page.dart';
import 'package:appscwl_specialhire/pages/view_quotation/quotation_list_page.dart';

import 'customewidgets/search/choose_districts.dart';

final routes = {
  HomePage.routeName: (context) => const HomePage(),
  LauncherPage.routeName: (context) => const LauncherPage(),
  ReservationListPage.routeName: (context) => const ReservationListPage(),
  QuotationAddPage.routeName: (context) => const QuotationAddPage(),
  AddContactInformationPage.routeName: (context) =>
      const AddContactInformationPage(),
  AddJourneyInformationPage.routeName: (context) =>
      const AddJourneyInformationPage(),
  AddFleetDetailsPage.routeName: (context) => const AddFleetDetailsPage(),
  QuotationListPage.routeName: (context) => const QuotationListPage(),
  QuotationOrReservationDetails.routeName: (context) =>
      const QuotationOrReservationDetails(),
  LoginPage.routeName: (context) => const LoginPage(),
  ProfilePage.routeName: (context) => const ProfilePage(),
  ChooseDistricts.routeName: (context) => const ChooseDistricts(),
  TransitionHistoryPage.routeName: (context) => const TransitionHistoryPage(),
  ExpanseAddPage.routeName: (context) => const ExpanseAddPage(),
  RSheet.routeName: (context) => const RSheet(),
  VehicleRegisterPage.routeName: (context) => const VehicleRegisterPage(),
  AboutUsPage.routeName: (context) => const AboutUsPage(),
  ContactUsPage.routeName: (context) => const ContactUsPage(),
  TermsAndConditionPage.routeName: (context) => const TermsAndConditionPage(),
  SeatViewPage.routeName: (context) => SeatViewPage(),
  ConnectBluetoothDevices.routeName: (context) =>
      const ConnectBluetoothDevices(),
};
