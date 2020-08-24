import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sgcovidmapper/blocs/log/log.dart';
import 'package:sgcovidmapper/widgets/log/delete_confirmation_panel.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class LogScreenSlidingUpPanel extends StatefulWidget {
  final Widget body;

  const LogScreenSlidingUpPanel({this.body});

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
        if (state is DeleteConfirmationPanelShowing) {
          _panelController.animatePanelToPosition(
            1.0,
            duration: Duration(milliseconds: 150),
            curve: Curves.linear,
          );
        }

        if (state is PanelClosing || state is VisitDeleteCompleted) {
          _panelController.animatePanelToPosition(
            0.0,
            duration: Duration(milliseconds: 150),
            curve: Curves.linear,
          );
        }
      },
      builder: (BuildContext context, state) => SlidingUpPanel(
        minHeight: 0,
        maxHeight: state is LogPanelState
            ? MediaQuery.of(context).size.height * state.maxHeight
            : 0,
        backdropTapClosesPanel: false,
        body: widget.body,
        controller: _panelController,
        panelBuilder: (sc) {
          if (state is DeleteConfirmationPanelShowing) {
            return DeleteConfirmationPanel(
              visit: state.visit,
            );
          }
          return Container();
        },
      ),
    );
  }
}
