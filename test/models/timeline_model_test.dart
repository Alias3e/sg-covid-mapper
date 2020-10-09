import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sgcovidmapper/models/timeline/date_timeline_item.dart';
import 'package:sgcovidmapper/models/timeline/divider_timeline_item.dart';
import 'package:sgcovidmapper/models/timeline/indicator_timeline_item.dart';
import 'package:sgcovidmapper/models/timeline/location_timeline_item.dart';
import 'package:sgcovidmapper/models/timeline/timeline_model.dart';
import 'package:sgcovidmapper/models/timeline/visit_timeline_item.dart';

main() {
  group('get timeline models', () {
    Faker faker;
    setUp(() {
      faker = Faker();
    });

    test('single covid location model', () {
      List<LocationTimelineItem> locationModels = [
        LocationTimelineItem(
          title: faker.lorem.sentence(),
          subtitle: faker.lorem.sentence(),
          startTime: DateTime(2020, 6, 21),
          endTime: DateTime(2020, 6, 21),
          lineX: faker.randomGenerator.decimal(),
        ),
      ];

      TimelineModel model = TimelineModel.fromLocation(locationModels);
      expect(model.tiles.length, 3);
      expect(model.tiles[0], isA<DateTimelineItem>());
      expect(model.tiles[1], isA<DividerTimelineItem>());
      expect((model.tiles[1] as DividerTimelineItem).direction,
          DividerDirection.left);
      expect(model.tiles[2], isA<LocationTimelineItem>());
      expect((model.tiles[0] as DateTimelineItem).dateString, '21 Jun');
    });

    test('single visit model', () {
      List<VisitTimelineItem> myLocationModels = [
        VisitTimelineItem(
          title: faker.lorem.sentence(),
          startTime: DateTime(2020, 6, 21),
          endTime: DateTime(2020, 6, 21),
          lineX: faker.randomGenerator.decimal(),
          warningLevel: 0,
          chips: [],
        ),
      ];

      TimelineModel model = TimelineModel.fromLocation(myLocationModels);
      expect(model.tiles.length, 3);
      expect(model.tiles[0], isA<DateTimelineItem>());
      expect(model.tiles[1], isA<DividerTimelineItem>());
      expect((model.tiles[1] as DividerTimelineItem).direction,
          DividerDirection.right);
      expect(model.tiles[2], isA<VisitTimelineItem>());
      expect((model.tiles[0] as DateTimelineItem).dateString, '21 Jun');
    });

    test('single visit single covid location different date model', () {
      List<VisitTimelineItem> myVisitedLocationModels = [
        VisitTimelineItem(
          title: faker.lorem.sentence(),
          startTime: DateTime(2020, 6, 21),
          endTime: DateTime(2020, 6, 21),
          lineX: faker.randomGenerator.decimal(),
          warningLevel: 0,
          chips: [],
        ),
      ];

      List<LocationTimelineItem> covidLocationModels = [
        LocationTimelineItem(
          title: faker.lorem.sentence(),
          subtitle: faker.lorem.sentence(),
          startTime: DateTime(2020, 6, 22),
          endTime: DateTime(2020, 6, 22),
          lineX: faker.randomGenerator.decimal(),
        ),
      ];

      List<ChildTimelineItem> items = [];
      items..addAll(myVisitedLocationModels)..addAll(covidLocationModels);

      TimelineModel model = TimelineModel.fromLocation(items);
      expect(model.tiles.length, 7);
      // Display date indicator.
      expect(model.tiles[0], isA<DateTimelineItem>());
      expect((model.tiles[0] as DateTimelineItem).dateString, '21 Jun');

      // Divider to link date to visit on the right.
      expect(model.tiles[1], isA<DividerTimelineItem>());
      expect((model.tiles[1] as DividerTimelineItem).direction,
          DividerDirection.right);

      // Visit
      expect(model.tiles[2], isA<VisitTimelineItem>());

      // Divider to link visit to date on the right.
      expect(model.tiles[3], isA<DividerTimelineItem>());
      expect((model.tiles[3] as DividerTimelineItem).direction,
          DividerDirection.right);

      // Display date indicator.
      expect(model.tiles[4], isA<DateTimelineItem>());
      expect((model.tiles[4] as DateTimelineItem).dateString, '22 Jun');

      // Divider to link visit to date on the right.
      expect(model.tiles[5], isA<DividerTimelineItem>());
      expect((model.tiles[5] as DividerTimelineItem).direction,
          DividerDirection.left);

      // Covid location
      expect(model.tiles[6], isA<LocationTimelineItem>());
    });

    test('single visit follow by single covid same date', () {
      List<VisitTimelineItem> myVisitedLocationModels = [
        VisitTimelineItem(
          title: faker.lorem.sentence(),
          startTime: DateTime(2020, 6, 21),
          endTime: DateTime(2020, 6, 21),
          lineX: faker.randomGenerator.decimal(),
          warningLevel: 0,
          chips: [],
        ),
      ];

      List<LocationTimelineItem> covidLocationModels = [
        LocationTimelineItem(
          title: faker.lorem.sentence(),
          subtitle: faker.lorem.sentence(),
          startTime: DateTime(2020, 6, 21),
          endTime: DateTime(2020, 6, 22),
          lineX: faker.randomGenerator.decimal(),
        ),
      ];

      List<ChildTimelineItem> items = [];
      items..addAll(myVisitedLocationModels)..addAll(covidLocationModels);

      TimelineModel model = TimelineModel.fromLocation(items);
      expect(model.tiles.length, 5);
      // Display date indicator.
      expect(model.tiles[0], isA<DateTimelineItem>());
      expect((model.tiles[0] as DateTimelineItem).dateString, '21 Jun');

      // Divider to link date to visit on the right.
      expect(model.tiles[1], isA<DividerTimelineItem>());
      expect((model.tiles[1] as DividerTimelineItem).direction,
          DividerDirection.right);

      // Visit
      expect(model.tiles[2], isA<VisitTimelineItem>());

      // Divider to link visit to covid across.
      expect(model.tiles[3], isA<DividerTimelineItem>());
      expect((model.tiles[3] as DividerTimelineItem).direction,
          DividerDirection.across);

      // Covid location
      expect(model.tiles[4], isA<LocationTimelineItem>());
    });

    test('single covid follow by single visit same date', () {
      List<VisitTimelineItem> myVisitedLocationModels = [
        VisitTimelineItem(
          title: faker.lorem.sentence(),
          startTime: DateTime(2020, 6, 21),
          endTime: DateTime(2020, 6, 22),
          lineX: faker.randomGenerator.decimal(),
          warningLevel: 0,
          chips: [],
        ),
      ];

      List<LocationTimelineItem> covidLocationModels = [
        LocationTimelineItem(
          title: faker.lorem.sentence(),
          subtitle: faker.lorem.sentence(),
          startTime: DateTime(2020, 6, 21),
          endTime: DateTime(2020, 6, 21),
          lineX: faker.randomGenerator.decimal(),
        ),
      ];

      List<ChildTimelineItem> items = [];
      items..addAll(myVisitedLocationModels)..addAll(covidLocationModels);

      TimelineModel model = TimelineModel.fromLocation(items);
      expect(model.tiles.length, 5);
      // Display date indicator.
      expect(model.tiles[0], isA<DateTimelineItem>());
      expect((model.tiles[0] as DateTimelineItem).dateString, '21 Jun');

      // Divider to link date to covid on the left.
      expect(model.tiles[1], isA<DividerTimelineItem>());
      expect((model.tiles[1] as DividerTimelineItem).direction,
          DividerDirection.left);

      // covid tile
      expect(model.tiles[2], isA<LocationTimelineItem>());

      // Divider to link visit to covid across.
      expect(model.tiles[3], isA<DividerTimelineItem>());
      expect((model.tiles[3] as DividerTimelineItem).direction,
          DividerDirection.across);

      // visit tile
      expect(model.tiles[4], isA<VisitTimelineItem>());
    });

    test('single date tile multiple location', () {
      List<LocationTimelineItem> locationModels = [
        LocationTimelineItem(
          title: faker.lorem.sentence(),
          subtitle: faker.lorem.sentence(),
          startTime: DateTime(2020, 6, 21),
          endTime: DateTime(2020, 6, 21),
          lineX: faker.randomGenerator.decimal(),
        ),
        LocationTimelineItem(
          title: faker.lorem.sentence(),
          subtitle: faker.lorem.sentence(),
          startTime: DateTime(2020, 6, 21),
          endTime: DateTime(2020, 6, 21),
          lineX: faker.randomGenerator.decimal(),
        ),
        LocationTimelineItem(
          title: faker.lorem.sentence(),
          subtitle: faker.lorem.sentence(),
          startTime: DateTime(2020, 6, 21),
          endTime: DateTime(2020, 6, 21),
          lineX: faker.randomGenerator.decimal(),
        ),
      ];

      TimelineModel model = TimelineModel.fromLocation(locationModels);
      expect(model.tiles.length, 5);
      expect(model.tiles[0], isA<DateTimelineItem>());
      expect(model.tiles[1], isA<DividerTimelineItem>());
      expect((model.tiles[1] as DividerTimelineItem).direction,
          DividerDirection.left);
      expect(model.tiles[2], isA<LocationTimelineItem>());
      expect(model.tiles[3], isA<LocationTimelineItem>());
      expect(model.tiles[4], isA<LocationTimelineItem>());
      expect((model.tiles[0] as DateTimelineItem).dateString, '21 Jun');
    });

    test('three date tile multiple location & visit with across divider', () {
      List<LocationTimelineItem> locationModels = [
        LocationTimelineItem(
          title: faker.lorem.sentence(),
          subtitle: faker.lorem.sentence(),
          startTime: DateTime(2020, 6, 21),
          endTime: DateTime(2020, 6, 21),
          lineX: faker.randomGenerator.decimal(),
        ),
        LocationTimelineItem(
          title: faker.lorem.sentence(),
          subtitle: faker.lorem.sentence(),
          startTime: DateTime(2020, 6, 21),
          endTime: DateTime(2020, 6, 21),
          lineX: faker.randomGenerator.decimal(),
        ),
        LocationTimelineItem(
          title: faker.lorem.sentence(),
          subtitle: faker.lorem.sentence(),
          startTime: DateTime(2020, 6, 22),
          endTime: DateTime(2020, 6, 22),
          lineX: faker.randomGenerator.decimal(),
        ),
      ];

      List<VisitTimelineItem> visitModels = [
        VisitTimelineItem(
          startTime: DateTime(2020, 6, 22),
          endTime: DateTime(2020, 6, 22),
          title: faker.lorem.sentence(),
          lineX: faker.randomGenerator.decimal(),
          warningLevel: 0,
          chips: [],
        )
      ];

      List<ChildTimelineItem> items = [];
      items..addAll(locationModels)..addAll(visitModels);

      TimelineModel model = TimelineModel.fromLocation(items);
      expect(model.tiles.length, 10);
      // Initial timeline set at 21 jun
      expect(model.tiles[0], isA<DateTimelineItem>());
      expect((model.tiles[0] as DateTimelineItem).dateString, '21 Jun');

      // Divider line link date to covid on the left.
      expect(model.tiles[1], isA<DividerTimelineItem>());
      expect((model.tiles[1] as DividerTimelineItem).direction,
          DividerDirection.left);
      // Two location item
      expect(model.tiles[2], isA<LocationTimelineItem>());
      expect(model.tiles[3], isA<LocationTimelineItem>());

      // Divider line link date to covid on the left.
      expect(model.tiles[4], isA<DividerTimelineItem>());
      expect((model.tiles[4] as DividerTimelineItem).direction,
          DividerDirection.left);

      // date timeline displaying 22 Jun
      expect(model.tiles[5], isA<DateTimelineItem>());
      expect((model.tiles[5] as DateTimelineItem).dateString, '22 Jun');

      // Divider line link date to visit on the right.
      expect(model.tiles[6], isA<DividerTimelineItem>());
      expect((model.tiles[6] as DividerTimelineItem).direction,
          DividerDirection.right);

      expect(model.tiles[7], isA<VisitTimelineItem>());
      // Divider line link visit to covid across the tile.
      expect(model.tiles[8], isA<DividerTimelineItem>());
      expect((model.tiles[8] as DividerTimelineItem).direction,
          DividerDirection.across);

      expect(model.tiles[9], isA<LocationTimelineItem>());
    });
  });
}
