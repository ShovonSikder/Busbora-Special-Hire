import 'dart:async';
import 'dart:convert';
import 'package:appscwl_specialhire/customewidgets/confirm_button.dart';
import 'package:appscwl_specialhire/db/backend/server_helper.dart';
import 'package:appscwl_specialhire/l10n/app_localizations.dart';
import 'package:appscwl_specialhire/pages/home_page.dart';
import 'package:appscwl_specialhire/pages/side_menu/contact_us_page.dart';
import 'package:appscwl_specialhire/pages/side_menu/vehicle_register_page.dart';
import 'package:appscwl_specialhire/providers/user/user_provider.dart';
import 'package:appscwl_specialhire/utils/constants/api_constants/http_code.dart';
import 'package:appscwl_specialhire/utils/constants/api_constants/json_keys.dart';
import 'package:appscwl_specialhire/utils/constants/color_constants.dart';
import 'package:appscwl_specialhire/utils/constants/text_field_constants.dart';
import 'package:appscwl_specialhire/utils/helper_function.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import '../db/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = '/login';

  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _userNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final passFocus = FocusNode();
  bool userFieldFocusedBefore = false;
  bool passFieldFocusedBefore = false;

  bool isObscure = true;
  String errMsg = '';

  @override
  void dispose() {
    _userNameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  DateTime preBackPress = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
      child: WillPopScope(
        onWillPop: () async {
          if (!ModalRoute.of(context)!.isFirst) return true;
          final timeGap = DateTime.now().difference(preBackPress);
          final cantExit = timeGap >= const Duration(seconds: 2);
          preBackPress = DateTime.now();
          if (cantExit) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                AppLocalizations.of(context)!.exit_app,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14),
              ),
              backgroundColor: Colors.red.withOpacity(.9),
              duration: const Duration(seconds: 2),
            ));
            return false;
          } else {
            return true;
          }
        },
        child: Scaffold(
          backgroundColor: cardBackgroundColor,
          bottomNavigationBar: buildBottomNavbar(context),
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    // buildLogoSection(),
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(
                            left: 10,
                            right: 10,
                          ),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey[350]!,
                                offset: const Offset(0, 3.5),
                                spreadRadius: 4,
                                blurRadius: 4,
                              ),
                            ],
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Card(
                            margin: const EdgeInsets.all(0),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 2, right: 2, top: 50, bottom: 25),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Text(
                                    //   AppLocalizations.of(context)!.special_hire,
                                    //   style: const TextStyle(
                                    //       fontSize: 24, fontWeight: FontWeight.bold),
                                    // ),
                                    const SizedBox(
                                      height: 18,
                                    ),
                                    buildBuildUsernameField(context),
                                    buildPasswordField(context),
                                    const SizedBox(
                                      height: 6,
                                    ),
                                    ConfirmButton(
                                      btnText:
                                          AppLocalizations.of(context)!.login,
                                      callBack: () {
                                        setState(() {
                                          userFieldFocusedBefore = true;
                                          passFieldFocusedBefore = true;
                                          errMsg = '';
                                        });
                                        _initiateLogin();
                                      },
                                    ),
                                    if (errMsg.isNotEmpty)
                                      buildErrMessageViewSection(),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                            top: -4.5,
                            left: 0,
                            right: 0,
                            child: Container(
                              alignment: Alignment.center,
                              child: Container(
                                width: 210,
                                height: 10,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(1),
                                  gradient: const LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      cardBackgroundColor,
                                      Colors.white,
                                    ],
                                  ),
                                ),
                              ),
                            )),
                        Positioned(
                          top: -45,
                          left: 0,
                          right: 0,
                          // left: MediaQuery.of(context).size.width/4,
                          child: Container(
                            alignment: Alignment.center,
                            child: buildLogoSection(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildBottomNavbar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
            onPressed: () {
              Navigator.pushNamed(context, ContactUsPage.routeName);
              //show in dialog
              // showDialog(
              //     context: context,
              //     builder: (context) => AlertDialog(
              //           contentPadding: EdgeInsets.all(15).copyWith(top: 0),
              //           titlePadding:
              //               EdgeInsets.all(15).copyWith(right: 0, top: 0),
              //           title: Row(
              //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //             children: [
              //               Text(AppLocalizations.of(context)!
              //                   .contact_information),
              //               IconButton(
              //                 onPressed: () {
              //                   Navigator.pop(context);
              //                 },
              //                 icon: Icon(Icons.close),
              //               )
              //             ],
              //           ),
              //           content: Column(
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             mainAxisAlignment: MainAxisAlignment.start,
              //             mainAxisSize: MainAxisSize.min,
              //             children: [
              //               Text(AppLocalizations.of(context)!.contact_company),
              //               Text(AppLocalizations.of(context)!.contact_mail),
              //               Text(AppLocalizations.of(context)!.contact_phone),
              //             ],
              //           ),
              //         ));
            },
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Text(
                AppLocalizations.of(context)!.contact_touch,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            )),
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, VehicleRegisterPage.routeName);
          },
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Text(
              AppLocalizations.of(context)!.register_here,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildErrMessageViewSection() {
    return Padding(
      padding: const EdgeInsets.only(top: 12, left: 12, right: 12),
      child: Text(
        errMsg,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.red,
          fontSize: 16,
        ),
      ),
    );
  }

  Padding buildBuildUsernameField(BuildContext context) {
    return Padding(
      padding: textFieldPadding,
      child: TextFormField(
          controller: _userNameController,
          cursorHeight: 24,
          style: const TextStyle(fontSize: 16),
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.only(top: 15, bottom: 15, right: 10),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            labelText: AppLocalizations.of(context)!.username,
            focusColor: const Color(focusColorCode),
            prefixIcon: const Icon(Icons.person),
            filled: true,
            fillColor: const Color(fillColorCode),
          ),
          validator: (value) {
            if (userFieldFocusedBefore && (value == null || value.isEmpty)) {
              return AppLocalizations.of(context)!.username_required;
            }
            return null;
          },
          onFieldSubmitted: (value) {
            passFocus.requestFocus();
          },
          onChanged: (value) {
            userFieldFocusedBefore = true;
            if (userFieldFocusedBefore) {
              _formKey.currentState!.validate();
            }
          }),
    );
  }

  Padding buildPasswordField(BuildContext context) {
    return Padding(
      padding: textFieldPadding,
      child: TextFormField(
        controller: _passwordController,
        focusNode: passFocus,
        obscureText: isObscure,
        textInputAction: TextInputAction.go,
        cursorColor: const Color(focusColorCode),
        cursorHeight: 24,
        style: const TextStyle(fontSize: 16),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(top: 15, bottom: 15, right: 10),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          labelText: AppLocalizations.of(context)!.password,
          focusColor: const Color(focusColorCode),
          fillColor: const Color(fillColorCode),
          prefixIcon: const Icon(Icons.lock),
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                isObscure = !isObscure;
              });
            },
            icon: Icon(isObscure ? Icons.visibility : Icons.visibility_off),
          ),
          filled: true,
        ),
        validator: (value) {
          if (passFieldFocusedBefore && (value == null || value.isEmpty)) {
            return AppLocalizations.of(context)!.password_required;
          }
          return null;
        },
        onChanged: (value) {
          passFieldFocusedBefore = true;
          if (passFieldFocusedBefore) {
            _formKey.currentState!.validate();
          }
        },
        onFieldSubmitted: (value) {
          setState(() {
            userFieldFocusedBefore = true;
            passFieldFocusedBefore = true;
            errMsg = '';
          });
          _initiateLogin();
        },
      ),
    );
  }

  Padding buildLogoSection() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 60),
      child: Image.asset(
        'assets/images/logo_SH.png',
        width: 200,
        height: 100,
        // fit: BoxFit.contain,
      ),
    );
  }

  _initiateLogin() {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      EasyLoading.show();
      final username = _userNameController.text.trim();
      final password = _passwordController.text.trim();

      //hit api

      ServerHelper.login(username, password).then((response) async {
        await onSuccessLogin(response);
        EasyLoading.dismiss();
      }).catchError((err) {
        EasyLoading.dismiss();
        errMsg = HttpCode.getFriendlyErrorMsg(context, err);

        setState(() {});
      });
    }
    // Navigator.pushReplacementNamed(context, QuotationListPage.routeName);
  }

  Future<void> onSuccessLogin(Response response) async {
    if (response.statusCode == HttpCode.success) {
      final jsonData = json.decode(response.body);
      if (jsonData[jsonKeyLoginStatus] == 1) {
        await AppSharedPref.setUserAuthCode(
            jsonData[jsonKeyAuthCode].toString());
        await AppSharedPref.setLoginStatus(true);

        //init user information to user provider
        Provider.of<UserProvider>(context, listen: false)
            .initUser(response.body);
        EasyLoading.dismiss();
        Navigator.pushReplacementNamed(context, HomePage.routeName);
      } else {
        setState(() {
          errMsg = jsonData[jsonKeyLoginMsg][0][1];
        });
      }
      // print(jsonData);
    } else {
      setState(() {
        errMsg = 'Something went wrong';
      });
    }
  }
}
