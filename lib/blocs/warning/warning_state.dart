import 'package:equatable/equatable.dart';

abstract class WarningState extends Equatable {}

class WarningLevelUnchanged extends WarningState {
  @override
  List<Object> get props => [];
}

class WarningLevelUpdated extends WarningState {
  final int timestamp;

  WarningLevelUpdated(this.timestamp);

  @override
  List<Object> get props => [timestamp];
}
