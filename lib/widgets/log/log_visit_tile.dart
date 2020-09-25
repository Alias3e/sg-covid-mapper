import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sgcovidmapper/blocs/log/log.dart';
import 'package:sgcovidmapper/models/hive/visit.dart';
import 'package:sgcovidmapper/util/constants.dart';
import 'package:sgcovidmapper/widgets/log/edit_visit_panel.dart';

class LogVisitTile extends StatelessWidget {
  final Visit visit;
  final bool isNew;

  const LogVisitTile({this.visit, this.isNew});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: isNew
          ? new RoundedRectangleBorder(
              side: new BorderSide(
                  color: Theme.of(context).accentColor, width: 4.0),
              borderRadius: BorderRadius.circular(4.0))
          : new RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.0)),
      child: Stack(
        children: [
          Positioned.fill(
            child: Hero(
              tag: 'container ${visit.key}',
              child: Container(
                color: visit.warningLevel > 0
                    ? AppColors.kColorAccentLight
                    : AppColors.kColorPrimaryLight,
              ),
            ),
          ),
          Padding(
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
                      textColor: Colors.black,
                      textColorDarker: Theme.of(context).primaryColor,
                    ),
                    SizedBox(
                      width: 16.0,
                    ),
                    visit.checkOutTime != null
                        ? DateTimeText(
                            dateTime: visit.checkOutTime,
                            text: 'OUT',
                            textColor: Colors.black,
                            textColorDarker: Theme.of(context).primaryColor,
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
                    Expanded(
                      child: Hero(
                        tag: 'title ${visit.key}',
                        child: Material(
                          color: Colors.transparent,
                          child: Text(
                            visit.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: Colors.black,
                            ),
                          ),
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
                        color: Theme.of(context).accentColor,
                        size: 20,
                      ),
                      onPressed: () => BlocProvider.of<LogBloc>(context)
                          .add(OnDeleteButtonPressed(visit)),
                    ),
                    IconButton(
                      icon: Icon(
                        FontAwesomeIcons.edit,
                        color: Theme.of(context).accentColor,
                        size: 20,
                      ),
                      onPressed: () => Navigator.of(context).push(
                        PageRouteBuilder(
                          fullscreenDialog: true,
                          transitionDuration: Duration(
                            milliseconds: 500,
                          ),
                          pageBuilder: (BuildContext context,
                              Animation<double> animation,
                              Animation<double> secondaryAnimation) {
                            return EditVisitPanel(visit: visit);
                          },
                          transitionsBuilder: (BuildContext context,
                              Animation<double> animation,
                              Animation<double> secondaryAnimation,
                              Widget child) {
                            return FadeTransition(
                              opacity:
                                  animation, // CurvedAnimation(parent: animation, curve: Curves.elasticInOut),
                              child: child,
                            );
                          },
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
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
