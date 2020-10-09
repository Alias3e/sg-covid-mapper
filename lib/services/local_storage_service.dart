import 'package:flutter/foundation.dart';
import 'package:sgcovidmapper/models/hive/visit.dart';

abstract class LocalStorageService {
  Future<int> saveVisit(Visit newVisit);

  Future<void> deleteVisit(Visit visit);

  Future<void> updateVisit(Visit visit);

  List<Visit> get visits;

  ValueListenable visitListenable();
}
