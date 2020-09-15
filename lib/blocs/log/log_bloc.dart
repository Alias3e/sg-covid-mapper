import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sgcovidmapper/blocs/log/log.dart';
import 'package:sgcovidmapper/repositories/covid_places_repository.dart';
import 'package:sgcovidmapper/repositories/my_visited_place_repository.dart';

class LogBloc extends Bloc<LogEvent, LogState> {
  final MyVisitedPlaceRepository _myVisitedPlacesRepository;
  final CovidPlacesRepository _covidPlacesRepository;

  LogBloc(this._myVisitedPlacesRepository, this._covidPlacesRepository)
      : assert(_myVisitedPlacesRepository != null &&
            _covidPlacesRepository != null);

  @override
  LogState get initialState => LogStateInitial();

  @override
  Stream<Transition<LogEvent, LogState>> transformEvents(
      Stream<LogEvent> events, transitionFn) {
    return super.transformEvents(
        events.debounceTime(Duration(milliseconds: 50)), transitionFn);
  }

  @override
  Stream<LogState> mapEventToState(LogEvent event) async* {
    if (event is OnDeleteConfirmed) {
      yield VisitDeleteInProgress(event.visit);
      await _myVisitedPlacesRepository.deleteVisit(event.visit);
      yield VisitDeleteCompleted(visit: event.visit, maxHeight: 0.25);
    }

    if (event is OnDeleteButtonPressed)
      yield DeleteConfirmationPanelShowing(event.visit);

    if (event is OnCancelButtonPressed) yield LogPanelClosing(maxHeight: 0.25);

    if (event is OnCheckOutButtonPressed) {
      yield CheckOutPanelShowing(event.visit);
    }

    if (event is OnVisitUpdated) {
      yield VisitUpdateInProgress(event.visit);
      yield VisitUpdateCompleted(maxHeight: 0.33);
    }

    if (event is OnEditButtonPressed) {
      yield EditVisitPanelShowing(event.visit);
    }

    if (event is OnEditPanelCheckOutButtonPressed) {
      yield CheckOutPickerDisplayed(DateTime.now());
    }

    if (event is OnCheckInDateTimeSpinnerChanged) {
      yield EditCheckInDateTimeUpdated(event.dateTime);
    }

    if (event is OnCheckOutDateTimeSpinnerChanged) {
      yield EditCheckOutDateTimeUpdated(event.dateTime);
    }

    if (event is OnTagDeleteButtonPressed) {
      yield TagsUpdated(event.tag);
    }

    if (event is OnTagAdded) {
      yield TagsUpdated(event.tag);
    }
  }
}
