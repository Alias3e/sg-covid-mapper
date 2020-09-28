import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sgcovidmapper/util/constants.dart';

class EditTagDialog extends StatefulWidget {
  final String tag;

  const EditTagDialog({@required this.tag});

  @override
  _EditTagDialogState createState() => _EditTagDialogState();
}

class _EditTagDialogState extends State<EditTagDialog> {
  TextEditingController _textEditingController;
  FocusNode _focusNode;
  bool isTagValid = true;
  String tagLabel;
  static const Duration keyboardDelay = Duration(milliseconds: 300);

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _textEditingController = TextEditingController();
    _textEditingController.text = widget.tag;
    Future.delayed(keyboardDelay).then((_) => _focusNode.requestFocus());
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await Future.delayed(keyboardDelay);
        return true;
      },
      child: Hero(
        tag: 'edit tag ${widget.tag}',
        child: Dialog(
          backgroundColor: Theme.of(context).primaryColor,
          insetPadding: EdgeInsets.all(32),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                  child: Material(
                    color: Colors.transparent,
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          isTagValid = value.isNotEmpty;
                        });
                      },
                      style: TextStyle(color: Colors.white),
                      focusNode: _focusNode,
                      controller: _textEditingController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  InkWell(
                    customBorder: CircleBorder(),
                    onTap: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      Future.delayed(keyboardDelay).then((value) =>
                          Navigator.pop(context, _textEditingController.text));
                    },
                    child: isTagValid
                        ? Icon(
                            FontAwesomeIcons.check,
                            color: AppColors.kColorGreen,
                          )
                        : Container(
                            width: 0,
                            height: 0,
                          ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  InkWell(
                    customBorder: CircleBorder(),
                    onTap: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      Future.delayed(keyboardDelay)
                          .then((value) => Navigator.pop(context));
                    },
                    child: Icon(
                      FontAwesomeIcons.times,
                      color: AppColors.kColorRed,
                    ),
                  ),
                  SizedBox(
                    width: 16,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
