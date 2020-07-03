import 'package:equatable/equatable.dart';

class SearchEvent extends Equatable {
  @override
  List<Object> get props => throw UnimplementedError();
}

/// This event represents the user tapping on the search box. At this point,
/// the user have not enter any search value.
class BeginSearch extends SearchEvent {}

/// This event is fired when user starts to input search value into the search
/// box.
class SearchValueChanged extends SearchEvent {
  final String searchVal;

  SearchValueChanged(this.searchVal);
  @override
  List<Object> get props => [searchVal];
}

class SearchStopped extends SearchEvent {}

class SearchLocationTapped extends SearchEvent {
  final int index;

  SearchLocationTapped(this.index);

  @override
  List<Object> get props => [index];
}
