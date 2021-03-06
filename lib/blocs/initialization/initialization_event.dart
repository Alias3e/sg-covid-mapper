import 'package:equatable/equatable.dart';

abstract class InitializationEvent extends Equatable {}

class BeginInitialization extends InitializationEvent {
  @override
  List<Object> get props => [];
}

class OnDialogChanged extends InitializationEvent {
  final int nextIndex;

  OnDialogChanged(this.nextIndex);
  @override
  List<Object> get props => [nextIndex];
}
