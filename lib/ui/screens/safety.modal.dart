import 'package:bee_mobile/utils/servicewrapper.dart';
import 'package:flutter/material.dart';

class SafeIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new LayoutBuilder(builder: (context, constraint) {
        return new Icon(Icons.check_circle_outlined, size: 80);
      }),
    );
  }
}

class NotSafeIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new LayoutBuilder(builder: (context, constraint) {
        return new Icon(Icons.cancel_sharp, size: 80);
      }),
    );
  }
}

void showSafetyModal(
    BuildContext context, ServiceWrapper serviceWrapper) async {
  showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
                gradient: LinearGradient(
                  colors: [
                    Colors.white,
                    Colors.white
                  ], //[Color(0xFFFF8811), Color(0xFFE3B505)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )),
            height: MediaQuery.of(context).size.height / 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ButtonTheme(
                    minWidth: 175.0,
                    height: 175.0,
                    // ignore: deprecated_member_use
                    child: RaisedButton(
                        color: Colors.green,
                        padding: const EdgeInsets.all(20),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(16.0))),
                        onPressed: () {
                          print("green button pressed");
                          serviceWrapper.sendSafety(true);
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[new SafeIcon(), Text('I am Safe')],
                        ))),
                // ignore: deprecated_member_use
                ButtonTheme(
                    minWidth: 175.0,
                    height: 175.0,
                    // ignore: deprecated_member_use
                    child: RaisedButton(
                        color: Colors.red,
                        padding: const EdgeInsets.all(20),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(16.0))),
                        onPressed: () {
                          print("red button pressed");
                          serviceWrapper.sendNotSafe(false);
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            new NotSafeIcon(),
                            Text('I am NOT Safe')
                          ],
                        ))),
              ],
            ));
      });
}
