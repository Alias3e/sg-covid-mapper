import 'package:flutter/cupertino.dart';

abstract class GeocodeService {
  Future<dynamic> search(Map<String, String> queries);

  Future<dynamic> authenticate(
      {@required String email, @required String password});

  Future<dynamic> reverseGeocode(
      {@required String token,
      @required String location,
      @required String buffer});
}
