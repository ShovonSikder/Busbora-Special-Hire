
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

/// Callers can lookup localized strings with an instance of AppLocalizations returned
/// by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// localizationDelegates list, and the locales they support in the app's
/// supportedLocales list. For example:
///
/// ```
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en')
  ];

  /// No description provided for @reservation_quotation_add.
  ///
  /// In en, this message translates to:
  /// **'Add Quotation'**
  String get reservation_quotation_add;

  /// No description provided for @num_1.
  ///
  /// In en, this message translates to:
  /// **'1'**
  String get num_1;

  /// No description provided for @num_2.
  ///
  /// In en, this message translates to:
  /// **'2'**
  String get num_2;

  /// No description provided for @num_3.
  ///
  /// In en, this message translates to:
  /// **'3'**
  String get num_3;

  /// No description provided for @contact_information.
  ///
  /// In en, this message translates to:
  /// **'Contact Information'**
  String get contact_information;

  /// No description provided for @journey_information.
  ///
  /// In en, this message translates to:
  /// **'Journey Information'**
  String get journey_information;

  /// No description provided for @fleet_details.
  ///
  /// In en, this message translates to:
  /// **'Fleet Details'**
  String get fleet_details;

  /// No description provided for @sub_total.
  ///
  /// In en, this message translates to:
  /// **'Sub Total'**
  String get sub_total;

  /// No description provided for @discount.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get discount;

  /// No description provided for @total_payable.
  ///
  /// In en, this message translates to:
  /// **'Total Payable'**
  String get total_payable;

  /// No description provided for @advance.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get advance;

  /// No description provided for @due.
  ///
  /// In en, this message translates to:
  /// **'Due'**
  String get due;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @add_missing_information.
  ///
  /// In en, this message translates to:
  /// **'Add Missing Information'**
  String get add_missing_information;

  /// No description provided for @add_contact_information.
  ///
  /// In en, this message translates to:
  /// **'Contact Information'**
  String get add_contact_information;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @company_name.
  ///
  /// In en, this message translates to:
  /// **'Company'**
  String get company_name;

  /// No description provided for @mobile.
  ///
  /// In en, this message translates to:
  /// **'Mobile'**
  String get mobile;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @remarks.
  ///
  /// In en, this message translates to:
  /// **'Remarks'**
  String get remarks;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @insert.
  ///
  /// In en, this message translates to:
  /// **'Insert'**
  String get insert;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @create_reservation.
  ///
  /// In en, this message translates to:
  /// **'Create Hire'**
  String get create_reservation;

  /// No description provided for @add_journey_information.
  ///
  /// In en, this message translates to:
  /// **'Journey Information'**
  String get add_journey_information;

  /// No description provided for @add_fleet_details.
  ///
  /// In en, this message translates to:
  /// **'Add Fleet Details'**
  String get add_fleet_details;

  /// No description provided for @pick_up_address.
  ///
  /// In en, this message translates to:
  /// **'Pick Up Address'**
  String get pick_up_address;

  /// No description provided for @dropping_address.
  ///
  /// In en, this message translates to:
  /// **'Dropping Address'**
  String get dropping_address;

  /// No description provided for @select.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get select;

  /// No description provided for @origin.
  ///
  /// In en, this message translates to:
  /// **'Origin'**
  String get origin;

  /// No description provided for @destination.
  ///
  /// In en, this message translates to:
  /// **'Destination'**
  String get destination;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @journey_date.
  ///
  /// In en, this message translates to:
  /// **'J date'**
  String get journey_date;

  /// No description provided for @return_date.
  ///
  /// In en, this message translates to:
  /// **'R date'**
  String get return_date;

  /// No description provided for @one_way.
  ///
  /// In en, this message translates to:
  /// **'One Way'**
  String get one_way;

  /// No description provided for @with_return.
  ///
  /// In en, this message translates to:
  /// **'With return'**
  String get with_return;

  /// No description provided for @select_district.
  ///
  /// In en, this message translates to:
  /// **'Select district'**
  String get select_district;

  /// No description provided for @fleet_type.
  ///
  /// In en, this message translates to:
  /// **'Fleet type'**
  String get fleet_type;

  /// No description provided for @select_makers.
  ///
  /// In en, this message translates to:
  /// **'Select makers'**
  String get select_makers;

  /// No description provided for @makers.
  ///
  /// In en, this message translates to:
  /// **'Makers'**
  String get makers;

  /// No description provided for @seat_temp.
  ///
  /// In en, this message translates to:
  /// **'Seat temp'**
  String get seat_temp;

  /// No description provided for @fleet_makers.
  ///
  /// In en, this message translates to:
  /// **'Fleet maker'**
  String get fleet_makers;

  /// No description provided for @num_of_seat.
  ///
  /// In en, this message translates to:
  /// **'Number of seats'**
  String get num_of_seat;

  /// No description provided for @action.
  ///
  /// In en, this message translates to:
  /// **'Action'**
  String get action;

  /// No description provided for @num_0.
  ///
  /// In en, this message translates to:
  /// **'0'**
  String get num_0;

  /// No description provided for @quotation_list.
  ///
  /// In en, this message translates to:
  /// **'Quotation'**
  String get quotation_list;

  /// No description provided for @r.
  ///
  /// In en, this message translates to:
  /// **'R'**
  String get r;

  /// No description provided for @view.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get view;

  /// No description provided for @create_special_hire.
  ///
  /// In en, this message translates to:
  /// **'Create hire'**
  String get create_special_hire;

  /// No description provided for @actions.
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get actions;

  /// No description provided for @print.
  ///
  /// In en, this message translates to:
  /// **'Print'**
  String get print;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// No description provided for @contact_require.
  ///
  /// In en, this message translates to:
  /// **'Contact Information Field is required'**
  String get contact_require;

  /// No description provided for @journey_require.
  ///
  /// In en, this message translates to:
  /// **'Journey Information is required'**
  String get journey_require;

  /// No description provided for @fleet_require.
  ///
  /// In en, this message translates to:
  /// **'Fleet is required'**
  String get fleet_require;

  /// No description provided for @fleet_type_require.
  ///
  /// In en, this message translates to:
  /// **'Please Select Fleet Type'**
  String get fleet_type_require;

  /// No description provided for @makers_require.
  ///
  /// In en, this message translates to:
  /// **'Please Select Fleet Maker'**
  String get makers_require;

  /// No description provided for @seat_require.
  ///
  /// In en, this message translates to:
  /// **'Please Select Seat Template'**
  String get seat_require;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'Ok'**
  String get ok;

  /// No description provided for @origin_require.
  ///
  /// In en, this message translates to:
  /// **'Origin is required'**
  String get origin_require;

  /// No description provided for @destination_require.
  ///
  /// In en, this message translates to:
  /// **'Destination is required'**
  String get destination_require;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @from.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get from;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Choose Date'**
  String get date;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get or;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @please_wait.
  ///
  /// In en, this message translates to:
  /// **'Please wait'**
  String get please_wait;

  /// No description provided for @special_hire.
  ///
  /// In en, this message translates to:
  /// **'Special Hire'**
  String get special_hire;

  /// No description provided for @special_hire_quotation.
  ///
  /// In en, this message translates to:
  /// **'Special hire quotation'**
  String get special_hire_quotation;

  /// No description provided for @quotation_no.
  ///
  /// In en, this message translates to:
  /// **'Quotation no'**
  String get quotation_no;

  /// No description provided for @to.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get to;

  /// No description provided for @departure.
  ///
  /// In en, this message translates to:
  /// **'Departure'**
  String get departure;

  /// No description provided for @rent.
  ///
  /// In en, this message translates to:
  /// **'Rent'**
  String get rent;

  /// No description provided for @pickup_required.
  ///
  /// In en, this message translates to:
  /// **'Pickup address required'**
  String get pickup_required;

  /// No description provided for @dropping_required.
  ///
  /// In en, this message translates to:
  /// **'Dropping address required'**
  String get dropping_required;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @quotation.
  ///
  /// In en, this message translates to:
  /// **'Quotations'**
  String get quotation;

  /// No description provided for @quotation_1.
  ///
  /// In en, this message translates to:
  /// **'Quotation'**
  String get quotation_1;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @accounts.
  ///
  /// In en, this message translates to:
  /// **'Accounts'**
  String get accounts;

  /// No description provided for @information.
  ///
  /// In en, this message translates to:
  /// **'Information'**
  String get information;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @mobile_required.
  ///
  /// In en, this message translates to:
  /// **'Mobile is required'**
  String get mobile_required;

  /// No description provided for @name_required.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get name_required;

  /// No description provided for @expense.
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get expense;

  /// No description provided for @pay.
  ///
  /// In en, this message translates to:
  /// **'Pay'**
  String get pay;

  /// No description provided for @r_sheet.
  ///
  /// In en, this message translates to:
  /// **'R sheet'**
  String get r_sheet;

  /// No description provided for @please_confirm.
  ///
  /// In en, this message translates to:
  /// **'Please Confirm'**
  String get please_confirm;

  /// No description provided for @confirm_reservation_msg.
  ///
  /// In en, this message translates to:
  /// **'Do you want to create special hire?'**
  String get confirm_reservation_msg;

  /// No description provided for @confirm_quotation_msg.
  ///
  /// In en, this message translates to:
  /// **'Do you want to create this quotation?'**
  String get confirm_quotation_msg;

  /// No description provided for @confirm_quotation_update_msg.
  ///
  /// In en, this message translates to:
  /// **'Do you want to update this quotation?'**
  String get confirm_quotation_update_msg;

  /// No description provided for @reservation_creation_success.
  ///
  /// In en, this message translates to:
  /// **'Special Hire created successfully'**
  String get reservation_creation_success;

  /// No description provided for @quotation_creation_success.
  ///
  /// In en, this message translates to:
  /// **'Quotation created successfully'**
  String get quotation_creation_success;

  /// No description provided for @quotation_update_success.
  ///
  /// In en, this message translates to:
  /// **'Quotation updated successfully'**
  String get quotation_update_success;

  /// No description provided for @login_expired.
  ///
  /// In en, this message translates to:
  /// **'Login Expired. Please login again'**
  String get login_expired;

  /// No description provided for @no_quotation_data_found.
  ///
  /// In en, this message translates to:
  /// **'No Special Hire quotation found'**
  String get no_quotation_data_found;

  /// No description provided for @no_reservation_data_found.
  ///
  /// In en, this message translates to:
  /// **'No Special Hire found'**
  String get no_reservation_data_found;

  /// No description provided for @add_quotation.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add_quotation;

  /// No description provided for @username_required.
  ///
  /// In en, this message translates to:
  /// **'Username required'**
  String get username_required;

  /// No description provided for @password_required.
  ///
  /// In en, this message translates to:
  /// **'Password required'**
  String get password_required;

  /// No description provided for @enter_valid_rent.
  ///
  /// In en, this message translates to:
  /// **'Enter valid rent amount'**
  String get enter_valid_rent;

  /// No description provided for @no_fleet_selected.
  ///
  /// In en, this message translates to:
  /// **'No Fleet Selected'**
  String get no_fleet_selected;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @no_data_found.
  ///
  /// In en, this message translates to:
  /// **'No data found'**
  String get no_data_found;

  /// No description provided for @deleting.
  ///
  /// In en, this message translates to:
  /// **'Deleting...'**
  String get deleting;

  /// No description provided for @deleted_success.
  ///
  /// In en, this message translates to:
  /// **'Deleted successfully'**
  String get deleted_success;

  /// No description provided for @delete_confirm_msg.
  ///
  /// In en, this message translates to:
  /// **'Are you sure to DELETE?'**
  String get delete_confirm_msg;

  /// No description provided for @receive.
  ///
  /// In en, this message translates to:
  /// **'Receive'**
  String get receive;

  /// No description provided for @received.
  ///
  /// In en, this message translates to:
  /// **'Received'**
  String get received;

  /// No description provided for @return_p.
  ///
  /// In en, this message translates to:
  /// **'Return'**
  String get return_p;

  /// No description provided for @returned_p.
  ///
  /// In en, this message translates to:
  /// **'Returned'**
  String get returned_p;

  /// No description provided for @receive_amount.
  ///
  /// In en, this message translates to:
  /// **'Receive Amount'**
  String get receive_amount;

  /// No description provided for @return_amount.
  ///
  /// In en, this message translates to:
  /// **'Return Amount'**
  String get return_amount;

  /// No description provided for @note.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get note;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @cant_receive.
  ///
  /// In en, this message translates to:
  /// **'Can\'t receive more than'**
  String get cant_receive;

  /// No description provided for @cant_return.
  ///
  /// In en, this message translates to:
  /// **'Can\'t return more than'**
  String get cant_return;

  /// No description provided for @amount_cant_negative.
  ///
  /// In en, this message translates to:
  /// **'Amount can\'t be negative'**
  String get amount_cant_negative;

  /// No description provided for @amount_required.
  ///
  /// In en, this message translates to:
  /// **'Amount required for transaction '**
  String get amount_required;

  /// No description provided for @no_need_to_pay.
  ///
  /// In en, this message translates to:
  /// **'No need to transaction for 0 amount'**
  String get no_need_to_pay;

  /// No description provided for @enter_valid_digit.
  ///
  /// In en, this message translates to:
  /// **'Enter valid number'**
  String get enter_valid_digit;

  /// No description provided for @transition.
  ///
  /// In en, this message translates to:
  /// **'Transaction'**
  String get transition;

  /// No description provided for @transition_success.
  ///
  /// In en, this message translates to:
  /// **'Transaction Success'**
  String get transition_success;

  /// No description provided for @confirm_transition.
  ///
  /// In en, this message translates to:
  /// **'Would you like to make this transaction?'**
  String get confirm_transition;

  /// No description provided for @id.
  ///
  /// In en, this message translates to:
  /// **'ID'**
  String get id;

  /// No description provided for @transition_history.
  ///
  /// In en, this message translates to:
  /// **'Transaction History'**
  String get transition_history;

  /// No description provided for @something_went_wrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get something_went_wrong;

  /// No description provided for @time_out.
  ///
  /// In en, this message translates to:
  /// **'Request time out. Try again'**
  String get time_out;

  /// No description provided for @no_internet.
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get no_internet;

  /// No description provided for @firebase_exception.
  ///
  /// In en, this message translates to:
  /// **'Can\'t connect to firebase. Check your internet connection and try again'**
  String get firebase_exception;

  /// No description provided for @special_hire_no.
  ///
  /// In en, this message translates to:
  /// **'Special hire no'**
  String get special_hire_no;

  /// No description provided for @contact_person.
  ///
  /// In en, this message translates to:
  /// **'Contact Person'**
  String get contact_person;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @particular.
  ///
  /// In en, this message translates to:
  /// **'Particular'**
  String get particular;

  /// No description provided for @user.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get user;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @no_history.
  ///
  /// In en, this message translates to:
  /// **'No History found'**
  String get no_history;

  /// No description provided for @special_hire_expense.
  ///
  /// In en, this message translates to:
  /// **'Special hire expense'**
  String get special_hire_expense;

  /// No description provided for @route.
  ///
  /// In en, this message translates to:
  /// **'Route'**
  String get route;

  /// No description provided for @add_expense.
  ///
  /// In en, this message translates to:
  /// **'Add Expense'**
  String get add_expense;

  /// No description provided for @fleet_list_empty.
  ///
  /// In en, this message translates to:
  /// **'Fleet list empty'**
  String get fleet_list_empty;

  /// No description provided for @driver_amount.
  ///
  /// In en, this message translates to:
  /// **'Driver amount'**
  String get driver_amount;

  /// No description provided for @helper_amount.
  ///
  /// In en, this message translates to:
  /// **'Helper amount'**
  String get helper_amount;

  /// No description provided for @guide_amount.
  ///
  /// In en, this message translates to:
  /// **'Guide amount'**
  String get guide_amount;

  /// No description provided for @fleet.
  ///
  /// In en, this message translates to:
  /// **'Fleet'**
  String get fleet;

  /// No description provided for @driver.
  ///
  /// In en, this message translates to:
  /// **'Driver'**
  String get driver;

  /// No description provided for @helper.
  ///
  /// In en, this message translates to:
  /// **'Helper'**
  String get helper;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @sure_want_to_logout.
  ///
  /// In en, this message translates to:
  /// **'Do you want to log out?'**
  String get sure_want_to_logout;

  /// No description provided for @exit_app.
  ///
  /// In en, this message translates to:
  /// **'Press back again to exit'**
  String get exit_app;

  /// No description provided for @guide.
  ///
  /// In en, this message translates to:
  /// **'Guide'**
  String get guide;

  /// No description provided for @select_fleet.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get select_fleet;

  /// No description provided for @save_expense_confirm.
  ///
  /// In en, this message translates to:
  /// **'Saving expense for'**
  String get save_expense_confirm;

  /// No description provided for @expense_added.
  ///
  /// In en, this message translates to:
  /// **'Expense added successfully'**
  String get expense_added;

  /// No description provided for @no_fleet_found.
  ///
  /// In en, this message translates to:
  /// **'No fleet found'**
  String get no_fleet_found;

  /// No description provided for @seat_view.
  ///
  /// In en, this message translates to:
  /// **'Seat view'**
  String get seat_view;

  /// No description provided for @save_passenger_info_confirm.
  ///
  /// In en, this message translates to:
  /// **'Saving this passenger information'**
  String get save_passenger_info_confirm;

  /// No description provided for @saved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get saved;

  /// No description provided for @name_number_validation_msg.
  ///
  /// In en, this message translates to:
  /// **'Name and number both required for seat'**
  String get name_number_validation_msg;

  /// No description provided for @reload.
  ///
  /// In en, this message translates to:
  /// **'Reload'**
  String get reload;

  /// No description provided for @fo_r.
  ///
  /// In en, this message translates to:
  /// **'for'**
  String get fo_r;

  /// No description provided for @reservation_sheet.
  ///
  /// In en, this message translates to:
  /// **'Special hire sheet'**
  String get reservation_sheet;

  /// No description provided for @sheet.
  ///
  /// In en, this message translates to:
  /// **'Sheet'**
  String get sheet;

  /// No description provided for @update_quotation.
  ///
  /// In en, this message translates to:
  /// **'Update Quotation'**
  String get update_quotation;

  /// No description provided for @update_reservation.
  ///
  /// In en, this message translates to:
  /// **'Update Special hire'**
  String get update_reservation;

  /// No description provided for @special_hire_list.
  ///
  /// In en, this message translates to:
  /// **'Special Hire List'**
  String get special_hire_list;

  /// No description provided for @rent_price.
  ///
  /// In en, this message translates to:
  /// **'Rent price'**
  String get rent_price;

  /// No description provided for @advance_payment.
  ///
  /// In en, this message translates to:
  /// **'Advance payment'**
  String get advance_payment;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @coach_no.
  ///
  /// In en, this message translates to:
  /// **'Coach no'**
  String get coach_no;

  /// No description provided for @coach_required.
  ///
  /// In en, this message translates to:
  /// **'Please select coach no'**
  String get coach_required;

  /// No description provided for @unpaid.
  ///
  /// In en, this message translates to:
  /// **'Unpaid'**
  String get unpaid;

  /// No description provided for @full_paid.
  ///
  /// In en, this message translates to:
  /// **'Full paid'**
  String get full_paid;

  /// No description provided for @register_here.
  ///
  /// In en, this message translates to:
  /// **'Register here'**
  String get register_here;

  /// No description provided for @contact_us.
  ///
  /// In en, this message translates to:
  /// **'Contact us'**
  String get contact_us;

  /// No description provided for @about_us.
  ///
  /// In en, this message translates to:
  /// **'About us'**
  String get about_us;

  /// No description provided for @term_con.
  ///
  /// In en, this message translates to:
  /// **'Terms and Conditions'**
  String get term_con;

  /// No description provided for @contact_office.
  ///
  /// In en, this message translates to:
  /// **'Corporate Head Office'**
  String get contact_office;

  /// No description provided for @contact_company.
  ///
  /// In en, this message translates to:
  /// **'Busbora Company Limited'**
  String get contact_company;

  /// No description provided for @contact_pobox.
  ///
  /// In en, this message translates to:
  /// **'16883 Arusha'**
  String get contact_pobox;

  /// No description provided for @contact_mail.
  ///
  /// In en, this message translates to:
  /// **'Info@busbora.co.tz'**
  String get contact_mail;

  /// No description provided for @contact_phone.
  ///
  /// In en, this message translates to:
  /// **'+255 783 446 663'**
  String get contact_phone;

  /// No description provided for @contact_office_2.
  ///
  /// In en, this message translates to:
  /// **'Dar es salaam contacts'**
  String get contact_office_2;

  /// No description provided for @contact_office_2_phone.
  ///
  /// In en, this message translates to:
  /// **'+255 676 457 047'**
  String get contact_office_2_phone;

  /// No description provided for @contact_office_22_phone.
  ///
  /// In en, this message translates to:
  /// **'+255 738 800 803'**
  String get contact_office_22_phone;

  /// No description provided for @contact_office_3.
  ///
  /// In en, this message translates to:
  /// **'Mwanza Contacts'**
  String get contact_office_3;

  /// No description provided for @contact_office_3_phone.
  ///
  /// In en, this message translates to:
  /// **'+255 719 172 399'**
  String get contact_office_3_phone;

  /// No description provided for @register_page_title.
  ///
  /// In en, this message translates to:
  /// **'REGISTER YOUR VEHICLE'**
  String get register_page_title;

  /// No description provided for @full_name.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get full_name;

  /// No description provided for @address_req.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address_req;

  /// No description provided for @telephone.
  ///
  /// In en, this message translates to:
  /// **'Telephone'**
  String get telephone;

  /// No description provided for @tin.
  ///
  /// In en, this message translates to:
  /// **'Taxpayer Registration Number (TIN)'**
  String get tin;

  /// No description provided for @tin_attachment.
  ///
  /// In en, this message translates to:
  /// **'Taxpayer Identification Number (TIN)'**
  String get tin_attachment;

  /// No description provided for @owner_details.
  ///
  /// In en, this message translates to:
  /// **'Owner details (from Motor Vehicle registration card)'**
  String get owner_details;

  /// No description provided for @vehicle_details.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Details (from Motor Vehicle registration card)'**
  String get vehicle_details;

  /// No description provided for @maker_req.
  ///
  /// In en, this message translates to:
  /// **'Maker'**
  String get maker_req;

  /// No description provided for @plate_number.
  ///
  /// In en, this message translates to:
  /// **'Registration Number(Plate number)'**
  String get plate_number;

  /// No description provided for @passenger_seat.
  ///
  /// In en, this message translates to:
  /// **'Total passenger Seat'**
  String get passenger_seat;

  /// No description provided for @contact_details.
  ///
  /// In en, this message translates to:
  /// **'Contact details'**
  String get contact_details;

  /// No description provided for @email_account.
  ///
  /// In en, this message translates to:
  /// **'Email account'**
  String get email_account;

  /// No description provided for @phone_number.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phone_number;

  /// No description provided for @attachment.
  ///
  /// In en, this message translates to:
  /// **' Attachments'**
  String get attachment;

  /// No description provided for @registration_card.
  ///
  /// In en, this message translates to:
  /// **'Registration Card'**
  String get registration_card;

  /// No description provided for @company_domain.
  ///
  /// In en, this message translates to:
  /// **'busbora.co.tz'**
  String get company_domain;

  /// No description provided for @address_required.
  ///
  /// In en, this message translates to:
  /// **'Address is required'**
  String get address_required;

  /// No description provided for @telephone_required.
  ///
  /// In en, this message translates to:
  /// **'Telephone is required'**
  String get telephone_required;

  /// No description provided for @phone_required.
  ///
  /// In en, this message translates to:
  /// **'Phone is required'**
  String get phone_required;

  /// No description provided for @tin_required.
  ///
  /// In en, this message translates to:
  /// **'TIN is required'**
  String get tin_required;

  /// No description provided for @plate_required.
  ///
  /// In en, this message translates to:
  /// **'Plate number is required'**
  String get plate_required;

  /// No description provided for @seat_info_required.
  ///
  /// In en, this message translates to:
  /// **'Seat info required'**
  String get seat_info_required;

  /// No description provided for @email_required.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get email_required;

  /// No description provided for @fill_required_msg.
  ///
  /// In en, this message translates to:
  /// **'Please fill up all the required(*) field'**
  String get fill_required_msg;

  /// No description provided for @vehicle_register_mail_subject.
  ///
  /// In en, this message translates to:
  /// **'REGISTER YOUR VEHICLE FOR SPECIAL HIRE'**
  String get vehicle_register_mail_subject;

  /// No description provided for @regards.
  ///
  /// In en, this message translates to:
  /// **'Regards'**
  String get regards;

  /// No description provided for @submit_success_msg.
  ///
  /// In en, this message translates to:
  /// **'Your application submitted successfully. Wait for approval'**
  String get submit_success_msg;

  /// No description provided for @discount_validation_msg.
  ///
  /// In en, this message translates to:
  /// **'Discount is not valid'**
  String get discount_validation_msg;

  /// No description provided for @advance_validation_msg.
  ///
  /// In en, this message translates to:
  /// **'Advance payment is not valid'**
  String get advance_validation_msg;

  /// No description provided for @select_printer.
  ///
  /// In en, this message translates to:
  /// **'Select Printer'**
  String get select_printer;

  /// No description provided for @sunmi.
  ///
  /// In en, this message translates to:
  /// **'Sunmi'**
  String get sunmi;

  /// No description provided for @q1.
  ///
  /// In en, this message translates to:
  /// **'Q1'**
  String get q1;

  /// No description provided for @no_printer.
  ///
  /// In en, this message translates to:
  /// **'No Printer'**
  String get no_printer;

  /// No description provided for @remember.
  ///
  /// In en, this message translates to:
  /// **'Remember'**
  String get remember;

  /// No description provided for @continue_.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continue_;

  /// No description provided for @contact_touch.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get contact_touch;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @current_language.
  ///
  /// In en, this message translates to:
  /// **'Current Language'**
  String get current_language;

  /// No description provided for @direct_reservation.
  ///
  /// In en, this message translates to:
  /// **'Direct hire'**
  String get direct_reservation;

  /// No description provided for @model.
  ///
  /// In en, this message translates to:
  /// **'Model'**
  String get model;

  /// No description provided for @model_required.
  ///
  /// In en, this message translates to:
  /// **'Model is required'**
  String get model_required;

  /// No description provided for @address_example.
  ///
  /// In en, this message translates to:
  /// **'e.g., Po.Box 300, Dodoma'**
  String get address_example;

  /// No description provided for @maker_example.
  ///
  /// In en, this message translates to:
  /// **'e.g., Toyota'**
  String get maker_example;

  /// No description provided for @model_example.
  ///
  /// In en, this message translates to:
  /// **'e.g., Coaster'**
  String get model_example;

  /// No description provided for @plate_example.
  ///
  /// In en, this message translates to:
  /// **'e.g., T221DHD'**
  String get plate_example;

  /// No description provided for @phone_example.
  ///
  /// In en, this message translates to:
  /// **'e.g., +255783446669'**
  String get phone_example;

  /// No description provided for @something_wrong_with_printer.
  ///
  /// In en, this message translates to:
  /// **'Something wrong in printing'**
  String get something_wrong_with_printer;

  /// No description provided for @downloading.
  ///
  /// In en, this message translates to:
  /// **'Downloading'**
  String get downloading;

  /// No description provided for @download.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get download;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @no_pdf_viewer_found.
  ///
  /// In en, this message translates to:
  /// **'No pdf viewer found'**
  String get no_pdf_viewer_found;

  /// No description provided for @journey_time.
  ///
  /// In en, this message translates to:
  /// **'J time'**
  String get journey_time;

  /// No description provided for @return_time.
  ///
  /// In en, this message translates to:
  /// **'R time'**
  String get return_time;

  /// No description provided for @request_storage_permission.
  ///
  /// In en, this message translates to:
  /// **'Please allow storage permission'**
  String get request_storage_permission;

  /// No description provided for @passenger_list.
  ///
  /// In en, this message translates to:
  /// **'Passenger list'**
  String get passenger_list;

  /// No description provided for @passenger_total.
  ///
  /// In en, this message translates to:
  /// **'Passenger total'**
  String get passenger_total;

  /// No description provided for @no_history_to_print.
  ///
  /// In en, this message translates to:
  /// **'No history to print'**
  String get no_history_to_print;

  /// No description provided for @bluetooth.
  ///
  /// In en, this message translates to:
  /// **'Bluetooth'**
  String get bluetooth;

  /// No description provided for @cant_connect_to_previous_device.
  ///
  /// In en, this message translates to:
  /// **'Can\'t connect to previous device. Please reconnect'**
  String get cant_connect_to_previous_device;

  /// No description provided for @connected.
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get connected;

  /// No description provided for @disconnected.
  ///
  /// In en, this message translates to:
  /// **'Disconnected'**
  String get disconnected;

  /// No description provided for @avl_bluetooth_devices.
  ///
  /// In en, this message translates to:
  /// **'Available devices'**
  String get avl_bluetooth_devices;

  /// No description provided for @no_device_found.
  ///
  /// In en, this message translates to:
  /// **'No device found'**
  String get no_device_found;

  /// No description provided for @searching_for_devices.
  ///
  /// In en, this message translates to:
  /// **'Searching for devices'**
  String get searching_for_devices;

  /// No description provided for @connect.
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get connect;

  /// No description provided for @disconnect.
  ///
  /// In en, this message translates to:
  /// **'Disconnect'**
  String get disconnect;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @cant_connect.
  ///
  /// In en, this message translates to:
  /// **'Can\'t connect'**
  String get cant_connect;

  /// No description provided for @try_auto_connect.
  ///
  /// In en, this message translates to:
  /// **'Trying to auto connect. Please wait'**
  String get try_auto_connect;

  /// No description provided for @check_printer_connection.
  ///
  /// In en, this message translates to:
  /// **'Printer may disconnected, Can\'t auto connect'**
  String get check_printer_connection;

  /// No description provided for @scan.
  ///
  /// In en, this message translates to:
  /// **'Scan'**
  String get scan;

  /// No description provided for @location_permission_required_blue.
  ///
  /// In en, this message translates to:
  /// **'Location permission required for scanning bluetooth devices'**
  String get location_permission_required_blue;

  /// No description provided for @bluetooth_permission_required.
  ///
  /// In en, this message translates to:
  /// **'Bluetooth permission is required'**
  String get bluetooth_permission_required;

  /// No description provided for @later.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get later;

  /// No description provided for @update_now.
  ///
  /// In en, this message translates to:
  /// **'Update Now'**
  String get update_now;

  /// No description provided for @update_app.
  ///
  /// In en, this message translates to:
  /// **'Update App'**
  String get update_app;

  /// No description provided for @update_available_msg.
  ///
  /// In en, this message translates to:
  /// **'A new version of this app is available. '**
  String get update_available_msg;

  /// No description provided for @your_current_version.
  ///
  /// In en, this message translates to:
  /// **'Your current version is'**
  String get your_current_version;

  /// No description provided for @new_version.
  ///
  /// In en, this message translates to:
  /// **'and the new version is'**
  String get new_version;

  /// No description provided for @please_update.
  ///
  /// In en, this message translates to:
  /// **'Please update the app'**
  String get please_update;

  /// No description provided for @would_you_update.
  ///
  /// In en, this message translates to:
  /// **'Would you like to update the app?'**
  String get would_you_update;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
