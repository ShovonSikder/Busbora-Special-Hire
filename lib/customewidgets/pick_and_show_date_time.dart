import 'package:flutter/material.dart';

class PickAndShowDateTime extends StatelessWidget {
  final controller;
  final Function() callBack;
  final Function()? onClear;
  final label;
  final bool showClearButton;
  final Widget? suffixIcon;

  const PickAndShowDateTime({
    Key? key,
    required this.controller,
    required this.callBack,
    this.suffixIcon,
    this.onClear,
    this.label = '',
    this.showClearButton = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      onTap: () {
        callBack();
        FocusScope.of(context).requestFocus(FocusNode());
      },
      decoration: InputDecoration(
        label: Text(label),
        floatingLabelStyle: TextStyle(color: Theme.of(context).primaryColor),
        border: const OutlineInputBorder(),
        contentPadding:
            const EdgeInsets.only(top: 15, bottom: 15, right: 10, left: 12),
        suffixIcon: showClearButton
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (showClearButton)
                    SizedBox(
                      width: 45,
                      child: Center(
                        child: ElevatedButton(
                            onPressed: () {
                              if (onClear != null) {
                                onClear!();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                primary: Colors.transparent,
                                elevation: 0,
                                shadowColor: Colors.transparent,
                                onPrimary: Colors.grey,
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero)),
                            child: const Icon(
                              Icons.clear,
                              size: 22,
                            )),
                      ),
                    ),
                ],
              )
            : suffixIcon,
      ),
      validator: (value) {
        //requires validation
        return null;
      },
    );
  }
}
