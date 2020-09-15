import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sgcovidmapper/blocs/initialization/initialization.dart';
import 'package:sgcovidmapper/util/constants.dart';

class SplashDialog extends StatelessWidget {
  final List<dynamic> dialogContents;

  const SplashDialog({this.dialogContents});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 50, top: 16, left: 16, right: 16),
      child: BlocConsumer<InitializationBloc, InitializationState>(
          listenWhen: (previous, current) => current is DialogContentChange,
          listener: (context, state) {
            if (state is DialogContentChange &&
                state.nextIndex >= dialogContents.length)
              Navigator.pop(context);
          },
          builder: (context, state) {
            int index = 0;
            if (state is DialogContentChange) index = state.nextIndex;
            if (index >= dialogContents.length) return Container();
            return AnimatedSwitcher(
              duration: Duration(milliseconds: kAnimationDuration),
              child: DialogBody(
                title: dialogContents[index]['title'],
                content: dialogContents[index]['body'],
                index: index,
                key: Key(index.toString()),
              ),
            );
          }),
    );
  }
}

class DialogBody extends StatelessWidget {
  const DialogBody({
    Key key,
    @required this.title,
    @required this.content,
    @required this.index,
  }) : super(key: key);

  final String title;
  final String content;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Material(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.all(Radius.circular(16)),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                content,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              SizedBox(
                height: 16,
              ),
              FlatButton(
                onPressed: () => BlocProvider.of<InitializationBloc>(context)
                    .add(OnDialogChanged(index + 1)),
                child: Text(
                  index == 0 ? 'Next' : 'Done',
                  style: TextStyle(
                      color: Theme.of(context).accentColor, fontSize: 24),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
