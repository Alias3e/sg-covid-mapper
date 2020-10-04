import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sgcovidmapper/blocs/initialization/initialization.dart';
import 'package:sgcovidmapper/blocs/simple_bloc_delegate.dart';
import 'package:sgcovidmapper/models/hive/tag.dart';
import 'package:sgcovidmapper/models/hive/visit.dart';
import 'package:sgcovidmapper/services/firestore_service.dart';
import 'package:sgcovidmapper/util/config.dart';

class InitializationBloc
    extends Bloc<InitializationEvent, InitializationState> {
  static const String visitBoxName = 'myVisits';
  static const String systemBoxName = 'system';
  final String isAppFirstOpen = 'isAppFirstOpen';
  final FirestoreService _firestoreService;

  InitializationBloc(this._firestoreService);

  @override
  InitializationState get initialState => Initializing();

  @override
  Stream<InitializationState> mapEventToState(
      InitializationEvent event) async* {
    if (event is BeginInitialization) {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp();
      UserCredential result = await FirebaseAuth.instance.signInAnonymously();
      if (result != null) print('Sign In Successfully');
      await _firestoreService.init();
      await Asset.loadConfigurations();
      BlocSupervisor.delegate = SimpleBlocDelegate();
      if (!Hive.isBoxOpen(visitBoxName)) await _initHive();
//      await _covidPlacesRepository.init();
      bool showDialog =
          Hive.box(systemBoxName).get(isAppFirstOpen, defaultValue: true);
      Map<String, dynamic> splash = {};
      if (showDialog) {
        Hive.box(systemBoxName).put(isAppFirstOpen, false);
        splash = await Asset.loadSplashDialog();
      }
      if (splash.isNotEmpty)
        yield InitializationComplete(true, dialogContent: splash);
      else
        yield InitializationComplete(false);
    }

    if (event is OnDialogChanged) yield DialogContentChange(event.nextIndex);
  }

  Future<void> _initHive() async {
    await Hive.initFlutter();
    Hive.registerAdapter(VisitAdapter());
    Hive.registerAdapter(TagAdapter());
    await Hive.openBox<Visit>('myVisits');
    await Hive.openBox('system');
  }
}
