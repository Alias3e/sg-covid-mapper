import 'package:equatable/equatable.dart';

abstract class InitializationState extends Equatable {}

class Initializing extends InitializationState {
  @override
  List<Object> get props => [];
}

class InitializationComplete extends InitializationState {
  @override
  List<Object> get props => [];
}
