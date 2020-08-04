import 'package:geolocator/geolocator.dart';

class GpsRepository {
  Geolocator _geolocator = Geolocator();
  Position _lastPosition;

  Future<Position> getCurrentLocation() async {
    _lastPosition = await _geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print(_lastPosition);
    return _lastPosition;
  }

  Position get lastPosition {
    return _lastPosition;
  }
}
