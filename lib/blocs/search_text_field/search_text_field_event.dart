import 'package:equatable/equatable.dart';

abstract class SearchTextFieldEvent extends Equatable {}

class FocusSearchTextField extends SearchTextFieldEvent {
  @override
  List<Object> get props => [];
}

class SearchTextFieldLoseFocus extends SearchTextFieldEvent {
  @override
  List<Object> get props => [];
}
