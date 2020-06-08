import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:sgcovidmapper/util/constants.dart';

class Config {
  static Map<String, dynamic> configurations = {};

  static Future<void> loadConfig() async {
    MapConstants.baseMap = BaseMap.OneMap;
    try {
      String jsonString = await rootBundle.loadString('assets/cfg.json');
      configurations = jsonDecode(jsonString);
    } catch (e) {
      print('error here $e');
      return null;
    }
  }
}
