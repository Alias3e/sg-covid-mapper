import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:sgcovidmapper/util/constants.dart';

class Asset {
  static Map<String, dynamic> configurations = {};
  static Map<String, dynamic> splash = {};

  static Future<void> loadConfigurations() async {
    MapConstants.baseMap = BaseMap.OneMap;
    try {
      String jsonString = await rootBundle.loadString('assets/cfg.json');
      configurations = jsonDecode(jsonString);
    } catch (e) {
      print('error here $e');
    }
  }

  static Future<Map> loadSplashDialog() async {
    try {
      String jsonString = await rootBundle.loadString('assets/splash.json');
      Map<String, dynamic> map = jsonDecode(jsonString);
      return map;
    } catch (e) {
      print('error here $e');
      return {};
    }
  }
}
