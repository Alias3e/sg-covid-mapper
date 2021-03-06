import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sgcovidmapper/blocs/log/log.dart';
import 'package:sgcovidmapper/models/hive/tag.dart';
import 'package:sgcovidmapper/models/hive/visit.dart';
import 'package:sgcovidmapper/util/constants.dart';
import 'package:sgcovidmapper/widgets/check/check.dart';
import 'package:sgcovidmapper/widgets/dialog/dialog.dart';
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
  List<Tag> initialTags = [];
  List<String> originalTagLabel = [];

  @override
  void initState() {
    key = GlobalKey();
    height = 0.0;
    super.initState();

    initialCheckInTime = widget.visit.checkInTime;
    initialCheckOutTime = widget.visit.checkOutTime;
    widget.visit.tags.forEach((tag) => originalTagLabel.add(tag.label));
    initialTags.addAll(widget.visit.tags);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _undoChanges();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Edit'),
        ),
        backgroundColor: Theme.of(context).primaryColorLight,
        body: Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fill(
              child: Hero(
                tag: 'container ${widget.visit.key}',
                child: Container(
                  color: Theme.of(context).primaryColorLight,
                ),
              ),
            ),
            Positioned.fill(
              child: Center(
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.only(top: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            children: [
                              SizedBox(height: 16.0),
                              Container(
                                width: double.infinity,
                                child: Hero(
                                  tag: 'title ${widget.visit.key}',
                                  child: Material(
                                    color: Colors.transparent,
                                    child: Text(
                                      widget.visit.title,
                                      maxLines: 2,
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 24,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ),
                                ),
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
                                    BlocProvider.of<LogBloc>(context).add(
                                        OnCheckInDateTimeSpinnerChanged(
                                            dateTime)),
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
                                      duration: Duration(
                                          milliseconds: kAnimationDuration),
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
                                    duration: Duration(
                                        milliseconds: kAnimationDuration),
                                    transitionBuilder: (child, animation) =>
                                        FadeTransition(
                                      child: child,
                                      opacity: animation,
                                    ),
                                    layoutBuilder:
                                        (currentChild, previousChildren) =>
                                            currentChild,
                                    child: makeCheckOutWidget(widget.visit),
                                  );
                                },
                              ),
                              AnimatedSize(
                                  vsync: this,
                                  duration: Duration(
                                      milliseconds: kAnimationDuration),
                                  child: BlocBuilder<LogBloc, LogState>(
                                    condition: (previous, current) =>
                                        current is TagsUpdated,
                                    builder: (context, state) => TagsWidget(
                                      hasInitialTags:
                                          widget.visit.tags.length > 0,
                                      onTagAdd: (tag) {
                                        widget.visit.tags.add(tag);
                                        BlocProvider.of<LogBloc>(context)
                                            .add(OnTagAdded(tag));
                                      },
                                      chipsBox: Wrap(
                                        children: widget.visit.getChips(
                                            onChipTap: (Tag tag) async {
                                          String editedTag =
                                              await Navigator.of(context).push(
                                            PageRouteBuilder(
                                              opaque: false,
                                              barrierColor:
                                                  Colors.black.withOpacity(0.5),
                                              barrierDismissible: true,
                                              pageBuilder:
                                                  (BuildContext context, _,
                                                      __) {
                                                return EditTagDialog(
                                                    tag: tag.label);
                                              },
                                            ),
                                          );
                                          if (editedTag != null) {
                                            tag.label = editedTag;
                                            BlocProvider.of<LogBloc>(context)
                                                .add(OnTagEdited(tag));
                                          }
                                        }, onDeleted: (Tag tag) {
                                          widget.visit.tags.remove(tag);
                                          BlocProvider.of<LogBloc>(context).add(
                                              OnTagDeleteButtonPressed(tag));
                                        }),
                                        spacing: 4.0,
                                        runSpacing: -8.0,
                                      ),
                                    ),
                                  )),
                              SizedBox(height: 64.0),
                            ],
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            BottomPanelButton(
                                text: 'Confirm',
                                color: AppColors.kColorGreen,
                                onTap: () {
                                  BlocProvider.of<LogBloc>(context)
                                      .add(OnVisitUpdated(widget.visit));
                                  Navigator.pop(context);
                                }),
                            Divider(),
                            BottomPanelButton(
                              text: 'Cancel',
                              color: AppColors.kColorRed,
                              onTap: () {
                                _undoChanges();
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 16,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _undoChanges() {
    print('undoing');
    widget.visit.checkInTime = initialCheckInTime;
    widget.visit.checkOutTime = initialCheckOutTime;
    widget.visit.tags = initialTags;
    for (int i = 0; i < widget.visit.tags.length; i++) {
      widget.visit.tags[i].label = originalTagLabel[i];
    }
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
