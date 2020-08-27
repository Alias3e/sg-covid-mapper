import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sgcovidmapper/blocs/log/log.dart';
import 'package:sgcovidmapper/models/hive/tag.dart';
import 'package:sgcovidmapper/models/hive/visit.dart';
import 'package:sgcovidmapper/util/constants.dart';

class LogVisitTile extends StatelessWidget {
  final Visit visit;

  const LogVisitTile({this.visit});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
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
                ),
                SizedBox(
                  width: 16.0,
                ),
                visit.checkOutTime != null
                    ? DateTimeText(
                        dateTime: visit.checkOutTime,
                        text: 'OUT',
                      )
                    : IconButton(
                        icon: Icon(
                          FontAwesomeIcons.signOutAlt,
                          color: Colors.amber,
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
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
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
                    color: Colors.amber,
                    size: 20,
                  ),
                  onPressed: () => BlocProvider.of<LogBloc>(context)
                      .add(OnDeleteButtonPressed(visit)),
                ),
                IconButton(
                  icon: Icon(
                    FontAwesomeIcons.edit,
                    color: Colors.amber,
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

  List<Widget> _makeChips() {
    List<Widget> chips = [];
    for (Tag tag in visit.tags) {
      Widget chip = Container(
        margin: EdgeInsets.only(bottom: 3, right: 3),
        child: Chip(
          elevation: 2,
          shadowColor: Colors.blueGrey,
          label: Text(
            '${tag.label}${tag.similarity != 1.0 && tag.similarity != 0.0 ? tag.similarityPercentage : ''}',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor:
              Color.lerp(Colors.amber, Colors.redAccent, tag.similarity),
        ),
      );
      chips.add(chip);
    }
    return chips;
  }
}

class DateTimeText extends StatelessWidget {
  final DateTime dateTime;
  final String text;

  const DateTimeText({
    @required this.dateTime,
    @required this.text,
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
              color: Colors.teal,
              fontWeight: FontWeight.bold,
            )),
        TextSpan(
            text: '${Styles.kLogTileDateFormat.format(dateTime)}\n',
            style: TextStyle(color: Colors.black)),
        TextSpan(
            text: Styles.kEndTimeFormat.format(dateTime),
            style: TextStyle(color: Colors.black54))
      ]),
    );
  }
}
