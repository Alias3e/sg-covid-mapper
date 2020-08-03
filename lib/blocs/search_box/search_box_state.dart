import 'package:equatable/equatable.dart';

abstract class SearchBoxState extends Equatable {}

class SearchBoxFullyOpaque extends SearchBoxState {
  @override
  List<Object> get props => [];
}

class SearchBoxFullyTransparent extends SearchBoxState {
  @override
  List<Object> get props => [];
}

class SearchBoxOpacityUpdating extends SearchBoxState {
  final double opacity;

  SearchBoxOpacityUpdating(this.opacity);

  @override
  List<Object> get props => [opacity];
}
