import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sgcovidmapper/blocs/initialization/initialization.dart';
import 'package:sgcovidmapper/blocs/simple_bloc_delegate.dart';
import 'package:sgcovidmapper/models/hive/tag.dart';
import 'package:sgcovidmapper/models/hive/visit.dart';
import 'package:sgcovidmapper/util/config.dart';

class InitializationBloc
    extends Bloc<InitializationEvent, InitializationState> {
  @override
  InitializationState get initialState => Initializing();

  @override
  Stream<InitializationState> mapEventToState(
      InitializationEvent event) async* {
    if (event is BeginInitialization) {
      WidgetsFlutterBinding.ensureInitialized();
      BlocSupervisor.delegate = SimpleBlocDelegate();
      await Config.loadConfig();
      await _initHive();
      AuthResult result = await FirebaseAuth.instance.signInAnonymously();
      if (result != null) print('Sign In Successfully');
      yield InitializationComplete();
    }
  }

  Future<void> _initHive() async {
    await Hive.initFlutter();
    await Hive.openBox<Visit>('myVisits');
    Hive.registerAdapter(VisitAdapter());
    Hive.registerAdapter(TagAdapter());
  }
}
