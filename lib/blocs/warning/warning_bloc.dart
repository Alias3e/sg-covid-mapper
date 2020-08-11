import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sgcovidmapper/blocs/check_panel/check_panel.dart';
import 'package:sgcovidmapper/blocs/warning/warning.dart';
import 'package:sgcovidmapper/models/hive/visit.dart';
import 'package:sgcovidmapper/models/models.dart';
import 'package:sgcovidmapper/repositories/covid_places_repository.dart';
import 'package:sgcovidmapper/repositories/my_visited_place_repository.dart';

class WarningBloc extends Bloc<WarningEvent, WarningState> {
  final MyVisitedPlaceRepository visitsRepository;
  final CovidPlacesRepository covidRepository;
  final CheckPanelBloc checkPanelBloc;

  StreamSubscription<List<CovidLocation>> _subscription;

  WarningBloc(
      {@required this.checkPanelBloc,
      @required this.visitsRepository,
      @required this.covidRepository})
      : assert(checkPanelBloc != null &&
            visitsRepository != null &&
            covidRepository != null) {
    subscribe();
  }

  Future<void> subscribe() async {
    checkPanelBloc.listen((state) {
      if (state is VisitSaved) {
        state.visit.setWarningLevel(covidRepository.covidLocationsCached);
        add(WarningChanged(DateTime.now().millisecondsSinceEpoch));
      }
    });
    await covidRepository.init();
    _subscription = covidRepository.covidLocations.listen((event) {
      covidRepository.covidLocationsCached = event;
      _updateWarningLevels();
    });
  }

  void _updateWarningLevels() {
    List<Visit> visits = visitsRepository.loadVisits();
    visits.forEach((visit) {
      visit.setWarningLevel(covidRepository.covidLocationsCached);
    });
    add(WarningChanged(DateTime.now().millisecondsSinceEpoch));
  }

  @override
  WarningState get initialState => WarningLevelUnchanged();

  @override
  Stream<WarningState> mapEventToState(WarningEvent event) async* {
    if (event is WarningChanged) yield WarningLevelUpdated(event.timestamp);
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    checkPanelBloc?.close();
    return super.close();
  }
}
