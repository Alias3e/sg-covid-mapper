import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sgcovidmapper/models/hive/visit.dart';
import 'package:sgcovidmapper/util/constants.dart';
import 'package:timeago/timeago.dart' as timeago;

class AlertsDialog {
  static showAlertDialog(List<Visit> visits, BuildContext context) {
    showGeneralDialog(
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 500),
      pageBuilder: (context, animation, secondaryAnimation) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: Theme.of(context).primaryColorLight,
        insetPadding: EdgeInsets.all(32),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Icon(
                    FontAwesomeIcons.exclamation,
                    size: 28,
                    color: Theme.of(context).accentColor,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: Text(
                      'Following location was visited by cases while you were also in the vicinity',
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
              ListView.builder(
                itemCount: visits.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  Visit visit = visits[index];
                  return ListTile(
                    title: Text(visit.title),
                    subtitle: Text(
                        '${timeago.format(visit.checkInTime)} on ${Styles.kUpdatedDateFormat.format(visit.checkInTime)} ${visit.checkOutTime == null ? '' : 'to ${Styles.kUpdatedDateFormat.format(visit.checkOutTime)}'}'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      context: context,
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position:
              Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim1),
          child: child,
        );
      },
    );
  }
}
