import 'package:bloc_test/bloc_test.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sgcovidmapper/blocs/search/search.dart';
import 'package:sgcovidmapper/models/one_map/common_one_map_model.dart';
import 'package:sgcovidmapper/models/one_map/one_map.dart';
import 'package:sgcovidmapper/repositories/GeolocationRepository.dart';

class MockGeolocationRepository extends Mock implements GeolocationRepository {}

main() {
  group('Search Bloc', () {
    GeolocationRepository repository;
    List<CommonOneMapModel> results;
    OneMapSearch search;
    OneMapSearch searchTwo;

    setUp(() {
      repository = MockGeolocationRepository();
      results = [
        CommonOneMapModel.fromSearchResultModel(OneMapSearchResult(
          searchValue: faker.address.streetName(),
          postalCode: faker.address.zipCode(),
          longitudeString: faker.address.buildingNumber(),
          latitudeString: faker.address.countryCode(),
          address: faker.address.streetAddress(),
        )),
        CommonOneMapModel.fromSearchResultModel(OneMapSearchResult(
          searchValue: faker.address.streetName(),
          postalCode: faker.address.zipCode(),
          longitudeString: faker.address.buildingNumber(),
          latitudeString: faker.address.countryCode(),
          address: faker.address.streetAddress(),
        ))
      ];
      search = OneMapSearch(results);
      searchTwo = OneMapSearch([
        CommonOneMapModel.fromSearchResultModel(OneMapSearchResult(
          searchValue: faker.address.streetName(),
          postalCode: faker.address.zipCode(),
          longitudeString: faker.address.buildingNumber(),
          latitudeString: faker.address.countryCode(),
          address: faker.address.streetAddress(),
        ))
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
        bloc.add(SearchValueChanged('any'));
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
        bloc.add(SearchValueChanged('any'));
        await Future.delayed(const Duration(milliseconds: 500));
        bloc.add(SearchValueChanged('any 2'));
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
        bloc.add(SearchValueChanged('any'));
        await Future.delayed(const Duration(milliseconds: 100));
        bloc.add(SearchValueChanged('any 2'));
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
        bloc.add(SearchStopped());
      },
      skip: 0,
      wait: const Duration(milliseconds: 500),
      expect: [SearchEmpty(), SearchStarting(), SearchEmpty()],
    );

    blocTest<SearchBloc, SearchEvent, SearchState>(
      'emits [] when user clicks on a list tile',
      build: null,
      act: null,
      expect: null,
    );
  });
}
