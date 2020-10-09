import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:sgcovidmapper/blocs/keyboard_visibility/keyboard_visibility.dart';

class KeyboardVisibilityBloc
    extends Bloc<KeyboardVisibilityEvent, KeyboardVisibilityState> {
  KeyboardVisibilityBloc() {
    KeyboardVisibility.onChange
        .listen((isVisible) => add(KeyboardVisibilityChanged(isVisible)));
  }

  @override
  KeyboardVisibilityState get initialState => KeyboardVisible();

  @override
  Stream<KeyboardVisibilityState> mapEventToState(
      KeyboardVisibilityEvent event) async* {
    if (event is KeyboardVisibilityChanged) {
      yield event.visibility ? KeyboardVisible() : KeyboardNotVisible();
    }
  }
}
