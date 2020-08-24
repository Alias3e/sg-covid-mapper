import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sgcovidmapper/blocs/log/log.dart';
import 'package:sgcovidmapper/models/hive/visit.dart';

class DeleteConfirmationPanel extends StatelessWidget {
  final Visit visit;

  const DeleteConfirmationPanel({this.visit});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          'Delete this visit?',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Divider(),
        ),
        GestureDetector(
          onTap: () =>
              BlocProvider.of<LogBloc>(context).add(OnDeleteConfirmed(visit)),
          child: Text(
            'Confirm',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.teal,
              fontSize: 24,
            ),
          ),
        ),
        Divider(),
        GestureDetector(
          onTap: () =>
              BlocProvider.of<LogBloc>(context).add(OnDeleteCancelled()),
          child: Text(
            'Cancel',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.amber, fontSize: 24),
          ),
        ),
      ],
    );
  }
}
