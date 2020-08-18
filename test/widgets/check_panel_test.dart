import 'package:bloc_test/bloc_test.dart';
import 'package:faker/faker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sgcovidmapper/blocs/bottom_panel/bottom_panel.dart';
import 'package:sgcovidmapper/blocs/check_panel/check_panel.dart';
import 'package:sgcovidmapper/models/one_map/common_one_map_model.dart';
import 'package:sgcovidmapper/models/one_map/one_map.dart';
import 'package:sgcovidmapper/widgets/check/check.dart';

class MockCheckPanelBloc extends MockBloc<CheckPanelEvent, CheckPanelLoaded>
    implements CheckPanelBloc {}

main() {
  CheckPanelBloc bloc;
  CheckInPanelData data;
  Faker faker;

  setUp(() {
    faker = Faker();
    bloc = MockCheckPanelBloc();
    data = CheckInPanelData(
        CommonOneMapModel.fromSearchResultModel(OneMapSearchResult(
          searchValue: faker.lorem.word(),
          address: faker.address.streetAddress(),
          postalCode: faker.address.zipCode(),
          latitudeString: faker.randomGenerator.decimal().toString(),
          longitudeString: faker.randomGenerator.decimal().toString(),
        )),
        DateTime.now());
  });

  tearDown(() {
    bloc.close();
  });

  group('CheckPanel layout tests', () {
    testWidgets('initial layout displayed correctly',
        (WidgetTester tester) async {
      when(bloc.state).thenAnswer((_) => CheckPanelLoaded(data));
      await tester.pumpWidget(BlocProvider<CheckPanelBloc>.value(
        value: bloc,
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: CheckPanel(
            switchOutEvent: ReverseGeocodePanelSwitched(),
          ),
        ),
      ));

      // Check title
      expect(find.text(data.location.title), findsOneWidget);
      // check in date time text
      expect(
          find.byWidgetPredicate((widget) =>
              widget is Text && widget.data.startsWith('Check in : ')),
          findsOneWidget);
      // Single picker.
      expect(find.byType(CheckPanelDateTimePicker), findsOneWidget);

      // Check out button, done button and cancel button
      expect(find.byType(CheckPanelButton), findsNWidgets(3));
      expect(find.text('Done'), findsOneWidget);
      expect(find.text('Check out'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('check out is optional'), findsOneWidget);
    });

    testWidgets('check out layout is displayed correctly',
        (WidgetTester tester) async {
      when(bloc.state).thenAnswer((_) => CheckOutDateTimeWidgetLoaded());
      await tester.pumpWidget(BlocProvider<CheckPanelBloc>.value(
        value: bloc,
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: CheckPanel(
            switchOutEvent: ReverseGeocodePanelSwitched(),
          ),
        ),
      ));

      // Check in date time text.
      expect(
          find.byWidgetPredicate((widget) =>
              widget is Text && widget.data.startsWith('Check in : ')),
          findsOneWidget);
      // Check out date time text.
      expect(
          find.byWidgetPredicate((widget) =>
              widget is Text && widget.data.startsWith('Check out : ')),
          findsOneWidget);

      // Two pickers, one for check in and one for check out.
      expect(find.byType(CheckPanelDateTimePicker), findsNWidgets(2));

      // Check out button and Save button
      expect(find.byType(CheckPanelButton), findsNWidgets(2));
      expect(find.text('Done'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
      // Check out button and optional text do not exist anymore.
      expect(find.text('Check out'), findsNothing);
      expect(find.text('check out is optional'), findsNothing);
    });
  });

  group('User interaction tests', () {
    testWidgets('tap check out buttons fires CheckOutDateTimeDisplayed event',
        (WidgetTester tester) async {
      when(bloc.state).thenAnswer((_) => CheckPanelLoaded(CheckInPanelData(
          CommonOneMapModel(
              latitude: 1.4,
              longitude: 103.5,
              title: faker.lorem.sentence(),
              subtitle: faker.lorem.sentence(),
              postalCode: faker.address.zipCode()),
          DateTime.now())));
      await tester.pumpWidget(BlocProvider<CheckPanelBloc>.value(
        value: bloc,
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: CheckPanel(
            switchOutEvent: ReverseGeocodePanelSwitched(),
          ),
        ),
      ));

      await tester.tap(find.byWidgetPredicate((widget) =>
          widget is CheckPanelButton && widget.text == 'Check out'));
      await tester.pump();

      verify(bloc.add(CheckOutDateTimeDisplayed()));
    });
  });
}
