import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sgcovidmapper/models/covid_location.dart';
import 'package:sgcovidmapper/models/hive/visit.dart';

main() {
  Faker faker = Faker();
  group('Level 1 warning tests', () {
    test('No warning is found visit after covid', () {
      String postalCode = faker.randomGenerator.integer(100).toString();
      Visit visit = Visit();
      visit.title = faker.lorem.sentence();
      visit.postalCode = postalCode;
      visit.checkInTime = DateTime(2020, 6, 21, 8);
      visit.checkOutTime = DateTime(2020, 6, 21, 9);

      CovidLocation location = CovidLocation(
        postalCode: postalCode,
        title: faker.lorem.sentence(),
        startTime: DateTime(2020, 6, 21, 7),
        endTime: DateTime(2020, 6, 21, 7, 59),
      );

      visit.setWarningLevel(location);
      expect(visit.warningLevel, 0);
    });

    test('No warning is found visit before covid', () {
      String postalCode = faker.randomGenerator.integer(100).toString();
      Visit visit = Visit();
      visit.title = faker.lorem.sentence();
      visit.postalCode = postalCode;
      visit.checkInTime = DateTime(2020, 6, 21, 8);
      visit.checkOutTime = DateTime(2020, 6, 21, 9);

      CovidLocation location = CovidLocation(
        postalCode: postalCode,
        title: faker.lorem.sentence(),
        startTime: DateTime(2020, 6, 21, 9, 1),
        endTime: DateTime(2020, 6, 21, 10),
      );

      visit.setWarningLevel(location);
      expect(visit.warningLevel, 0);
    });

    test(
        'Level 1 warning visit start before covid, end same time as covid start',
        () {
      String postalCode = faker.randomGenerator.integer(100).toString();
      Visit visit = Visit();
      visit.title = faker.lorem.sentence();
      visit.postalCode = postalCode;
      visit.checkInTime = DateTime(2020, 6, 21, 8);
      visit.checkOutTime = DateTime(2020, 6, 21, 9, 1);

      CovidLocation location = CovidLocation(
        postalCode: postalCode,
        title: faker.lorem.sentence(),
        startTime: DateTime(2020, 6, 21, 9, 1),
        endTime: DateTime(2020, 6, 21, 10),
      );

      visit.setWarningLevel(location);
      expect(visit.warningLevel, 1);
    });

    test('Level 1 warning visit start before covid, end after covid start', () {
      String postalCode = faker.randomGenerator.integer(100).toString();
      Visit visit = Visit();
      visit.title = faker.lorem.sentence();
      visit.postalCode = postalCode;
      visit.checkInTime = DateTime(2020, 6, 21, 8);
      visit.checkOutTime = DateTime(2020, 6, 21, 9, 2);

      CovidLocation location = CovidLocation(
        postalCode: postalCode,
        title: faker.lorem.sentence(),
        startTime: DateTime(2020, 6, 21, 9, 1),
        endTime: DateTime(2020, 6, 21, 10),
      );

      visit.setWarningLevel(location);
      expect(visit.warningLevel, 1);
    });

    test(
        'Level 1 warning visit start same time as covid end, end after covid end',
        () {
      String postalCode = faker.randomGenerator.integer(100).toString();
      Visit visit = Visit();
      visit.title = faker.lorem.sentence();
      visit.postalCode = postalCode;
      visit.checkInTime = DateTime(2020, 6, 21, 10);
      visit.checkOutTime = DateTime(2020, 6, 21, 11);

      CovidLocation location = CovidLocation(
        postalCode: postalCode,
        title: faker.lorem.sentence(),
        startTime: DateTime(2020, 6, 21, 9),
        endTime: DateTime(2020, 6, 21, 10),
      );

      visit.setWarningLevel(location);
      expect(visit.warningLevel, 1);
    });

    test('Level 1 warning visit start before covid end, end after covid end',
        () {
      String postalCode = faker.randomGenerator.integer(100).toString();
      Visit visit = Visit();
      visit.title = faker.lorem.sentence();
      visit.postalCode = postalCode;
      visit.checkInTime = DateTime(2020, 6, 21, 9, 59);
      visit.checkOutTime = DateTime(2020, 6, 21, 11);

      CovidLocation location = CovidLocation(
        postalCode: postalCode,
        title: faker.lorem.sentence(),
        startTime: DateTime(2020, 6, 21, 9),
        endTime: DateTime(2020, 6, 21, 10),
      );

      visit.setWarningLevel(location);
      expect(visit.warningLevel, 1);
    });

    test('Level 1 warning visit start after covid start, end before covid end',
        () {
      String postalCode = faker.randomGenerator.integer(100).toString();
      Visit visit = Visit();
      visit.title = faker.lorem.sentence();
      visit.postalCode = postalCode;
      visit.checkInTime = DateTime(2020, 6, 21, 9, 1);
      visit.checkOutTime = DateTime(2020, 6, 21, 9, 59);

      CovidLocation location = CovidLocation(
        postalCode: postalCode,
        title: faker.lorem.sentence(),
        startTime: DateTime(2020, 6, 21, 9),
        endTime: DateTime(2020, 6, 21, 10),
      );

      visit.setWarningLevel(location);
      expect(visit.warningLevel, 1);
    });

    test(
        'Level 1 warning visit start same time as covid start, end same time as covid end',
        () {
      String postalCode = faker.randomGenerator.integer(100).toString();
      Visit visit = Visit();
      visit.title = faker.lorem.sentence();
      visit.postalCode = postalCode;
      visit.checkInTime = DateTime(2020, 6, 21, 9);
      visit.checkOutTime = DateTime(2020, 6, 21, 10);

      CovidLocation location = CovidLocation(
        postalCode: postalCode,
        title: faker.lorem.sentence(),
        startTime: DateTime(2020, 6, 21, 9),
        endTime: DateTime(2020, 6, 21, 10),
      );

      visit.setWarningLevel(location);
      expect(visit.warningLevel, 1);
    });
  });

  group('Level 2 warning tests', () {
    test('Level 2 warning tag match', () {
      String postalCode = faker.randomGenerator.integer(100).toString();
      Visit visit = Visit();
      visit.title = faker.lorem.sentence();
      visit.postalCode = postalCode;
      visit.checkInTime = DateTime(2020, 6, 21, 9);
      visit.checkOutTime = DateTime(2020, 6, 21, 10);
      visit.tags = ['Ramada Zhongshan Park'];

      CovidLocation location = CovidLocation(
        postalCode: postalCode,
        title: 'Ramada by Wyndham Singapore at Zhongshan Park',
        subtitle: '',
        startTime: DateTime(2020, 6, 21, 9),
        endTime: DateTime(2020, 6, 21, 10),
      );

      visit.setWarningLevel(location);
      expect(visit.warningLevel, 1);
    });
  });
}
