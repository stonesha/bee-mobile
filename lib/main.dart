import 'package:bee_mobile/ui/app.dart';
import 'package:flutter/material.dart';
import 'dart:io';

void main() {
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
  };
  runApp(App());
}
