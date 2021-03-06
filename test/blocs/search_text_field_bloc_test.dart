import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sgcovidmapper/blocs/search_text_field/search_text_field.dart';

main() {
  group('SearchTextFieldBloc tests', () {
    test('initial state is SearchTextFieldNotFocus', () async {
      SearchTextFieldBloc bloc = SearchTextFieldBloc();
      expect(bloc.initialState, SearchTextFieldNotFocused());
      bloc.close();
    });

    blocTest(
      'emits [SearchTextFieldFocused] after an ActivateSearchTextField event is fired',
      build: () async {
        return SearchTextFieldBloc();
      },
      act: (bloc) async {
        bloc.add(FocusSearchTextField());
      },
      expect: [SearchTextFieldFocused()],
    );

    blocTest(
      'emits [SearchTextFieldFocused, SearchTextFieldNotFocused] after an search field is typed on and then lost focus due to other elements being pressed',
      build: () async {
        return SearchTextFieldBloc();
      },
      act: (bloc) async {
        bloc.add(FocusSearchTextField());
        bloc.add(SearchTextFieldLoseFocus());
      },
      expect: [SearchTextFieldFocused(), SearchTextFieldNotFocused()],
    );
  });
}
