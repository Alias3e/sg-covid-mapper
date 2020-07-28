import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sgcovidmapper/blocs/blocs.dart';
import 'package:sgcovidmapper/blocs/initialization/initialization_event.dart';
import 'package:sgcovidmapper/blocs/initialization/initialization_state.dart';
import 'package:sgcovidmapper/util/config.dart';

class InitializationBloc
    extends Bloc<InitializationEvent, InitializationState> {
  @override
  // TODO: implement initialState
  InitializationState get initialState => Initializing();

  @override
  Stream<InitializationState> mapEventToState(
      InitializationEvent event) async* {
    if (event is BeginInitialization) {
      WidgetsFlutterBinding.ensureInitialized();
      BlocSupervisor.delegate = SimpleBlocDelegate();
      await Config.loadConfig();
      await Hive.initFlutter();
      AuthResult result = await FirebaseAuth.instance.signInAnonymously();
      if (result != null) print('Sign In Successfully');
      yield InitializationComplete();
    }
  }
}
