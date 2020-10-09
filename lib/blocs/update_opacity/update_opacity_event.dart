import 'package:equatable/equatable.dart';

abstract class UpdateOpacityEvent extends Equatable {}

class OpacityChanged extends UpdateOpacityEvent {
  final double bottomPanelPosition;

  OpacityChanged(this.bottomPanelPosition);

  double get opacity => bottomPanelPosition * -1 + 1;

  @override
  List<Object> get props => [bottomPanelPosition];
}

class SearchBoxOpacityChanged extends OpacityChanged {
  SearchBoxOpacityChanged(double bottomPanelPosition)
      : super(bottomPanelPosition);
}

class SpeedDialOpacityChanged extends OpacityChanged {
  SpeedDialOpacityChanged(double bottomPanelPosition)
      : super(bottomPanelPosition);
}
