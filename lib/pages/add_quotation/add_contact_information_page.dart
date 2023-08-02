import 'package:appscwl_specialhire/customewidgets/confirm_button.dart';
import 'package:appscwl_specialhire/models/quotation/contact_information_model.dart';
import 'package:appscwl_specialhire/providers/quotation/quotation_add_provider.dart';
import 'package:appscwl_specialhire/utils/constants/text_field_constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';

class AddContactInformationPage extends StatefulWidget {
  static const String routeName = '/add_contact_information';
  const AddContactInformationPage({Key? key}) : super(key: key);

  @override
  State<AddContactInformationPage> createState() =>
      _AddContactInformationPageState();
}

class _AddContactInformationPageState extends State<AddContactInformationPage> {
  final _formKey = GlobalKey<FormState>();

  final _companyNameController = TextEditingController();
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _remarksController = TextEditingController();
  bool nameFocusedBefore = false;
  bool mobileFocusedBefore = false;
  late QuotationAddProvider quotationAddProvider;

  @override
  void didChangeDependencies() {
    quotationAddProvider = Provider.of<QuotationAddProvider>(context);
    if (quotationAddProvider.quotationModel.contactInformationModel != null) {
      _fillTextField();
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 25),
          child: ListView(
            children: [
              buildCompanyNameField(context),
              buildNameField(context),
              buildMobileField(context),
              buildEmailField(context),
              buildAddressField(context),
              buildRemarksField(context),
              ConfirmButton(
                callBack: _insertContactInfo,
                btnText: quotationAddProvider
                            .quotationModel.contactInformationModel !=
                        null
                    ? AppLocalizations.of(context)!.update
                    : AppLocalizations.of(context)!.confirm,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding buildCompanyNameField(BuildContext context) {
    return Padding(
      padding: textFieldPadding,
      child: TextFormField(
        controller: _companyNameController,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          label: Text(AppLocalizations.of(context)!.company_name),
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          //requires validation
          return null;
        },
      ),
    );
  }

  Padding buildNameField(BuildContext context) {
    return Padding(
      padding: textFieldPadding,
      child: TextFormField(
        controller: _nameController,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          label: Text(AppLocalizations.of(context)!.name),
          border: const OutlineInputBorder(),
        ),
        onChanged: (value) {
          nameFocusedBefore = true;
          _formKey.currentState!.validate();
        },
        validator: (value) {
          //requires validation
          if (nameFocusedBefore && (value == null || value.isEmpty)) {
            return AppLocalizations.of(context)!.name_required;
          }
          return null;
        },
      ),
    );
  }

  Padding buildMobileField(BuildContext context) {
    return Padding(
      padding: textFieldPadding,
      child: TextFormField(
        controller: _mobileController,
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          label: Text(AppLocalizations.of(context)!.mobile),
          border: const OutlineInputBorder(),
        ),
        onChanged: (value) {
          mobileFocusedBefore = true;
          _formKey.currentState!.validate();
        },
        validator: (value) {
          //requires validation
          if (mobileFocusedBefore && (value == null || value.isEmpty)) {
            return AppLocalizations.of(context)!.mobile_required;
          }
          return null;
        },
      ),
    );
  }

  Padding buildEmailField(BuildContext context) {
    return Padding(
      padding: textFieldPadding,
      child: TextFormField(
        controller: _emailController,
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          label: Text(AppLocalizations.of(context)!.email),
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          //requires validation
          return null;
        },
      ),
    );
  }

  Padding buildAddressField(BuildContext context) {
    return Padding(
      padding: textFieldPadding,
      child: TextFormField(
        controller: _addressController,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          label: Text(AppLocalizations.of(context)!.address),
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          //requires validation
          return null;
        },
      ),
    );
  }

  Padding buildRemarksField(BuildContext context) {
    return Padding(
      padding: textFieldPadding,
      child: TextFormField(
        controller: _remarksController,
        textInputAction: TextInputAction.newline,
        maxLines: 2,
        decoration: InputDecoration(
          label: Text(AppLocalizations.of(context)!.remarks),
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          //requires validation
          return null;
        },
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(AppLocalizations.of(context)!.add_contact_information),
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(
          Icons.arrow_back,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _companyNameController.dispose();
    _nameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  void _insertContactInfo() {
    nameFocusedBefore = true;
    mobileFocusedBefore = true;
    if (_formKey.currentState!.validate()) {
      final companyName = _companyNameController.text;
      final name = _nameController.text;
      final mobile = _mobileController.text;
      final email = _emailController.text;
      final address = _addressController.text;
      final remarks = _remarksController.text;

      final contactModel = ContactInformationModel(
        companyName: companyName,
        name: name,
        mobile: mobile,
        email: email,
        address: address,
        remarks: remarks,
      );
      quotationAddProvider.insertContactInfo(contactModel);
      Navigator.pop(context);
    }
  }

  void _fillTextField() {
    final contactModel =
        quotationAddProvider.quotationModel.contactInformationModel;
    if (contactModel!.companyName != null) {
      _companyNameController.text = contactModel.companyName!;
    }
    if (contactModel.name != null) {
      _nameController.text = contactModel.name!;
    }
    if (contactModel.mobile != null) {
      _mobileController.text = contactModel.mobile!;
    }
    if (contactModel.email != null) {
      _emailController.text = contactModel.email!;
    }
    if (contactModel.address != null) {
      _addressController.text = contactModel.address!;
    }
    if (contactModel.remarks != null) {
      _remarksController.text = contactModel.remarks!;
    }
  }
}
