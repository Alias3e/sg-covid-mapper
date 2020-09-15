import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sgcovidmapper/blocs/log/log.dart';
import 'package:sgcovidmapper/models/hive/tag.dart';
import 'package:sgcovidmapper/models/hive/visit.dart';
import 'package:sgcovidmapper/util/constants.dart';
import 'package:sgcovidmapper/widgets/check/check.dart';
import 'package:sgcovidmapper/widgets/log/bottom_panel_button.dart';

class EditVisitPanel extends StatefulWidget {
  final Visit visit;
  final ScrollController scrollController;

  const EditVisitPanel({this.visit, this.scrollController});

  @override
  _EditVisitPanelState createState() => _EditVisitPanelState();
}

class _EditVisitPanelState extends State<EditVisitPanel>
    with TickerProviderStateMixin {
  GlobalKey key;
  double height;

  // Initial state
  DateTime initialCheckInTime;
  DateTime initialCheckOutTime;
  List<Tag> initialTags;

  @override
  void initState() {
    key = GlobalKey();
    height = 0.0;
    super.initState();

    initialCheckInTime = widget.visit.checkInTime;
    initialCheckOutTime = widget.visit.checkOutTime;
    initialTags = widget.visit.tags;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        controller: widget.scrollController,
        child: Container(
          padding: EdgeInsets.only(bottom: 4.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    SizedBox(height: 16.0),
                    Text(
                      widget.visit.title,
                      style: Styles.kTitleTextStyle,
                    ),
                    BlocBuilder<LogBloc, LogState>(
                      condition: (previous, current) =>
                          current is EditCheckInDateTimeUpdated,
                      builder: (context, state) {
                        if (state is EditCheckInDateTimeUpdated)
                          widget.visit.checkInTime = state.dateTime;
                        return Text(
                          'Check in : ${Styles.kStartDateFormat.format(widget.visit.checkInTime)}',
                          key: key,
                          style: Styles.kDetailsTextStyle,
                        );
                      },
                    ),
                    SizedBox(height: 20),
                    CheckPanelDateTimePicker(
                      initialDateTime: widget.visit.checkInTime,
                      onChange: (dateTime, selectedIndex) =>
                          BlocProvider.of<LogBloc>(context)
                              .add(OnCheckInDateTimeSpinnerChanged(dateTime)),
                    ),
                    SizedBox(height: 16),
                    BlocConsumer<LogBloc, LogState>(
                      listenWhen: (previous, current) =>
                          current is CheckOutPickerDisplayed,
                      listener: (context, state) {
                        final RenderBox renderBox =
                            key.currentContext.findRenderObject();
                        height = renderBox.size.height;
                      },
                      buildWhen: (previous, current) =>
                          current is CheckOutPickerDisplayed ||
                          current is EditCheckOutDateTimeUpdated,
                      builder: (context, state) {
                        if (state is CheckOutPickerDisplayed)
                          return AnimatedSize(
                            vsync: this,
                            duration:
                                Duration(milliseconds: kAnimationDuration),
                            child: Container(
                              height: height,
                              child: Text(
                                'Check out : ${Styles.kStartDateFormat.format(state.dateTime)}',
                                style: Styles.kDetailsTextStyle,
                              ),
                            ),
                          );
                        if (state is EditCheckOutDateTimeUpdated)
                          widget.visit.checkOutTime = state.dateTime;
                        return widget.visit.checkOutTime != null
                            ? Text(
                                'Check out : ${Styles.kStartDateFormat.format(widget.visit.checkOutTime)}',
                                style: Styles.kDetailsTextStyle,
                              )
                            : Container();
                      },
                    ),
                    SizedBox(height: 16),
                    BlocBuilder<LogBloc, LogState>(
                      builder: (context, state) {
                        if (state is CheckOutPickerDisplayed)
                          widget.visit.checkOutTime = state.dateTime;
                        return AnimatedSwitcher(
                          duration: Duration(milliseconds: kAnimationDuration),
                          transitionBuilder: (child, animation) =>
                              FadeTransition(
                            child: child,
                            opacity: animation,
                          ),
                          layoutBuilder: (currentChild, previousChildren) =>
                              currentChild,
                          child: makeCheckOutWidget(widget.visit),
                        );
                      },
                    ),
                    AnimatedSize(
                        vsync: this,
                        duration: Duration(milliseconds: kAnimationDuration),
                        child: BlocBuilder<LogBloc, LogState>(
                          condition: (previous, current) =>
                              current is TagsUpdated,
                          builder: (context, state) => TagsWidget(
                            hasInitialTags: widget.visit.tags.length > 0,
                            onTagAdd: (tag) {
                              widget.visit.tags.add(tag);
                              BlocProvider.of<LogBloc>(context)
                                  .add(OnTagAdded(tag));
                            },
                            chipsBox: Wrap(
                              children:
                                  widget.visit.getChips(onDeleted: (Tag tag) {
                                widget.visit.tags.remove(tag);
                                BlocProvider.of<LogBloc>(context)
                                    .add(OnTagDeleteButtonPressed(tag));
                              }),
                              spacing: 4.0,
                              runSpacing: -8.0,
                            ),
                          ),
                        )),
                    SizedBox(height: 24.0),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  BottomPanelButton(
                    text: 'Confirm',
                    color: AppColors.kColorGreen,
                    onTap: () => BlocProvider.of<LogBloc>(context)
                        .add(OnVisitUpdated(widget.visit)),
                  ),
                  Divider(),
                  BottomPanelButton(
                    text: 'Cancel',
                    color: AppColors.kColorRed,
                    onTap: () {
                      widget.visit.checkInTime = initialCheckInTime;
                      widget.visit.checkOutTime = initialCheckOutTime;
                      widget.visit.tags = initialTags;
                      BlocProvider.of<LogBloc>(context)
                          .add(OnCancelButtonPressed());
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget makeCheckOutWidget(Visit visit) {
    return visit.checkOutTime == null
        ? Column(
            children: <Widget>[
              CheckPanelButton(
                text: 'Check out',
                color: Theme.of(context).accentColor,
                onPressed: () => BlocProvider.of<LogBloc>(context)
                    .add(OnEditPanelCheckOutButtonPressed()),
                icon: FontAwesomeIcons.signOutAlt,
              ),
              Text(
                'check out is optional',
                style:
                    TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
              ),
            ],
          )
        : CheckPanelDateTimePicker(
            initialDateTime: widget.visit.checkOutTime,
            onChange: (dateTime, selectedIndex) =>
                BlocProvider.of<LogBloc>(context)
                    .add(OnCheckOutDateTimeSpinnerChanged(dateTime)),
          );
  }
}
