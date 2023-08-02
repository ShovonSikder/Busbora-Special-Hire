import 'dart:developer';
import 'dart:io';

import 'package:appscwl_specialhire/l10n/app_localizations.dart';
import 'package:appscwl_specialhire/providers/user/user_provider.dart';
import 'package:appscwl_specialhire/utils/constants/color_constants.dart';
import 'package:appscwl_specialhire/utils/helper_function.dart';
import 'package:appscwl_specialhire/utils/permission_manager.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../customewidgets/confirm_button.dart';
import '../../utils/constants/text_field_constants.dart';

class VehicleRegisterPage extends StatefulWidget {
  const VehicleRegisterPage({Key? key}) : super(key: key);
  static const String routeName = '/vehicle_registration';

  @override
  State<VehicleRegisterPage> createState() => _VehicleRegisterPageState();
}

class _VehicleRegisterPageState extends State<VehicleRegisterPage> {
  final _formKey = GlobalKey<FormState>();

  //owner info input controller
  final _ownerFullNameController = TextEditingController();
  final _ownerAddressController = TextEditingController();
  final _ownerTelephoneController = TextEditingController();
  final _ownerEmailController = TextEditingController();
  final _ownerTINController = TextEditingController();

  //vehicle details input controller
  final _vehicleMakerController = TextEditingController();
  final _vehicleModelController = TextEditingController();
  final _vehiclePlateController = TextEditingController();
  final _vehicleSeatController = TextEditingController();

  //contact details input controller
  final _conFullNameController = TextEditingController();
  final _conPhoneNumberController = TextEditingController();
  final _contactEmailController = TextEditingController();

  //attachment controller
  final _attachRegistrationCardController = TextEditingController();
  final _attachTINController = TextEditingController();
  File? registrationCard;
  File? tin;

  //for managing onChanged validation
  List<bool> shouldValidate = List.filled(12, false);
  @override
  void dispose() {
    _ownerAddressController.dispose();
    _ownerFullNameController.dispose();
    _ownerTelephoneController.dispose();
    _ownerEmailController.dispose();
    _ownerTINController.dispose();

    _vehicleMakerController.dispose();
    _vehicleModelController.dispose();
    _vehiclePlateController.dispose();
    _vehicleSeatController.dispose();

    _conFullNameController.dispose();
    _conPhoneNumberController.dispose();
    _contactEmailController.dispose();

    _attachRegistrationCardController.dispose();
    _attachTINController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cardBackgroundColor,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.register_page_title),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(5),
                children: [
                  //owner info
                  Card(
                    margin: const EdgeInsets.all(0).copyWith(bottom: 5),
                    child: Column(
                      children: [
                        buildSubFormLabel(
                            AppLocalizations.of(context)!.owner_details),
                        buildOwnerFullNameField(context),
                        buildOwnerAddressField(context),
                        buildOwnerTelephoneField(context),
                        buildOwnerEmailField(context),
                        buildOwnerTINField(context),
                      ],
                    ),
                  ),
                  //vehicle info
                  Card(
                    margin: const EdgeInsets.all(0).copyWith(bottom: 5),
                    child: Column(
                      children: [
                        buildSubFormLabel(
                            AppLocalizations.of(context)!.vehicle_details),
                        buildMakerField(context),
                        buildModelField(context),
                        buildPlateNumberField(context),
                        buildPassengerSeatField(context),
                      ],
                    ),
                  ),
                  //contact details
                  Card(
                    margin: const EdgeInsets.all(0).copyWith(bottom: 5),
                    child: Column(
                      children: [
                        buildSubFormLabel(
                            AppLocalizations.of(context)!.contact_details),
                        buildContactNameField(context),
                        buildContactPhoneNumberField(context),
                        buildContactEmailField(context),
                      ],
                    ),
                  ),
                  //attachment
                  Card(
                    margin: const EdgeInsets.all(0).copyWith(bottom: 5),
                    child: Column(
                      children: [
                        buildSubFormLabel(
                            AppLocalizations.of(context)!.attachment),
                        buildRegistrationCardAttachField(context),
                        buildTINAttachField(context),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            buildBottomContainer(context),
          ],
        ),
      ),
    );
  }

  Container buildBottomContainer(context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: cardBackgroundColor, width: 2),
        ),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ConfirmButton(
          btnText: AppLocalizations.of(context)!.submit,
          callBack: () {
            _submitForm();
          },
        ),
      ),
    );
  }

  Padding buildOwnerFullNameField(BuildContext context) {
    return Padding(
      padding: textFieldPadding,
      child: TextFormField(
        controller: _ownerFullNameController,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          label: Text(AppLocalizations.of(context)!.full_name + '*'),
          border: const OutlineInputBorder(),
        ),
        onChanged: (v) {
          shouldValidate[0] = true;
          if (shouldValidate[0]) {
            _formKey.currentState!.validate();
          }
        },
        validator: (value) {
          //requires validation
          if (shouldValidate[0] && (value == null || value.isEmpty)) {
            return AppLocalizations.of(context)!.name_required;
          }
          return null;
        },
      ),
    );
  }

  buildOwnerAddressField(BuildContext context) {
    return Padding(
      padding: textFieldPadding,
      child: TextFormField(
        controller: _ownerAddressController,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          label: Text(AppLocalizations.of(context)!.address_req + '*'),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintText: AppLocalizations.of(context)!.address_example,
          border: const OutlineInputBorder(),
        ),
        onChanged: (v) {
          shouldValidate[1] = true;
          if (shouldValidate[1]) {
            _formKey.currentState!.validate();
          }
        },
        validator: (value) {
          //requires validation
          if (shouldValidate[1] && (value == null || value.isEmpty)) {
            return AppLocalizations.of(context)!.address_required;
          }
          return null;
        },
      ),
    );
  }

  buildOwnerTelephoneField(BuildContext context) {
    return Padding(
      padding: textFieldPadding,
      child: TextFormField(
        controller: _ownerTelephoneController,
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          label: Text(AppLocalizations.of(context)!.phone_number + '*'),
          hintText: AppLocalizations.of(context)!.phone_example,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          border: const OutlineInputBorder(),
        ),
        onChanged: (v) {
          shouldValidate[2] = true;
          if (shouldValidate[2]) {
            _formKey.currentState!.validate();
          }
        },
        validator: (value) {
          //requires validation
          if (shouldValidate[2] && (value == null || value.isEmpty)) {
            return AppLocalizations.of(context)!.telephone_required;
          }
          return null;
        },
      ),
    );
  }

  buildOwnerEmailField(BuildContext context) {
    return Padding(
      padding: textFieldPadding,
      child: TextFormField(
        controller: _ownerEmailController,
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          label: Text(AppLocalizations.of(context)!.email_account + '*'),
          border: const OutlineInputBorder(),
        ),
        onChanged: (v) {
          shouldValidate[11] = true;
          if (shouldValidate[11]) {
            _formKey.currentState!.validate();
          }
        },
        validator: (value) {
          //requires validation
          if (shouldValidate[11] && (value == null || value.isEmpty)) {
            return AppLocalizations.of(context)!.email_required;
          }
          return null;
        },
      ),
    );
  }

  buildOwnerTINField(BuildContext context) {
    return Padding(
      padding: textFieldPadding,
      child: TextFormField(
        controller: _ownerTINController,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          label: Text(AppLocalizations.of(context)!.tin + '*'),
          border: const OutlineInputBorder(),
        ),
        onChanged: (v) {
          shouldValidate[3] = true;
          if (shouldValidate[3]) {
            _formKey.currentState!.validate();
          }
        },
        validator: (value) {
          //requires validation
          if (shouldValidate[3] && (value == null || value.isEmpty)) {
            return AppLocalizations.of(context)!.tin_required;
          }
          return null;
        },
      ),
    );
  }

  buildSubFormLabel(String owner_details) {
    return Padding(
      padding: textFieldPadding,
      child: Text(
        owner_details,
        textAlign: TextAlign.start,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  buildMakerField(BuildContext context) {
    return Padding(
      padding: textFieldPadding,
      child: TextFormField(
        controller: _vehicleMakerController,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          hintText: AppLocalizations.of(context)!.maker_example,
          label: Text(AppLocalizations.of(context)!.maker_req + '*'),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          border: const OutlineInputBorder(),
        ),
        onChanged: (v) {
          shouldValidate[4] = true;
          if (shouldValidate[4]) {
            _formKey.currentState!.validate();
          }
        },
        validator: (value) {
          //requires validation
          if (shouldValidate[4] && (value == null || value.isEmpty)) {
            return AppLocalizations.of(context)!.plate_required;
          }
          return null;
        },
      ),
    );
  }

  buildModelField(BuildContext context) {
    return Padding(
      padding: textFieldPadding,
      child: TextFormField(
        controller: _vehicleModelController,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          hintText: AppLocalizations.of(context)!.model_example,
          label: Text(AppLocalizations.of(context)!.model + '*'),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          border: const OutlineInputBorder(),
        ),
        onChanged: (v) {
          // requirement came after
          shouldValidate[10] = true;
          if (shouldValidate[10]) {
            _formKey.currentState!.validate();
          }
        },
        validator: (value) {
          //requires validation
          if (shouldValidate[10] && (value == null || value.isEmpty)) {
            return AppLocalizations.of(context)!.model_required;
          }
          return null;
        },
      ),
    );
  }

  buildPlateNumberField(BuildContext context) {
    return Padding(
      padding: textFieldPadding,
      child: TextFormField(
        controller: _vehiclePlateController,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          hintText: AppLocalizations.of(context)!.plate_example,
          label: Text(AppLocalizations.of(context)!.plate_number + '*'),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          border: const OutlineInputBorder(),
        ),
        onChanged: (v) {
          shouldValidate[5] = true;
          if (shouldValidate[5]) {
            _formKey.currentState!.validate();
          }
        },
        validator: (value) {
          //requires validation
          if (shouldValidate[5] && (value == null || value.isEmpty)) {
            return AppLocalizations.of(context)!.plate_required;
          }
          return null;
        },
      ),
    );
  }

  buildPassengerSeatField(BuildContext context) {
    return Padding(
      padding: textFieldPadding,
      child: TextFormField(
        controller: _vehicleSeatController,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          label: Text(AppLocalizations.of(context)!.passenger_seat + '*'),
          border: const OutlineInputBorder(),
        ),
        onChanged: (v) {
          shouldValidate[6] = true;
          if (shouldValidate[6]) {
            _formKey.currentState!.validate();
          }
        },
        validator: (value) {
          //requires validation
          if (shouldValidate[6] && (value == null || value.isEmpty)) {
            return AppLocalizations.of(context)!.seat_info_required;
          }
          return null;
        },
      ),
    );
  }

  buildContactNameField(BuildContext context) {
    return Padding(
      padding: textFieldPadding,
      child: TextFormField(
        controller: _conFullNameController,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          label: Text(AppLocalizations.of(context)!.full_name + '*'),
          border: const OutlineInputBorder(),
        ),
        onChanged: (v) {
          shouldValidate[7] = true;
          if (shouldValidate[7]) {
            _formKey.currentState!.validate();
          }
        },
        validator: (value) {
          //requires validation
          if (shouldValidate[7] && (value == null || value.isEmpty)) {
            return AppLocalizations.of(context)!.name_required;
          }
          return null;
        },
      ),
    );
  }

  buildContactEmailField(BuildContext context) {
    return Padding(
      padding: textFieldPadding,
      child: TextFormField(
        controller: _contactEmailController,
        textInputAction: TextInputAction.done,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          label: Text(AppLocalizations.of(context)!.email_account + '*'),
          border: const OutlineInputBorder(),
        ),
        onChanged: (v) {
          shouldValidate[8] = true;
          if (shouldValidate[8]) {
            _formKey.currentState!.validate();
          }
        },
        validator: (value) {
          //requires validation
          if (shouldValidate[8] && (value == null || value.isEmpty)) {
            return AppLocalizations.of(context)!.email_required;
          }
          return null;
        },
      ),
    );
  }

  buildContactPhoneNumberField(BuildContext context) {
    return Padding(
      padding: textFieldPadding,
      child: TextFormField(
        controller: _conPhoneNumberController,
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          hintText: AppLocalizations.of(context)!.phone_example,
          label: Text(AppLocalizations.of(context)!.phone_number + '*'),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          border: const OutlineInputBorder(),
        ),
        onChanged: (v) {
          shouldValidate[9] = true;
          if (shouldValidate[9]) {
            _formKey.currentState!.validate();
          }
        },
        validator: (value) {
          //requires validation
          if (shouldValidate[9] && (value == null || value.isEmpty)) {
            return AppLocalizations.of(context)!.phone_required;
          }
          return null;
        },
      ),
    );
  }

  buildRegistrationCardAttachField(BuildContext context) {
    return Padding(
      padding: textFieldPadding,
      child: TextFormField(
        controller: _attachRegistrationCardController,
        readOnly: true,
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
          _pickFile(1, _attachRegistrationCardController);
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          suffixIcon: const Icon(Icons.file_present_rounded),
          floatingLabelStyle: const TextStyle(color: specialHireThemePrimary),
          label: Text(AppLocalizations.of(context)!.registration_card),
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          //requires validation
          return null;
        },
      ),
    );
  }

  buildTINAttachField(BuildContext context) {
    return Padding(
      padding: textFieldPadding,
      child: TextFormField(
        controller: _attachTINController,
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
          _pickFile(2, _attachTINController);
        },
        readOnly: true,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          label: Text(AppLocalizations.of(context)!.tin_attachment),
          floatingLabelStyle: const TextStyle(color: specialHireThemePrimary),
          suffixIcon: const Icon(Icons.file_present_rounded),
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          //requires validation
          return null;
        },
      ),
    );
  }

  void _submitForm() async {
    shouldValidate = List.filled(12, true);
    if (_formKey.currentState!.validate()) {
      final Email email = Email(
        body: generateMailBody(),
        subject: AppLocalizations.of(context)!.vehicle_register_mail_subject,
        recipients: [AppLocalizations.of(context)!.contact_mail],
        cc: [],
        bcc: [],
        attachmentPaths: [
          if (registrationCard != null) registrationCard!.path,
          if (tin != null) tin!.path,
        ],
        isHTML: false,
      );

      await FlutterEmailSender.send(email);
      Navigator.pop(context);
    } else {
      showMsgOnSnackBar(
          context, AppLocalizations.of(context)!.fill_required_msg);
    }
  }

  String generateMailBody() {
    final ln = AppLocalizations.of(context)!;
    return '''\u2756 ${ln.owner_details}
        ${ln.full_name}\b: ${_ownerFullNameController.text}
        ${ln.address}: ${_ownerAddressController.text}
        ${ln.phone_number}: ${_ownerTelephoneController.text}
        ${ln.email}: ${_ownerEmailController.text}
        ${ln.tin}: ${_ownerTINController.text}
        
\u2756 ${ln.vehicle_details}
        ${ln.maker_req}: ${_vehicleMakerController.text}
        ${ln.plate_number}: ${_vehiclePlateController.text}
        ${ln.passenger_seat}: ${_vehicleSeatController.text}
        
\u2756 ${ln.contact_details}
        ${ln.full_name}: ${_conFullNameController.text}
        ${ln.phone_number}: ${_conPhoneNumberController.text}
        ${ln.email_account}: ${_contactEmailController.text}''';
  }

  void _pickFile(int index, TextEditingController _controller) async {
    if (!await PermissionManager.storageKiDekhaJabe()) {
      showMsgOnSnackBar(
          context, AppLocalizations.of(context)!.request_storage_permission);
      return;
    }

    FilePicker.platform.pickFiles().then((value) {
      if (value != null) {
        if (index == 1) {
          registrationCard = File(value.files.single.path!);
        } else if (index == 2) {
          tin = File(value.files.single.path!);
        }
        final filePath = value.files.single.path!.split('/');
        _controller.text = filePath[filePath.length - 1];
      } else {
        // User canceled the picker
      }
    }).catchError((err) {});
  }
}
