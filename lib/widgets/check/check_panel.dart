import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sgcovidmapper/blocs/bottom_panel/bottom_panel.dart';
import 'package:sgcovidmapper/blocs/check_panel/check_panel.dart';
import 'package:sgcovidmapper/models/one_map/common_one_map_model.dart';
import 'package:sgcovidmapper/util/constants.dart';
import 'package:sgcovidmapper/widgets/showcase_container.dart';
import 'package:showcaseview/showcase.dart';
import 'package:showcaseview/showcase_widget.dart';

import 'check.dart';
import 'check_panel_button.dart';

class CheckPanel extends StatefulWidget {
  final BottomPanelEvent switchOutEvent;

  const CheckPanel({@required this.switchOutEvent});
  @override
  _CheckPanelState createState() => _CheckPanelState();
}

class _CheckPanelState extends State<CheckPanel> with TickerProviderStateMixin {
  GlobalKey key;
  GlobalKey titleKey;
  GlobalKey tagKey;
  GlobalKey checkoutKey;
  double height;
  CommonOneMapModel location;

  @override
  void initState() {
    key = GlobalKey();
    titleKey = GlobalKey();
    tagKey = GlobalKey();
    checkoutKey = GlobalKey();
    height = 0.0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 58),
            child: SingleChildScrollView(
              reverse: true,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 16.0),
                    Showcase.withWidget(
                      key: titleKey,
                      height: 80,
                      width: 300,
                      container: ShowcaseContainer(
                        height: 85,
                        width: 379.5,
                        child: Container(
                          color: Theme.of(context).primaryColor,
                          child: Text(
                            'Places you visited will be matched against public places visited '
                            'by COVID19 cases using postal code. '
                            'Please verify the postal code before checking in',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      child: BlocConsumer<CheckPanelBloc, CheckPanelState>(
                        listenWhen: (previous, current) =>
                            current is CheckPanelLoaded,
                        listener:
                            (BuildContext context, CheckPanelState state) {
                          // Safe cast because of listenWhen.
                          location = (state as CheckPanelLoaded).data?.location;
                        },
                        buildWhen: (previous, current) =>
                            current is CheckPanelLoaded,
                        builder: (context, CheckPanelState state) {
                          String title = state is CheckPanelLoaded
                              ? '${state.data.location.title} ( ${state.data.location.postalCode})'
                              : '';
                          return Text(
                            title,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          );
                        },
                      ),
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
                      initialDateTime: DateTime.now(),
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
                    Showcase.withWidget(
                      key: checkoutKey,
                      width: 300,
                      height: 80,
                      container: ShowcaseContainer(
                        width: 379.5,
                        height: 80,
                        child: Text(
                          'You can check out later from the visited places log',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                      child: BlocBuilder<CheckPanelBloc, CheckPanelState>(
                        condition: (previous, current) =>
                            current is CheckPanelLoaded ||
                            current is CheckOutDateTimeWidgetLoaded ||
                            current is CheckOutDateTimeUpdated,
                        builder: (BuildContext context, CheckPanelState state) {
                          return AnimatedSwitcher(
                            duration: Duration(milliseconds: 200),
                            transitionBuilder: (child, animation) =>
                                FadeTransition(
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
                                        color: Theme.of(context).accentColor,
                                        onPressed: () => BlocProvider.of<
                                                CheckPanelBloc>(context)
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
                                    initialDateTime: DateTime.now()
                                        .add(Duration(minutes: 30)),
                                    onChange: (dateTime, selectedIndex) =>
                                        BlocProvider.of<CheckPanelBloc>(context)
                                            .add(CheckOutDateTimeUpdated(
                                                dateTime)),
                                  ),
                          );
                        },
                      ),
                    ),
                    Showcase.withWidget(
                      key: tagKey,
                      height: 80,
                      width: 300,
                      shapeBorder: CircleBorder(),
                      container: ShowcaseContainer(
                        height: 80,
                        width: 379.5,
                        child: Text(
                          'Add tags to your visits to provide additional details and contacts.'
                          ' For example, if visiting a mall, specify a specific shop within.'
                          ' Or tag your family members who was with you.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      child: AnimatedSize(
                          vsync: this,
                          duration: Duration(milliseconds: 250),
                          child: TagsWidget(
                            hasInitialTags: false,
                            onTagAdd: (tag) =>
                                BlocProvider.of<CheckPanelBloc>(context)
                                    .add(AddTag(tag: tag)),
                            chipsBox:
                                BlocBuilder<CheckPanelBloc, CheckPanelState>(
                              condition: (previous, current) =>
                                  current is TagListUpdated,
                              builder: (BuildContext context, state) {
                                return Wrap(
                                  children:
                                      state is TagListUpdated ? state.tags : [],
                                  spacing: 4.0,
                                  runSpacing: -8.0,
                                );
                              },
                            ),
                          )),
                    ),
                    SizedBox(height: 24.0),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 8,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CheckPanelButton(
                  onPressed: () {
                    BlocProvider.of<BottomPanelBloc>(context)
                        .add(widget.switchOutEvent);
//                  BlocProvider.of<UpdateOpacityBloc>(context)
//                      .add(SearchBoxOpacityChanged(0));
                    BlocProvider.of<CheckPanelBloc>(context).add(SaveVisit());
                  },
                  text: 'Done',
                  color: AppColors.kColorGreen,
                  icon: FontAwesomeIcons.check,
                ),
                SizedBox(
                  width: 16.0,
                ),
                CheckPanelButton(
                  onPressed: () {
                    BlocProvider.of<BottomPanelBloc>(context)
                        .add(widget.switchOutEvent);
//                  BlocProvider.of<UpdateOpacityBloc>(context)
//                      .add(SearchBoxOpacityChanged(0));
                    BlocProvider.of<CheckPanelBloc>(context).add(CancelVisit());
                  },
                  text: 'Cancel',
                  color: AppColors.kColorRed,
                  icon: FontAwesomeIcons.times,
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            left: 24,
            child: GestureDetector(
              onTap: () {
                ShowCaseWidget.of(context)
                    .startShowCase([titleKey, checkoutKey, tagKey]);
              },
              child: Icon(
                Icons.info_outline,
                color: Theme.of(context).accentColor,
              ),
            ),
          )
        ],
      ),
    );
  }
}
