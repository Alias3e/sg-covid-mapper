import 'package:flutter/foundation.dart';
import 'package:sgcovidmapper/models/hive/visit.dart';

abstract class LocalStorageService {
  Future<void> save(Visit newVisit);

  List<Visit> get visits;

  ValueListenable visitListenable();
}
