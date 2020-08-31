import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sgcovidmapper/blocs/log/log.dart';
import 'package:sgcovidmapper/models/hive/visit.dart';
import 'package:sgcovidmapper/util/constants.dart';

class LogVisitTile extends StatelessWidget {
  final Visit visit;

  const LogVisitTile({this.visit});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      color: visit.warningLevel > 0
          ? AppColors.kColorAccentDark
          : AppColors.kColorPrimaryLight,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                DateTimeText(
                  dateTime: visit.checkInTime,
                  text: 'IN',
                  textColor: getTextColor(),
                  textColorDarker: getTextColorDarker(context),
                ),
                SizedBox(
                  width: 16.0,
                ),
                visit.checkOutTime != null
                    ? DateTimeText(
                        dateTime: visit.checkOutTime,
                        text: 'OUT',
                        textColor: getTextColor(),
                        textColorDarker: getTextColorDarker(context),
                      )
                    : IconButton(
                        icon: Icon(
                          FontAwesomeIcons.signOutAlt,
                          color: visit.warningLevel == 0
                              ? Theme.of(context).accentColor
                              : AppColors.kColorAccentDark,
                        ),
                        onPressed: () => BlocProvider.of<LogBloc>(context)
                            .add(OnCheckOutButtonPressed(visit: visit)),
                      ),
                SizedBox(
                  width: 16.0,
                ),
                Flexible(
                  child: Text(
                    visit.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: getTextColor(),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 8.0,
            ),
            Wrap(
              children: visit.getChips(),
              spacing: 4.0,
              runSpacing: -8.0,
            ),
            SizedBox(
              height: 8.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    FontAwesomeIcons.trashAlt,
                    color: getIconColor(context),
                    size: 20,
                  ),
                  onPressed: () => BlocProvider.of<LogBloc>(context)
                      .add(OnDeleteButtonPressed(visit)),
                ),
                IconButton(
                  icon: Icon(
                    FontAwesomeIcons.edit,
                    color: getIconColor(context),
                    size: 20,
                  ),
                  onPressed: () => BlocProvider.of<LogBloc>(context)
                      .add(OnEditButtonPressed(visit)),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Color getIconColor(BuildContext context) => visit.warningLevel == 0
      ? Theme.of(context).accentColor
      : Theme.of(context).primaryColor;

  Color getTextColor() =>
      visit.warningLevel == 0 ? Colors.black : AppColors.kColorAccent[50];

  Color getTextColorDarker(BuildContext context) => visit.warningLevel == 0
      ? Theme.of(context).primaryColor
      : AppColors.kColorAccent[200];
}

class DateTimeText extends StatelessWidget {
  final DateTime dateTime;
  final String text;
  final Color textColor;
  final Color textColorDarker;

  const DateTimeText({
    @required this.dateTime,
    @required this.text,
    @required this.textColor,
    @required this.textColorDarker,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(children: [
        TextSpan(
            text: '$text\n',
            style: TextStyle(
              fontSize: 16,
              color: textColorDarker,
              fontWeight: FontWeight.bold,
            )),
        TextSpan(
            text: '${Styles.kLogTileDateFormat.format(dateTime)}\n',
            style: TextStyle(color: textColor)),
        TextSpan(
            text: Styles.kEndTimeFormat.format(dateTime),
            style: TextStyle(color: textColor))
      ]),
    );
  }
}
