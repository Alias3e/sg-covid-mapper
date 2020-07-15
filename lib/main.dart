import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sgcovidmapper/blocs/blocs.dart';
import 'package:sgcovidmapper/blocs/bottom_panel/bottom_panel_bloc.dart';
import 'package:sgcovidmapper/blocs/simple_bloc_delegate.dart';
import 'package:sgcovidmapper/repositories/GeolocationRepository.dart';
import 'package:sgcovidmapper/repositories/firestore_visited_place_repository.dart';
import 'package:sgcovidmapper/repositories/gps_repository.dart';
import 'package:sgcovidmapper/repositories/visited_place_repository.dart';
import 'package:sgcovidmapper/screens/map_screen.dart';
import 'package:sgcovidmapper/services/one_map_api_service.dart';
import 'package:sgcovidmapper/util/config.dart';

void main() async {
  await init();
  runApp(MyApp());
}

Future<void> init() async {
  WidgetsFlutterBinding.ensureInitialized();
  BlocSupervisor.delegate = SimpleBlocDelegate();
  await Config.loadConfig();
  await Hive.initFlutter();
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<VisitedPlaceRepository>(
          create: (BuildContext context) => FirestoreVisitedPlaceRepository(
            locationCollection: Firestore.instance.collection('all_locations'),
            systemCollection: Firestore.instance.collection('system'),
          ),
        ),
        RepositoryProvider<GpsRepository>(
          create: (BuildContext context) => GpsRepository(),
        ),
        RepositoryProvider<GeolocationRepository>(
          create: (BuildContext context) =>
              GeolocationRepository(OneMapApiService(Dio())),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<SearchBloc>(
            create: (BuildContext context) => SearchBloc(
                RepositoryProvider.of<GeolocationRepository>(context)),
          ),
          BlocProvider<MapBloc>(
              create: (BuildContext context) => MapBloc(
                    visitedPlaceRepository:
                        RepositoryProvider.of<VisitedPlaceRepository>(context),
                    gpsRepository:
                        RepositoryProvider.of<GpsRepository>(context),
                  )),
          BlocProvider<BottomPanelBloc>(
            create: (BuildContext context) => BottomPanelBloc(),
          ),
          BlocProvider<SearchBoxBloc>(
              create: (BuildContext context) =>
                  SearchBoxBloc(BlocProvider.of<BottomPanelBloc>(context))),
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
            primarySwatch: Colors.teal,
            // This makes the visual density adapt to the platform that you run
            // the app on. For desktop platforms, the controls will be smaller and
            // closer together (more dense) than on mobile platforms.
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: MapScreen(),
        ),
      ),
    );
  }
}
