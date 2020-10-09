import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sgcovidmapper/blocs/keyboard_visibility/keyboard_visibility.dart';

main() {
  setUp(() {
    WidgetsFlutterBinding.ensureInitialized();
  });

  test('initial state is KeyboardVisible', () async {
    KeyboardVisibilityBloc bloc = KeyboardVisibilityBloc();

    expect(bloc.initialState, KeyboardVisible());
    bloc.close();
  });

  blocTest(
    'emits [KeyboardNotVisible] after keyboard is hidden from screen',
    build: () async {
      return KeyboardVisibilityBloc();
    },
    act: (bloc) async {
      bloc.add(KeyboardVisibilityChanged(false));
    },
    expect: [KeyboardNotVisible()],
  );

  blocTest(
    'emits [KeyboardNotVisible, KeyboardVisibled] after keyboard is hidden and then activated again',
    build: () async {
      return KeyboardVisibilityBloc();
    },
    act: (bloc) async {
      bloc.add(KeyboardVisibilityChanged(false));
      bloc.add(KeyboardVisibilityChanged(true));
    },
    expect: [KeyboardNotVisible(), KeyboardVisible()],
  );
}
