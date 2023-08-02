import 'package:flutter/material.dart';

import 'color_constants.dart';

const BoxDecoration tableStyleDeco = BoxDecoration(
  border: Border(
    bottom: BorderSide(
      width: .5,
    ),
  ),
);
BoxDecoration listViewContainerBottomBorder = const BoxDecoration(
  border: Border(
    bottom: BorderSide(
      color: cardBackgroundColor,
      width: 1,
    ),
  ),
);

const bottomSheetSearchPadding = EdgeInsets.all(8);
const datePattern = 'dd-MM-yyyy';
const fromLocal = 2;
const fromApi = 1;
