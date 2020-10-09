import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sgcovidmapper/blocs/log/log.dart';
import 'package:sgcovidmapper/models/hive/visit.dart';
import 'package:sgcovidmapper/util/constants.dart';
import 'package:sgcovidmapper/widgets/check/check_panel_date_time_picker.dart';
import 'package:sgcovidmapper/widgets/log/bottom_panel_button.dart';

class CheckOutPanel extends StatelessWidget {
  final Visit visit;
  CheckOutPanel(this.visit);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          CheckPanelDateTimePicker(
            onChange: (dateTime, selectedIndex) =>
                visit.checkOutTime = dateTime,
            initialDateTime: DateTime.now(),
          ),
          Column(
            children: <Widget>[
              BottomPanelButton(
                text: 'Confirm',
                color: AppColors.kColorGreen,
                onTap: () => BlocProvider.of<LogBloc>(context)
                    .add(OnVisitUpdated(visit)),
              ),
              Divider(),
              BottomPanelButton(
                text: 'Cancel',
                color: AppColors.kColorRed,
                onTap: () => BlocProvider.of<LogBloc>(context)
                    .add(OnCancelButtonPressed()),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
