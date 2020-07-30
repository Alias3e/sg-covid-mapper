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
          Center(
            child: Text(
              item.title,
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
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
          tag.label,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.amber,
      );
      chips.add(chip);
    }
    return chips;
  }
}
