import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sgcovidmapper/blocs/log/log.dart';
import 'package:sgcovidmapper/models/hive/visit.dart';
import 'package:sgcovidmapper/widgets/log/bottom_panel_button.dart';

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
        BottomPanelButton(
          text: 'Confirm',
          color: Colors.teal,
          onTap: () =>
              BlocProvider.of<LogBloc>(context).add(OnDeleteConfirmed(visit)),
        ),
        Divider(),
        BottomPanelButton(
          text: 'Cancel',
          color: Colors.amber,
          onTap: () =>
              BlocProvider.of<LogBloc>(context).add(OnCancelButtonPressed()),
        ),
      ],
    );
  }
}
