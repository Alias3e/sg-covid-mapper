import 'package:equatable/equatable.dart';

abstract class SearchBoxEvent extends Equatable {}

class SearchBoxOpacityChanged extends SearchBoxEvent {
  final double bottomPanelPosition;

  SearchBoxOpacityChanged(this.bottomPanelPosition);

  double get opacity => bottomPanelPosition * -1 + 1;

  @override
  List<Object> get props => [bottomPanelPosition];
}
