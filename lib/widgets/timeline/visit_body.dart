import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sgcovidmapper/models/hive/tag.dart';
import 'package:sgcovidmapper/models/timeline/timeline.dart';

class VisitBody extends StatelessWidget {
  final VisitTimelineItem item;

  const VisitBody({this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      item.title,
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  item.warningLevel > 0
                      ? Icon(
                          FontAwesomeIcons.exclamation,
                          size: 22,
                          color: Colors.redAccent,
                        )
                      : Container(
                          width: 0,
                          height: 0,
                        ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Wrap(
              children: _makeChips(),
              spacing: 4.0,
              runSpacing: -8.0,
            ),
          )
        ],
      ),
    );
  }

  List<Widget> _makeChips() {
    List<Widget> chips = [];
    for (Tag tag in item.tags) {
      Widget chip = Container(
        margin: EdgeInsets.only(bottom: 3, right: 3),
        child: Chip(
          elevation: 2,
          shadowColor: Colors.blueGrey,
          label: Text(
            '${tag.label}${tag.similarity != 1.0 && tag.similarity != 0.0 ? getSimilarityAsPercentage(tag.similarity) : ''}',
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

  String getSimilarityAsPercentage(double similarity) {
    return '(${(similarity * 100).round()}%)';
  }
}
