import 'package:sgcovidmapper/models/one_map/one_map_token.dart';

abstract class RemoteDatabaseService {
  String covidDbVersion;
  String source;
  DateTime updated;
  String oneMapKey;
  int oneMapKeyExpiryTimestamp;

  void init();

  DateTime get oneMapKeyExpiryDate;
  dynamic get covidLocations;
  dynamic get systems;
  Stream<dynamic> get oneMap;

  void updateOneMapToken(OneMapToken token);
}
