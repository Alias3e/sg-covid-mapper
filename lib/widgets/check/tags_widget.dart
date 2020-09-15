import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sgcovidmapper/models/hive/tag.dart';
import 'package:sgcovidmapper/util/constants.dart';

class TagsWidget extends StatefulWidget {
  final Function onTagAdd;
  final Widget chipsBox;
  final bool hasInitialTags;

  const TagsWidget({this.onTagAdd, this.chipsBox, this.hasInitialTags});
  @override
  _TagsWidgetState createState() => _TagsWidgetState();
}

class _TagsWidgetState extends State<TagsWidget> {
  MainAxisSize _axisSize = MainAxisSize.min;
  TextEditingController _textEditingController;

  @override
  void initState() {
    _textEditingController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: kAnimationDuration),
      child: _axisSize == MainAxisSize.min && !widget.hasInitialTags
          ? RaisedButton(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              onPressed: () {
                setState(() {
                  _axisSize = _axisSize == MainAxisSize.min
                      ? MainAxisSize.max
                      : MainAxisSize.min;
                });
              },
              shape: StadiumBorder(),
              color: Theme.of(context).accentColor,
              child: Row(
                mainAxisSize: _axisSize,
                children: [
                  Icon(
                    FontAwesomeIcons.tags,
                    color: Colors.white,
                  ),
                  SizedBox(width: 16.0),
                  Text(
                    'Add Tags',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  )
                ],
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).accentColor,
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                  padding: EdgeInsets.only(left: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          controller: _textEditingController,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                              hintText: 'NTUC, KFC, Mom',
                              hintStyle: TextStyle(
                                color: Colors.white,
                              ),
                              border: InputBorder.none),
                        ),
                      ),
                      FlatButton(
                        shape: CircleBorder(),
                        onPressed: () {
                          widget.onTagAdd(Tag(_textEditingController.text));
//                            BlocProvider.of<CheckPanelBloc>(context).add(
//                                AddTag(tagName: _textEditingController.text));
                          _textEditingController.clear();
                        },
                        child: Icon(
                          FontAwesomeIcons.plus,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                ),
                widget.chipsBox,
              ],
            ),
    );
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }
}
