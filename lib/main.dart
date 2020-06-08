import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:sgcovidmapper/blocs/blocs.dart';
import 'package:sgcovidmapper/blocs/simple_bloc_delegate.dart';
import 'package:sgcovidmapper/repositories/firestore_visited_place_repository.dart';
import 'package:sgcovidmapper/repositories/gps_repository.dart';
import 'package:sgcovidmapper/repositories/visited_place_repository.dart';
import 'package:sgcovidmapper/screens/map_screen.dart';
import 'package:sgcovidmapper/util/config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  BlocSupervisor.delegate = SimpleBlocDelegate();
  await Config.loadConfig();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<VisitedPlaceRepository>(
          create: (BuildContext context) => FirestoreVisitedPlaceRepository(),
        ),
        RepositoryProvider<GpsRepository>(
          create: (BuildContext context) => GpsRepository(),
        ),
      ],
      child: BlocProvider<MapBloc>(
        create: (BuildContext context) => MapBloc(
          visitedPlaceRepository:
              RepositoryProvider.of<VisitedPlaceRepository>(context),
          gpsRepository: RepositoryProvider.of<GpsRepository>(context),
        ),
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
          home: MapScreen(
            mapController: MapController(),
          ),
        ),
      ),
    );
  }
}
