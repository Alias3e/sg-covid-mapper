import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sgcovidmapper/blocs/initialization/initialization.dart';
import 'package:sgcovidmapper/models/hive/visit.dart';
import 'package:sgcovidmapper/models/one_map/one_map_token.dart';
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
  Future<void> saveVisit(Visit newVisit) async {
    await Hive.box<Visit>(InitializationBloc.visitBoxName).add(newVisit);
  }

  @override
  String get oneMapToken {
    String expiry = Hive.box(InitializationBloc.systemBoxName)
        .get(oneMapTokenExpiryKey, defaultValue: '');
    if (expiry.isEmpty ||
        DateTime.now().millisecondsSinceEpoch < int.parse(expiry)) return '';

    return Hive.box(InitializationBloc.systemBoxName).get(oneMapTokenKey);
  }

  @override
  void saveOneMapToken(OneMapToken token) {
    Hive.box(InitializationBloc.systemBoxName)
        .put(oneMapTokenKey, token.accessToken);
    Hive.box(InitializationBloc.systemBoxName)
        .put(oneMapTokenExpiryKey, token.expiryTimestamp);
  }
}
