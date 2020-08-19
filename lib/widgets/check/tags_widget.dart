import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sgcovidmapper/blocs/check_panel/check_panel_bloc.dart';
import 'package:sgcovidmapper/blocs/check_panel/check_panel_event.dart';
import 'package:sgcovidmapper/blocs/check_panel/check_panel_state.dart';

class TagsWidget extends StatefulWidget {
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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 250),
        child: _axisSize == MainAxisSize.min
            ? RaisedButton(
                onPressed: () {
                  setState(() {
                    _axisSize = _axisSize == MainAxisSize.min
                        ? MainAxisSize.max
                        : MainAxisSize.min;
                  });
                },
                shape: StadiumBorder(),
                color: Colors.amber,
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
                      color: Colors.amberAccent,
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
                            BlocProvider.of<CheckPanelBloc>(context).add(
                                AddTag(tagName: _textEditingController.text));
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
                  BlocBuilder<CheckPanelBloc, CheckPanelState>(
                    condition: (previous, current) => current is TagListUpdated,
                    builder: (BuildContext context, state) {
                      return Wrap(
                        children: state is TagListUpdated ? state.tags : [],
                        spacing: 4.0,
                        runSpacing: -8.0,
                      );
                    },
                  ),
                ],
              ),
      ),
    );
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }
}
