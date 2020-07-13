import 'package:sgcovidmapper/models/place_marker.dart';

abstract class VisitedPlaceRepository {
  List<PlaceMarker> cached = [];
  Future<void> init();
  Stream<List<PlaceMarker>> get placeMarkers;
}
