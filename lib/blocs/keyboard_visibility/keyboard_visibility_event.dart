import 'package:equatable/equatable.dart';

abstract class KeyboardVisibilityEvent extends Equatable {}

class KeyboardVisibilityChanged extends KeyboardVisibilityEvent {
  final visibility;

  KeyboardVisibilityChanged(this.visibility);

  @override
  // TODO: implement props
  List<Object> get props => [visibility];
}
