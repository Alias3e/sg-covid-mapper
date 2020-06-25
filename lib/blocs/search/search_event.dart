import 'package:equatable/equatable.dart';

class SearchEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

/// This event represents the user tapping on the search box. At this point,
/// the user have not enter any search value.
class BeginSearch extends SearchEvent {}

/// This event is fired when user starts to input search value into the search
/// box.
class SearchUpdated extends SearchEvent {
  final String searchVal;

  SearchUpdated(this.searchVal);
  @override
  // TODO: implement props
  List<Object> get props => [searchVal];
}

class StopSearch extends SearchEvent {}
