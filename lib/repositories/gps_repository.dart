import 'package:geolocator/geolocator.dart';

class GpsRepository {
  Geolocator _geolocator = Geolocator();
  Future<Position> getCurrentLocation() async {
    return await _geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }
}
