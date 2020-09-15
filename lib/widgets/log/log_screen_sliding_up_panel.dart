import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sgcovidmapper/blocs/log/log.dart';
import 'package:sgcovidmapper/util/constants.dart';
import 'package:sgcovidmapper/widgets/log/check_out_panel.dart';
import 'package:sgcovidmapper/widgets/log/delete_confirmation_panel.dart';
import 'package:sgcovidmapper/widgets/log/edit_visit_panel.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class LogScreenSlidingUpPanel extends StatefulWidget {
  const LogScreenSlidingUpPanel();

  @override
  _LogScreenSlidingUpPanelState createState() =>
      _LogScreenSlidingUpPanelState();
}

class _LogScreenSlidingUpPanelState extends State<LogScreenSlidingUpPanel> {
  PanelController _panelController;

  @override
  void initState() {
    super.initState();
    _panelController = PanelController();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LogBloc, LogState>(
      listener: (BuildContext context, state) {
        if (state is LogPanelShowingState) {
          _panelController.animatePanelToPosition(
            1.0,
            duration: Duration(milliseconds: kAnimationDuration),
            curve: Curves.linear,
          );
        }

        if (state is LogPanelClosing) {
          _panelController.animatePanelToPosition(
            0.0,
            duration: Duration(milliseconds: kAnimationDuration),
            curve: Curves.linear,
          );
        }
      },
      buildWhen: (previous, current) => current is LogPanelState,
      builder: (BuildContext context, state) => SlidingUpPanel(
        isDraggable: false,
        color: Theme.of(context).primaryColorLight,
        minHeight: 0,
        maxHeight: state is LogPanelState
            ? MediaQuery.of(context).size.height * state.maxHeight
            : 0,
        backdropTapClosesPanel: false,
        controller: _panelController,
        panelBuilder: (sc) {
          if (state is DeleteConfirmationPanelShowing) {
            return DeleteConfirmationPanel(
              visit: state.visit,
            );
          }
          if (state is CheckOutPanelShowing) {
            return CheckOutPanel(state.visit);
          }
          if (state is EditVisitPanelShowing) {
            return EditVisitPanel(
              visit: state.visit,
              scrollController: sc,
            );
          }
          return Container();
        },
      ),
    );
  }
}
