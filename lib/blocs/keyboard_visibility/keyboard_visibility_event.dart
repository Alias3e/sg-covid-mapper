import 'package:equatable/equatable.dart';

abstract class KeyboardVisibilityEvent extends Equatable {}

class KeyboardVisibilityChanged extends KeyboardVisibilityEvent {
  final visibility;

  KeyboardVisibilityChanged(this.visibility);

  @override
  List<Object> get props => [visibility];
}
