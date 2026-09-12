import 'dart:ui';

import 'package:flutter/material.dart';

// Dimensions in physical pixels (px)
Size getPhysicalSize() {
  FlutterView view = WidgetsBinding.instance.platformDispatcher.views.first;

  return view.physicalSize;
}

// Dimensions in physical pixels (px)
Size getLogicalSize() {
  FlutterView view = WidgetsBinding.instance.platformDispatcher.views.first;

  return view.physicalSize / view.devicePixelRatio;
}
