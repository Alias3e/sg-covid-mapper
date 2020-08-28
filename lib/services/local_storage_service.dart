import 'package:flutter/foundation.dart';
import 'package:sgcovidmapper/models/hive/visit.dart';
import 'package:sgcovidmapper/models/one_map/one_map_token.dart';

abstract class LocalStorageService {
  Future<void> saveVisit(Visit newVisit);

  Future<void> deleteVisit(Visit visit);

  Future<void> updateVisit(Visit visit);

  List<Visit> get visits;

  ValueListenable visitListenable();

  void saveOneMapToken(OneMapToken token);

  String get oneMapToken;
}
