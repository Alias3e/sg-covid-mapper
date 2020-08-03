import 'package:equatable/equatable.dart';

abstract class WarningState extends Equatable {}

class WarningLevelUnchanged extends WarningState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class WarningLevelUpdated extends WarningState {
  @override
  List<Object> get props => [];
}
