import 'package:equatable/equatable.dart';
import 'package:sgcovidmapper/models/one_map_search.dart';

class SearchState extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class SearchEmpty extends SearchState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class SearchStarting extends SearchState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class SearchResultLoading extends SearchState {}

class SearchResultLoaded extends SearchState {
  final OneMapSearch result;
  final int selected;

  SearchResultLoaded(this.result, this.selected);
  @override
  // TODO: implement props
  List<Object> get props => [result, selected];
}
