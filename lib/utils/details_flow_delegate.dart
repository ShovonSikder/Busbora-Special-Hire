import 'package:flutter/material.dart';

class FlowMenuDelegate extends FlowDelegate {
  @override
  void paintChildren(FlowPaintingContext context) {
    double width = context.size.width;
    double height = context.size.height;
    // for (var i = 0; i < context.childCount; i++)
    // TODO:
    context.paintChild(0,
        transform: Matrix4.translationValues(width - 60, height - 60, 0));
    context.paintChild(1,
        transform: Matrix4.translationValues(width - 60, height - 240, 0));
    context.paintChild(2,
        transform: Matrix4.translationValues(width - 60, height - 180, 0));
    context.paintChild(3,
        transform: Matrix4.translationValues(width - 60, height - 120, 0));
  }

  @override
  bool shouldRepaint(covariant FlowDelegate oldDelegate) {
    return false;
  }
}
