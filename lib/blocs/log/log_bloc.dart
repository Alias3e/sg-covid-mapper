import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sgcovidmapper/blocs/log/log.dart';
import 'package:sgcovidmapper/repositories/my_visited_place_repository.dart';

class LogBloc extends Bloc<LogEvent, LogState> {
  final MyVisitedPlaceRepository _repository;

  LogBloc(this._repository) : assert(_repository != null);

  @override
  LogState get initialState => LogStateInitial();

  @override
  Stream<LogState> mapEventToState(LogEvent event) async* {
    if (event is OnDeleteConfirmed) {
      yield VisitDeleteInProgress(event.visit);
      await _repository.deleteVisit(event.visit);
      yield VisitDeleteCompleted(visit: event.visit, maxHeight: 0.25);
    }

    if (event is OnDeleteButtonPressed)
      yield DeleteConfirmationPanelShowing(event.visit);

    if (event is OnCancelButtonPressed) yield LogPanelClosing(maxHeight: 0.25);

    if (event is OnCheckOutButtonPressed) {
      yield CheckOutPanelShowing(event.visit);
    }

    if (event is OnVisitUpdated) {
      yield VisitUpdateInProgress();
      await _repository.updateVisit(event.visit);
      yield VisitUpdateCompleted(maxHeight: 0.33);
    }
  }
}
