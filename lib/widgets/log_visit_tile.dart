import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
                  visit: visit,
                  text: 'IN',
                ),
                SizedBox(
                  width: 16.0,
                ),
                visit.checkOutTime != null
                    ? DateTimeText(
                        visit: visit,
                        text: 'OUT',
                      )
                    : IconButton(
                        icon: Icon(
                          FontAwesomeIcons.signOutAlt,
                          color: Colors.amber,
                        ),
                        onPressed: () {},
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
              children: _makeChips(),
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
                    FontAwesomeIcons.trash,
                    color: Colors.amber,
                    size: 20,
                  ),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(
                    FontAwesomeIcons.edit,
                    color: Colors.amber,
                    size: 20,
                  ),
                  onPressed: () {},
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
  final Visit visit;
  final String text;

  const DateTimeText({
    @required this.visit,
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
            text: '${Styles.kLogTileDateFormat.format(visit.checkInTime)}\n',
            style: TextStyle(color: Colors.black)),
        TextSpan(
            text: Styles.kEndTimeFormat.format(visit.checkInTime),
            style: TextStyle(color: Colors.black54))
      ]),
    );
  }
}
