import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sgcovidmapper/blocs/bottom_panel/bottom_panel.dart';
import 'package:sgcovidmapper/blocs/update_opacity/update_opacity.dart';

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
      expect(() => UpdateOpacityBloc(null), throwsAssertionError);
    });

    test('initial state is SearchBoxFullyOpaque', () {
      UpdateOpacityBloc bloc = UpdateOpacityBloc(bottomPanelBloc);
      expect(bloc.initialState, WidgetFullyOpaque());
      bloc.close();
    });

    blocTest('emits OpacityUpdating when places panel height changes',
        build: () async {
          UpdateOpacityBloc bloc = UpdateOpacityBloc(bottomPanelBloc);
          return bloc;
        },
        act: (bloc) => bloc.add(OpacityChanged(1.0)),
        expect: [isA<OpacityUpdating>()]);

    blocTest('emits SearchBoxOpacityUpdating when geocode panel height changes',
        build: () async {
          UpdateOpacityBloc bloc = UpdateOpacityBloc(bottomPanelBloc);
          return bloc;
        },
        act: (bloc) => bloc.add(SearchBoxOpacityChanged(1.0)),
        expect: [isA<SearchBoxOpacityUpdating>()]);

    blocTest('emits SpeedDialOpacityUpdating when search panel height changes',
        build: () async {
          UpdateOpacityBloc bloc = UpdateOpacityBloc(bottomPanelBloc);
          return bloc;
        },
        act: (bloc) => bloc.add(SpeedDialOpacityChanged(1.0)),
        expect: [isA<SpeedDialOpacityUpdating>()]);
  });
}
