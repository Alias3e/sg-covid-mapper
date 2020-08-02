import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sgcovidmapper/models/hive/tag.dart';
import 'package:sgcovidmapper/models/timeline/timeline.dart';

class VisitBody extends StatelessWidget {
  final VisitTimelineItem item;

  const VisitBody({this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
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
                      textAlign: TextAlign.justify,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  item.warningLevel > 0
                      ? Icon(
                          Icons.warning,
                          size: 28,
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
          Wrap(
            children: _makeChips(),
            spacing: 4.0,
            runSpacing: -8.0,
          )
        ],
      ),
    );
  }

  List<Chip> _makeChips() {
    List<Chip> chips = [];
    for (Tag tag in item.tags) {
      Chip chip = Chip(
        label: Text(
          '${tag.label}${tag.similarity != 1.0 && tag.similarity != 0.0 ? getSimilarityAsPercentage(tag.similarity) : ''}',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor:
            Color.lerp(Colors.amber, Colors.redAccent, tag.similarity),
      );
      chips.add(chip);
    }
    return chips;
  }

  String getSimilarityAsPercentage(double similarity) {
    return '(${(similarity * 100).round()}%)';
  }
}
