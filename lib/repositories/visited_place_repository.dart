import 'package:sgcovidmapper/models/place_marker.dart';

abstract class VisitedPlaceRepository {
  List<PlaceMarker> cached = [];
  Stream<List<PlaceMarker>> get placeMarkers;
}
