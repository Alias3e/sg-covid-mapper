import 'package:bloc_test/bloc_test.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sgcovidmapper/blocs/blocs.dart';
import 'package:sgcovidmapper/models/one_map_search.dart';
import 'package:sgcovidmapper/models/one_map_search_result.dart';
import 'package:sgcovidmapper/repositories/one_map_repository.dart';

class MockGeolocationRepository extends Mock implements GeolocationRepository {}

main() {
  group('Search Bloc', () {
    GeolocationRepository repository;
    List<OneMapSearchResult> results;
    List<OneMapSearchResult> resultsTwo;
    OneMapSearch search;
    OneMapSearch searchTwo;

    setUp(() {
      repository = MockGeolocationRepository();
      results = [
        OneMapSearchResult(
          searchValue: faker.address.streetName(),
          postalCode: faker.address.zipCode(),
          longitudeString: faker.address.buildingNumber(),
          latitudeString: faker.address.countryCode(),
          address: faker.address.streetAddress(),
        ),
        OneMapSearchResult(
          searchValue: faker.address.streetName(),
          postalCode: faker.address.zipCode(),
          longitudeString: faker.address.buildingNumber(),
          latitudeString: faker.address.countryCode(),
          address: faker.address.streetAddress(),
        )
      ];
      search = OneMapSearch(results);
      searchTwo = OneMapSearch([
        OneMapSearchResult(
          searchValue: faker.address.streetName(),
          postalCode: faker.address.zipCode(),
          longitudeString: faker.address.buildingNumber(),
          latitudeString: faker.address.countryCode(),
          address: faker.address.streetAddress(),
        )
      ]);
    });

    test('has a correct initialState', () {
      SearchBloc bloc = SearchBloc(repository);
      expect(bloc.initialState, SearchEmpty());
      bloc.close();
    });

    test('throw AssertionError when GeolocationRepository is null', () {
      expect(() => SearchBloc(null), throwsAssertionError);
    });

    blocTest<SearchBloc, SearchEvent, SearchState>(
      'emits [SearchStarting] when user starts a search by clicking on the text field',
      build: () async => SearchBloc(repository),
      act: (bloc) async {
        bloc.add(BeginSearch());
      },
      expect: [SearchStarting()],
    );

    blocTest<SearchBloc, SearchEvent, SearchState>(
      'emits [SearchResultUpdated] when user starts to input search value',
      build: () async {
        when(repository.search('any'))
            .thenAnswer((_) => Future<OneMapSearch>.value(search));
        return SearchBloc(repository);
      },
      act: (bloc) async {
        bloc.add(SearchUpdated('any'));
      },
      wait: const Duration(milliseconds: 301),
      expect: [isA<SearchResultLoaded>()],
    );

    blocTest<SearchBloc, SearchEvent, SearchState>(
      'emits single [SearchResultUpdated, SearchResultUpdated] when 2 SearchUpdate events fired spaced apart to avoid debounce and switchMap',
      build: () async {
        when(repository.search('any'))
            .thenAnswer((_) => Future<OneMapSearch>.value(search));
        when(repository.search('any 2'))
            .thenAnswer((_) => Future<OneMapSearch>.value(searchTwo));
        return SearchBloc(repository);
      },
      act: (bloc) async {
        bloc.add(SearchUpdated('any'));
        await Future.delayed(const Duration(milliseconds: 500));
        bloc.add(SearchUpdated('any 2'));
      },
      wait: const Duration(milliseconds: 500),
      expect: [isA<SearchResultLoaded>(), isA<SearchResultLoaded>()],
    );

    blocTest<SearchBloc, SearchEvent, SearchState>(
      'emits single [SearchResultUpdated] even though 2 SearchUpdate events fired because of debounce and switchMap',
      build: () async {
        when(repository.search('any'))
            .thenAnswer((_) => Future<OneMapSearch>.value(search));
        when(repository.search('any 2'))
            .thenAnswer((_) => Future<OneMapSearch>.value(searchTwo));
        return SearchBloc(repository);
      },
      act: (bloc) async {
        bloc.add(SearchUpdated('any'));
        await Future.delayed(const Duration(milliseconds: 100));
        bloc.add(SearchUpdated('any 2'));
      },
      wait: const Duration(milliseconds: 500),
      expect: [isA<SearchResultLoaded>()],
    );

    blocTest<SearchBloc, SearchEvent, SearchState>(
      'emits [SearchEnded] when user clear the search box',
      build: () async => SearchBloc(repository),
      act: (SearchBloc bloc) async {
        bloc.add(BeginSearch());
        await Future.delayed(const Duration(milliseconds: 500));
        bloc.add(StopSearch());
      },
      skip: 0,
      wait: const Duration(milliseconds: 500),
      expect: [SearchEmpty(), SearchStarting(), SearchEmpty()],
    );
  });
}
