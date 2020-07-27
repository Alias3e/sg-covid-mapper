import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sgcovidmapper/models/models.dart';
import 'package:sgcovidmapper/services/local_storage_service.dart';

class HiveService extends LocalStorageService {
  final String myVisitBoxName;

  HiveService(this.myVisitBoxName) {
    init();
  }

  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(VisitAdapter());
    await Hive.openBox<Visit>(myVisitBoxName);
  }

  @override
  List<Visit> get visits {
    return Hive.box<Visit>(myVisitBoxName).values.toList();
  }

  ValueListenable visitListenable() {
    return Hive.box<Visit>(myVisitBoxName).listenable();
  }

  @override
  Future<void> save(Visit newVisit) async {
    await Hive.box<Visit>(myVisitBoxName).add(newVisit);
  }
}
