import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sgcovidmapper/blocs/initialization/initialization.dart';
import 'package:sgcovidmapper/models/hive/visit.dart';
import 'package:sgcovidmapper/services/local_storage_service.dart';

class HiveService extends LocalStorageService {
  final String oneMapTokenKey = 'oneMapToken';
  final String oneMapTokenExpiryKey = 'oneMapTokenExpiry';

  @override
  List<Visit> get visits =>
      Hive.box<Visit>(InitializationBloc.visitBoxName).values.toList();

  @override
  ValueListenable visitListenable() =>
      Hive.box<Visit>(InitializationBloc.visitBoxName).listenable();

  @override
  Future<int> saveVisit(Visit newVisit) async {
    return await Hive.box<Visit>(InitializationBloc.visitBoxName).add(newVisit);
  }

  @override
  Future<void> deleteVisit(Visit visit) {
    return visit.delete();
  }

  @override
  Future<void> updateVisit(Visit visit) {
    return visit.save();
  }
}
