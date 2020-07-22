import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sgcovidmapper/models/timeline/date_timeline_tile_model.dart';
import 'package:sgcovidmapper/models/timeline/location_timeline_tile_model.dart';
import 'package:sgcovidmapper/models/timeline/timeline_model.dart';

main() {
  group('get timeline models', () {
    Faker faker;
    setUp(() {
      faker = Faker();
    });

    test('simple single date model', () {
      List<LocationTimelineTileModel> locationModels = [
        LocationTimelineTileModel(
            title: faker.lorem.sentence(),
            subtitle: faker.lorem.sentence(),
            startTime: DateTime(2020, 6, 21),
            endTime: DateTime(2020, 6, 21),
            type: TimelineType.covid),
      ];

      TimelineModel model = TimelineModel(locationModels);
      expect(model.allTiles.length, 2);
      expect(model.allTiles[0], isA<DateTimelineTileModel>());
      expect(model.allTiles[1], isA<LocationTimelineTileModel>());
      expect(
          (model.allTiles[0] as DateTimelineTileModel).dateString, '21\nJun');
    });

    test('single date tile multiple location', () {
      List<LocationTimelineTileModel> locationModels = [
        LocationTimelineTileModel(
            title: faker.lorem.sentence(),
            subtitle: faker.lorem.sentence(),
            startTime: DateTime(2020, 6, 21),
            endTime: DateTime(2020, 6, 21),
            type: TimelineType.covid),
        LocationTimelineTileModel(
            title: faker.lorem.sentence(),
            subtitle: faker.lorem.sentence(),
            startTime: DateTime(2020, 6, 21),
            endTime: DateTime(2020, 6, 21),
            type: TimelineType.covid),
        LocationTimelineTileModel(
            title: faker.lorem.sentence(),
            subtitle: faker.lorem.sentence(),
            startTime: DateTime(2020, 6, 21),
            endTime: DateTime(2020, 6, 21),
            type: TimelineType.covid),
      ];

      TimelineModel model = TimelineModel(locationModels);
      expect(model.allTiles.length, 4);
      expect(model.allTiles[0], isA<DateTimelineTileModel>());
      expect(model.allTiles[1], isA<LocationTimelineTileModel>());
      expect(model.allTiles[2], isA<LocationTimelineTileModel>());
      expect(model.allTiles[3], isA<LocationTimelineTileModel>());
      expect(
          (model.allTiles[0] as DateTimelineTileModel).dateString, '21\nJun');
    });

    test('two date tile multiple location', () {
      List<LocationTimelineTileModel> locationModels = [
        LocationTimelineTileModel(
            title: faker.lorem.sentence(),
            subtitle: faker.lorem.sentence(),
            startTime: DateTime(2020, 6, 21),
            endTime: DateTime(2020, 6, 21),
            type: TimelineType.covid),
        LocationTimelineTileModel(
            title: faker.lorem.sentence(),
            subtitle: faker.lorem.sentence(),
            startTime: DateTime(2020, 6, 21),
            endTime: DateTime(2020, 6, 21),
            type: TimelineType.covid),
        LocationTimelineTileModel(
            title: faker.lorem.sentence(),
            subtitle: faker.lorem.sentence(),
            startTime: DateTime(2020, 6, 22),
            endTime: DateTime(2020, 6, 22),
            type: TimelineType.covid),
      ];

      TimelineModel model = TimelineModel(locationModels);
      expect(model.allTiles.length, 5);
      expect(model.allTiles[0], isA<DateTimelineTileModel>());
      expect(model.allTiles[1], isA<LocationTimelineTileModel>());
      expect(model.allTiles[2], isA<LocationTimelineTileModel>());
      expect(model.allTiles[3], isA<DateTimelineTileModel>());
      expect(model.allTiles[4], isA<LocationTimelineTileModel>());
      expect(
          (model.allTiles[0] as DateTimelineTileModel).dateString, '21\nJun');
      expect(
          (model.allTiles[3] as DateTimelineTileModel).dateString, '22\nJun');
    });
  });
}
