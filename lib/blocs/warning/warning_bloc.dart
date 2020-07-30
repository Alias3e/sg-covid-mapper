import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sgcovidmapper/blocs/warning/warning.dart';
import 'package:sgcovidmapper/models/hive/visit.dart';
import 'package:sgcovidmapper/models/models.dart';
import 'package:sgcovidmapper/repositories/covid_places_repository.dart';
import 'package:sgcovidmapper/repositories/my_visited_place_repository.dart';

class WarningBloc extends Bloc<WarningEvent, WarningState> {
  final MyVisitedPlaceRepository visitsRepository;
  final CovidPlacesRepository covidRepository;

  StreamSubscription<List<CovidLocation>> _subscription;

  WarningBloc({this.visitsRepository, this.covidRepository});

  Future<void> subscribe() async {
    await covidRepository.init();
    _subscription = covidRepository.covidLocations
        .listen((event) => covidRepository.covidLocationsCached = event);
    visitsRepository.listen(_updateWarningLevels);
  }

  void _updateWarningLevels() {
    List<Visit> visits = visitsRepository.loadVisits();
    for (CovidLocation covid in covidRepository.covidLocationsCached) {
      visits.forEach((visit) {
        visit.setWarningLevel(covid);
      });
    }
  }

  @override
  WarningState get initialState => WarningLevelUnchanged();

  @override
  Stream<WarningState> mapEventToState(WarningEvent event) async* {
    yield WarningLevelUnchanged();
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
