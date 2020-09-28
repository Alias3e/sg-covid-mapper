import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sgcovidmapper/blocs/data_information/data_information.dart';
import 'package:sgcovidmapper/services/firestore_service.dart';
import 'package:sgcovidmapper/services/remote_database_service.dart';
import 'package:sgcovidmapper/util/constants.dart';

class DataInformationBloc
    extends Bloc<DataInformationEvent, DataInformationState> {
  final RemoteDatabaseService _service;

  DataInformationBloc(this._service) : assert(_service != null) {
    (_service as FirestoreService).systems.listen((snapshot) {
      Map<String, dynamic> data = {};
      data['version'] = snapshot.data()['current_version'];
      data['updated'] = Styles.kUpdatedDateFormat
          .format((snapshot.data()['updated'] as Timestamp).toDate());
      data['source'] = snapshot.data()['source'];
      add(OnDataInformationUpdated(data: data));
    });
  }

  @override
  DataInformationState get initialState => AwaitingData();

  @override
  Stream<DataInformationState> mapEventToState(
      DataInformationEvent event) async* {
    if (event is OnDataInformationUpdated)
      yield DataInformationUpdated(event.data);
  }
}
