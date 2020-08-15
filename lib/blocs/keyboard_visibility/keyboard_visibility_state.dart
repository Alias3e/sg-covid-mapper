import 'package:equatable/equatable.dart';

abstract class KeyboardVisibilityState extends Equatable {}

class KeyboardVisible extends KeyboardVisibilityState {
  @override
  List<Object> get props => [];
}

class KeyboardNotVisible extends KeyboardVisibilityState {
  @override
  List<Object> get props => [];
}
