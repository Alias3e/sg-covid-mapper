import 'package:sgcovidmapper/models/visited_place.dart';

abstract class VisitedPlaceRepository {
  List<VisitedPlace> cached = [];
  Stream<List<VisitedPlace>> get visitedPlaces;
}
