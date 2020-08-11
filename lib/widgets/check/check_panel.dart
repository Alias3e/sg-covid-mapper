import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sgcovidmapper/blocs/bottom_panel/bottom_panel.dart';
import 'package:sgcovidmapper/blocs/check_panel/check_panel.dart';
import 'package:sgcovidmapper/blocs/update_opacity/update_opacity.dart';
import 'package:sgcovidmapper/models/one_map/common_one_map_model.dart';
import 'package:sgcovidmapper/util/constants.dart';

import 'check.dart';
import 'check_panel_button.dart';

class CheckPanel extends StatefulWidget {
  @override
  _CheckPanelState createState() => _CheckPanelState();
}

class _CheckPanelState extends State<CheckPanel> with TickerProviderStateMixin {
  GlobalKey key;
  double height;
  CommonOneMapModel location;

  @override
  void initState() {
    key = GlobalKey();
    height = 0.0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: <Widget>[
                SizedBox(height: 16.0),
                BlocConsumer<CheckPanelBloc, CheckPanelState>(
                  listenWhen: (previous, current) =>
                      current is CheckPanelLoaded,
                  listener: (BuildContext context, CheckPanelState state) {
                    // Safe cast because of listenWhen.
                    location = (state as CheckPanelLoaded).data?.location;
                  },
                  buildWhen: (previous, current) => current is CheckPanelLoaded,
                  builder: (context, CheckPanelState state) {
                    String title = state is CheckPanelLoaded
                        ? state.data.location.title
                        : '';
                    return Text(
                      title,
                      style: Styles.kTitleTextStyle,
                    );
                  },
                ),
                BlocBuilder<CheckPanelBloc, CheckPanelState>(
                    condition: (previous, current) =>
                        current is CheckInDateTimeTextRefreshed,
                    builder: (context, state) {
                      DateTime dateTime = DateTime.now();
                      state is CheckInDateTimeTextRefreshed
                          ? dateTime = state.dateTime
                          : DateTime.now();
                      return Text(
                        'Check in : ${Styles.kStartDateFormat.format(dateTime)}',
                        key: key,
                        style: Styles.kDetailsTextStyle,
                      );
                    }),
                SizedBox(height: 20),
                CheckPanelDateTimePicker(
                  onChange: (dateTime, selectedIndex) =>
                      BlocProvider.of<CheckPanelBloc>(context)
                          .add(CheckInDateTimeUpdated(dateTime)),
                ),
                SizedBox(height: 16),
                BlocConsumer<CheckPanelBloc, CheckPanelState>(
                  listenWhen: (previous, current) =>
                      current is CheckOutDateTimeWidgetLoaded,
                  listener: (BuildContext context, CheckPanelState state) {
                    final RenderBox renderBox =
                        key.currentContext.findRenderObject();
                    height = renderBox.size.height;
                  },
                  buildWhen: (previous, current) =>
                      current is CheckOutDateTimeTextRefreshed ||
                      current is CheckOutDateTimeWidgetLoaded,
                  builder: (BuildContext context, CheckPanelState state) {
                    DateTime dateTime = DateTime.now();
                    if (state is CheckOutDateTimeTextRefreshed)
                      dateTime = state.dateTime;
                    return AnimatedSize(
                      vsync: this,
                      duration: Duration(milliseconds: 200),
                      child: Container(
                        height: height,
                        child: Text(
                          'Check out : ${Styles.kStartDateFormat.format(dateTime)}',
                          style: Styles.kDetailsTextStyle,
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 16),
                BlocBuilder<CheckPanelBloc, CheckPanelState>(
                  condition: (previous, current) =>
                      current is CheckPanelLoaded ||
                      current is CheckOutDateTimeWidgetLoaded ||
                      current is CheckOutDateTimeUpdated,
                  builder: (BuildContext context, CheckPanelState state) {
                    return AnimatedSwitcher(
                      duration: Duration(milliseconds: 200),
                      transitionBuilder: (child, animation) => FadeTransition(
                        child: child,
                        opacity: animation,
                      ),
                      layoutBuilder: (currentChild, previousChildren) =>
                          currentChild,
                      child: state is CheckPanelLoaded
                          ? Column(
                              children: <Widget>[
                                CheckPanelButton(
                                  text: 'Check out',
                                  color: Colors.amber,
                                  onPressed: () =>
                                      BlocProvider.of<CheckPanelBloc>(context)
                                          .add(CheckOutDateTimeDisplayed()),
                                  icon: FontAwesomeIcons.signOutAlt,
                                ),
                                Text(
                                  'check out is optional',
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontStyle: FontStyle.italic),
                                ),
                              ],
                            )
                          : CheckPanelDateTimePicker(
                              onChange: (dateTime, selectedIndex) =>
                                  BlocProvider.of<CheckPanelBloc>(context)
                                      .add(CheckOutDateTimeUpdated(dateTime)),
                            ),
                    );
                  },
                ),
                AnimatedSize(
                    vsync: this,
                    duration: Duration(milliseconds: 250),
                    child: TagsWidget()),
                SizedBox(height: 24.0),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CheckPanelButton(
                onPressed: () {
                  BlocProvider.of<BottomPanelBloc>(context)
                      .add(SearchPanelSwitched());
                  BlocProvider.of<UpdateOpacityBloc>(context)
                      .add(SearchBoxOpacityChanged(0));
                  BlocProvider.of<CheckPanelBloc>(context).add(SaveVisit());
                },
                text: 'Done',
                color: Colors.teal,
                icon: FontAwesomeIcons.check,
              ),
              SizedBox(
                width: 16.0,
              ),
              CheckPanelButton(
                onPressed: () {
                  BlocProvider.of<BottomPanelBloc>(context)
                      .add(SearchPanelSwitched());
                  BlocProvider.of<UpdateOpacityBloc>(context)
                      .add(SearchBoxOpacityChanged(0));
                  BlocProvider.of<CheckPanelBloc>(context).add(CancelVisit());
                },
                text: 'Cancel',
                color: Colors.redAccent,
                icon: FontAwesomeIcons.times,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
