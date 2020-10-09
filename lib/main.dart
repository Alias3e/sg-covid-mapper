import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sgcovidmapper/blocs/data_information/data_information.dart';
import 'package:sgcovidmapper/blocs/gps/gps.dart';
import 'package:sgcovidmapper/blocs/initialization/initialization.dart';
import 'package:sgcovidmapper/blocs/initialization/initialization_bloc.dart';
import 'package:sgcovidmapper/blocs/map/map_bloc.dart';
import 'package:sgcovidmapper/blocs/search/search.dart';
import 'package:sgcovidmapper/repositories/GeolocationRepository.dart';
import 'package:sgcovidmapper/repositories/covid_places_repository.dart';
import 'package:sgcovidmapper/repositories/firestore_covid_places_repository.dart';
import 'package:sgcovidmapper/repositories/gps_repository.dart';
import 'package:sgcovidmapper/repositories/my_visited_place_repository.dart';
import 'package:sgcovidmapper/screens/map_screen.dart';
import 'package:sgcovidmapper/screens/splash_screen.dart';
import 'package:sgcovidmapper/services/firestore_service.dart';
import 'package:sgcovidmapper/services/hive_service.dart';
import 'package:sgcovidmapper/services/one_map_api_service.dart';
import 'package:sgcovidmapper/services/remote_database_service.dart';
import 'package:sgcovidmapper/util/constants.dart';
import 'package:showcaseview/showcaseview.dart';

import 'blocs/bottom_panel/bottom_panel.dart';
import 'blocs/check_panel/check_panel.dart';
import 'blocs/keyboard_visibility/keyboard_visibility.dart';
import 'blocs/log/log.dart';
import 'blocs/reverse_geocode/reverse_geocode.dart';
import 'blocs/search_text_field/search_text_field.dart';
import 'blocs/timeline/timeline.dart';
import 'blocs/update_opacity/update_opacity.dart';
import 'blocs/warning/warning.dart';

void main() async {
  HiveService hiveService = HiveService();
  FirestoreService firestoreService = FirestoreService();
  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<CovidPlacesRepository>(
          create: (BuildContext context) => FirestoreCovidPlacesRepository(
            remoteDatabaseService: firestoreService,
          ),
        ),
        RepositoryProvider<GpsRepository>(
          create: (BuildContext context) => GpsRepository(),
        ),
        RepositoryProvider<GeolocationRepository>(
          create: (BuildContext context) =>
              GeolocationRepository(OneMapApiService(Dio()), firestoreService),
        ),
        RepositoryProvider<MyVisitedPlaceRepository>(
          create: (BuildContext context) =>
              MyVisitedPlaceRepository(hiveService),
        ),
      ],
      child: MyApp(
        remoteDatabaseService: firestoreService,
      ),
    ),
  );
}

//BlocBuilder<InitializationBloc, InitializationState>(
//builder: (context, state) => state is InitializationComplete
//? MapScreen()
//    : SplashScreen()))
class MyApp extends StatelessWidget {
  final RemoteDatabaseService remoteDatabaseService;

  const MyApp({@required this.remoteDatabaseService});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>
          InitializationBloc(remoteDatabaseService),
      child: MultiBlocProvider(
        providers: [
          BlocProvider<GpsBloc>(
            create: (context) =>
                GpsBloc(RepositoryProvider.of<GpsRepository>(context)),
          ),
          BlocProvider<ReverseGeocodeBloc>(
            create: (BuildContext context) => ReverseGeocodeBloc(
              repository: RepositoryProvider.of<GeolocationRepository>(context),
              gpsBloc: BlocProvider.of<GpsBloc>(context),
            ),
          ),
          BlocProvider<MapBloc>(
              create: (BuildContext context) => MapBloc(
                    gpsBloc: BlocProvider.of<GpsBloc>(context),
                    covidPlacesRepository:
                        RepositoryProvider.of<CovidPlacesRepository>(context),
                    reverseGeocodeBloc:
                        BlocProvider.of<ReverseGeocodeBloc>(context),
                  )),
          BlocProvider<CheckPanelBloc>(
            create: (BuildContext context) => CheckPanelBloc(
              repository:
                  RepositoryProvider.of<MyVisitedPlaceRepository>(context),
            ),
          ),
          BlocProvider<SearchBloc>(
            create: (BuildContext context) => SearchBloc(
                RepositoryProvider.of<GeolocationRepository>(context)),
          ),
          BlocProvider<TimelineBloc>(
            create: (BuildContext context) => TimelineBloc(
                visitsRepository:
                    RepositoryProvider.of<MyVisitedPlaceRepository>(context),
                covidRepository:
                    RepositoryProvider.of<CovidPlacesRepository>(context)),
          ),
          BlocProvider<BottomPanelBloc>(
            create: (BuildContext context) =>
                BottomPanelBloc(BlocProvider.of<ReverseGeocodeBloc>(context)),
          ),
          BlocProvider<UpdateOpacityBloc>(
              create: (BuildContext context) =>
                  UpdateOpacityBloc(BlocProvider.of<BottomPanelBloc>(context))),
          BlocProvider<KeyboardVisibilityBloc>(
            create: (BuildContext context) => KeyboardVisibilityBloc(),
          ),
          BlocProvider<SearchTextFieldBloc>(
            create: (BuildContext context) => SearchTextFieldBloc(),
          ),
          BlocProvider<LogBloc>(
            create: (BuildContext context) => LogBloc(
              RepositoryProvider.of<MyVisitedPlaceRepository>(context),
            ),
          ),
          BlocProvider<DataInformationBloc>(
            create: (context) => DataInformationBloc(remoteDatabaseService),
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
          initialRoute: '/',
          routes: {
            '/': (context) => SplashScreen(),
            '/map': (context) => MultiBlocProvider(
                  providers: [
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
                            BlocProvider.of<CheckPanelBloc>(context),
                        logBloc: BlocProvider.of<LogBloc>(context),
                      ),
                    ),
                  ],
                  child: ShowCaseWidget(
                    builder: Builder(
                      builder: (context) => MapScreen(),
                    ),
                  ),
                ),
          },
//                  home: ShowCaseWidget(
//                    builder: Builder(
//                      builder: (context) => MapScreen(),
//                    ),
//                  ),
        ),
      ),
    );
  }
}
