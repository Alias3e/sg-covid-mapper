import 'package:equatable/equatable.dart';

abstract class InitializationEvent extends Equatable {}

class BeginInitialization extends InitializationEvent {
  @override
  List<Object> get props => [];
}
