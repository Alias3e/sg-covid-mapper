import 'package:equatable/equatable.dart';

abstract class InitializationState extends Equatable {}

class Initializing extends InitializationState {
  @override
  List<Object> get props => [];
}

class InitializationComplete extends InitializationState {
  final bool showDisclaimer;
  final Map<String, dynamic> dialogContent;

  InitializationComplete(this.showDisclaimer, {this.dialogContent});
  @override
  List<Object> get props => [];
}

class DialogContentChange extends InitializationState {
  final int nextIndex;

  DialogContentChange(this.nextIndex);

  @override
  List<Object> get props => [nextIndex];
}
