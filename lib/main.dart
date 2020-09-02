import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sgcovidmapper/blocs/bottom_panel/bottom_panel_bloc.dart';
import 'package:sgcovidmapper/blocs/check_panel/check_panel.dart';
import 'package:sgcovidmapper/blocs/initialization/initialization.dart';
import 'package:sgcovidmapper/blocs/initialization/initialization_bloc.dart';
import 'package:sgcovidmapper/blocs/keyboard_visibility/keyboard_visibility.dart';
import 'package:sgcovidmapper/blocs/log/log.dart';
import 'package:sgcovidmapper/blocs/map/map.dart';
import 'package:sgcovidmapper/blocs/reverse_geocode/reverse_geocode.dart';
import 'package:sgcovidmapper/blocs/search/search.dart';
import 'package:sgcovidmapper/blocs/search_text_field/search_text_field.dart';
import 'package:sgcovidmapper/blocs/timeline/timeline_bloc.dart';
import 'package:sgcovidmapper/blocs/warning/warning.dart';
import 'package:sgcovidmapper/repositories/GeolocationRepository.dart';
import 'package:sgcovidmapper/repositories/covid_places_repository.dart';
import 'package:sgcovidmapper/repositories/firestore_covid_places_repository.dart';
import 'package:sgcovidmapper/repositories/gps_repository.dart';
import 'package:sgcovidmapper/repositories/my_visited_place_repository.dart';
import 'package:sgcovidmapper/screens/map_screen.dart';
import 'package:sgcovidmapper/screens/splash_screen.dart';
import 'package:sgcovidmapper/services/hive_service.dart';
import 'package:sgcovidmapper/services/one_map_api_service.dart';
import 'package:sgcovidmapper/util/constants.dart';
import 'package:showcaseview/showcase_widget.dart';

import 'blocs/update_opacity/update_opacity.dart';

void main() async {
  runApp(
    BlocProvider<InitializationBloc>(
      create: (BuildContext context) => InitializationBloc(),
      child: MyApp(),
    ),
  );
}

//BlocBuilder<InitializationBloc, InitializationState>(
//builder: (context, state) => state is InitializationComplete
//? MapScreen()
//    : SplashScreen()))
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    HiveService hiveService = HiveService();
    return BlocBuilder<InitializationBloc, InitializationState>(
      builder: (BuildContext context, InitializationState state) => state
              is InitializationComplete
          ? MultiRepositoryProvider(
              providers: [
                  RepositoryProvider<CovidPlacesRepository>(
                    create: (BuildContext context) =>
                        FirestoreCovidPlacesRepository(
                      locationCollection:
                          Firestore.instance.collection('all_locations'),
                      systemCollection: Firestore.instance.collection('system'),
                    ),
                  ),
                  RepositoryProvider<GpsRepository>(
                    create: (BuildContext context) => GpsRepository(),
                  ),
                  RepositoryProvider<GeolocationRepository>(
                    create: (BuildContext context) => GeolocationRepository(
                        OneMapApiService(Dio()), hiveService),
                  ),
                  RepositoryProvider<MyVisitedPlaceRepository>(
                    create: (BuildContext context) =>
                        MyVisitedPlaceRepository(hiveService),
                  ),
                ],
              child: MultiBlocProvider(
                providers: [
                  BlocProvider<MapBloc>(
                      create: (BuildContext context) => MapBloc(
                            covidPlacesRepository:
                                RepositoryProvider.of<CovidPlacesRepository>(
                                    context),
                            gpsRepository:
                                RepositoryProvider.of<GpsRepository>(context),
                          )),
                  BlocProvider<ReverseGeocodeBloc>(
                    create: (BuildContext context) => ReverseGeocodeBloc(
                      repository:
                          RepositoryProvider.of<GeolocationRepository>(context),
                      mapBloc: BlocProvider.of<MapBloc>(context),
                    ),
                  ),
                  BlocProvider<CheckPanelBloc>(
                    create: (BuildContext context) => CheckPanelBloc(
                      repository:
                          RepositoryProvider.of<MyVisitedPlaceRepository>(
                              context),
                    ),
                  ),
                  BlocProvider<WarningBloc>(
                    lazy: false,
                    create: (BuildContext context) => WarningBloc(
                        visitsRepository:
                            RepositoryProvider.of<MyVisitedPlaceRepository>(
                                context),
                        covidRepository:
                            RepositoryProvider.of<CovidPlacesRepository>(
                                context),
                        checkPanelBloc:
                            BlocProvider.of<CheckPanelBloc>(context)),
                  ),
                  BlocProvider<SearchBloc>(
                    create: (BuildContext context) => SearchBloc(
                        RepositoryProvider.of<GeolocationRepository>(context)),
                  ),
                  BlocProvider<TimelineBloc>(
                    create: (BuildContext context) => TimelineBloc(
                        visitsRepository:
                            RepositoryProvider.of<MyVisitedPlaceRepository>(
                                context),
                        covidRepository:
                            RepositoryProvider.of<CovidPlacesRepository>(
                                context)),
                  ),
                  BlocProvider<BottomPanelBloc>(
                    create: (BuildContext context) => BottomPanelBloc(
                        BlocProvider.of<ReverseGeocodeBloc>(context)),
                  ),
                  BlocProvider<UpdateOpacityBloc>(
                      create: (BuildContext context) => UpdateOpacityBloc(
                          BlocProvider.of<BottomPanelBloc>(context))),
                  BlocProvider<KeyboardVisibilityBloc>(
                    create: (BuildContext context) => KeyboardVisibilityBloc(),
                  ),
                  BlocProvider<SearchTextFieldBloc>(
                    create: (BuildContext context) => SearchTextFieldBloc(),
                  ),
                  BlocProvider<LogBloc>(
                    create: (BuildContext context) => LogBloc(
                        RepositoryProvider.of<MyVisitedPlaceRepository>(
                            context),
                        RepositoryProvider.of<CovidPlacesRepository>(context)),
                  ),
                ],
                child: MaterialApp(
                  title: 'Flutter Demo',
                  theme: ThemeData(
                    // This is the theme of your application.
                    //
                    // Try running your application with "flutter run". You'll see the
                    // application has a blue toolbar. Then, without quitting the app, try
                    // changing the primarySwatch below to Colors.green and then invoke
                    // "hot reload" (press "r" in the console where you ran "flutter run",
                    // or simply save your changes to "hot reload" in a Flutter IDE).
                    // Notice that the counter didn't reset back to zero; the application
                    // is not restarted.
                    primarySwatch: AppColors.kColorPrimary,
                    accentColor: AppColors.kColorAccent,
                    // This makes the visual density adapt to the platform that you run
                    // the app on. For desktop platforms, the controls will be smaller and
                    // closer together (more dense) than on mobile platforms.
                    visualDensity: VisualDensity.adaptivePlatformDensity,
                    fontFamily: 'BalooChettan2',
                  ),
                  home: ShowCaseWidget(
                    builder: Builder(
                      builder: (context) => MapScreen(),
                    ),
                  ),
                ),
              ))
          : SplashScreen(),
    );
  }
}
