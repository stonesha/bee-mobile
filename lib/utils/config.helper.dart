import 'dart:convert';
import 'package:flutter/services.dart';

const String _CONFIG_FILE_PATH = 'assets/config.json';

//helper function to laod config file
Future<dynamic> loadConfigFile() async {
  String json = await rootBundle.loadString(_CONFIG_FILE_PATH);
  return jsonDecode(json) as Map<String, dynamic>;
}
