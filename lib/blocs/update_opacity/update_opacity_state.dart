import 'package:equatable/equatable.dart';

abstract class UpdateOpacityState extends Equatable {
  final double opacity;

  UpdateOpacityState(this.opacity);
}

class WidgetFullyOpaque extends UpdateOpacityState {
  WidgetFullyOpaque() : super(1.0);

  @override
  List<Object> get props => [];
}

class WidgetFullyTransparent extends UpdateOpacityState {
  WidgetFullyTransparent() : super(0.0);

  @override
  List<Object> get props => [];
}

class OpacityUpdating extends UpdateOpacityState {
  OpacityUpdating(double opacity) : super(opacity);

  @override
  List<Object> get props => [opacity];
}

class SearchBoxOpacityUpdating extends OpacityUpdating {
  SearchBoxOpacityUpdating(double opacity) : super(opacity);
}

class SpeedDialOpacityUpdating extends OpacityUpdating {
  SpeedDialOpacityUpdating(double opacity) : super(opacity);
}
