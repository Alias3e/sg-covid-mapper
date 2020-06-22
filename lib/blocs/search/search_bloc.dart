import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sgcovidmapper/blocs/search/search_event.dart';
import 'package:sgcovidmapper/blocs/search/search_state.dart';
import 'package:sgcovidmapper/models/one_map_search.dart';
import 'package:sgcovidmapper/repositories/one_map_repository.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final GeolocationRepository _repository;

  SearchBloc(this._repository) : assert(_repository != null);

  @override
  // TODO: implement initialState
  SearchState get initialState => SearchEmpty();

  @override
  Stream<Transition<SearchEvent, SearchState>> transformEvents(
      Stream<SearchEvent> events, transitionFn) {
    final debounceStream = events
        .where((event) => event is SearchUpdated)
        .debounceTime(Duration(milliseconds: 300))
        .switchMap(transitionFn);

    final nonDebounceStream = events
        .where((event) => !(event is SearchUpdated))
        .asyncExpand(transitionFn);
//    return super.transformEvents(
//        MergeStream([debounceStream, nonDebounceStream]), transitionFn);
    return MergeStream([debounceStream, nonDebounceStream]);
  }

  @override
  Stream<SearchState> mapEventToState(SearchEvent event) async* {
    // TODO: implement mapEventToState
    if (event is BeginSearch) yield SearchStarting();

    if (event is StopSearch) yield SearchEmpty();

    if (event is SearchUpdated) {
      OneMapSearch result =
          await _repository.search(event.searchVal).catchError(
        (Object obj) {
          // non-200 error goes here.
          switch (obj.runtimeType) {
            case DioError:
              // Here's the sample to get the failed response error code and message
              final res = (obj as DioError).response;
              print(
                  "Got error : ${res.statusCode} -> ${res.statusMessage} -> ${res.toString()}");
              break;
            default:
          }
        },
      );
      yield SearchResultLoaded(result);
    }
  }
}
