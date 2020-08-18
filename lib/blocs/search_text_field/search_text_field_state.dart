import 'package:equatable/equatable.dart';

abstract class SearchTextFieldState extends Equatable {}

class SearchTextFieldFocused extends SearchTextFieldState {
  @override
  List<Object> get props => [];
}

class SearchTextFieldNotFocused extends SearchTextFieldState {
  @override
  List<Object> get props => [];
}
