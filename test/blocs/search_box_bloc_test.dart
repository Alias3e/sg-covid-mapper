import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sgcovidmapper/blocs/bottom_panel/bottom_panel.dart';
import 'package:sgcovidmapper/blocs/search_box/search_box.dart';

class MockBottomPanelBloc extends MockBloc<BottomPanelEvent, BottomPanelState>
    implements BottomPanelBloc {}

main() {
  group('Search bloc tests', () {
    MockBottomPanelBloc bottomPanelBloc;
    setUp(() {
      bottomPanelBloc = MockBottomPanelBloc();
    });

    tearDown(() {
      bottomPanelBloc.close();
    });

    test('throw AssertionError when BottomPanelBloc is null', () {
      expect(() => SearchBoxBloc(null), throwsAssertionError);
    });

    test('initial state is SearchBoxFullyOpaque', () {
      SearchBoxBloc bloc = SearchBoxBloc(bottomPanelBloc);
      expect(bloc.initialState, SearchBoxFullyOpaque());
      bloc.close();
    });

    blocTest('emits SearchBoxOpacityUpdating when bottom panel height changes',
        build: () async {
          SearchBoxBloc bloc = SearchBoxBloc(bottomPanelBloc);
          return bloc;
        },
        act: (bloc) => bloc.add(SearchBoxOpacityChanged(1.0)),
        expect: [isA<SearchBoxOpacityUpdating>()]);
  });
}
