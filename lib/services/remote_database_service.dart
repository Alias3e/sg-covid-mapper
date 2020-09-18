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
}
