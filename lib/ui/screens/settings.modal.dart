import 'package:bee_mobile/utils/servicewrapper.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

//shows settings modal, only option is to change your name which is then sent to the server
void showSettingsModal(BuildContext context, ServiceWrapper _serviceWrapper) {
  var name;

  showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(children: <Widget>[
          ListTile(
              leading: Icon(Icons.person),
              title: Text('Set Evacuee Name'),
              onTap: () {
                Alert(
                    context: context,
                    title: "Set Name",
                    content: Column(
                      children: <Widget>[
                        TextField(
                          decoration: InputDecoration(
                            icon: Icon(Icons.account_circle),
                            labelText: 'Name',
                          ),
                          onSubmitted: (String value) async {
                            name = value;
                            _serviceWrapper.updateName(name);
                          },
                        ),
                      ],
                    ),
                    buttons: [
                      DialogButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "SEND",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      )
                    ]).show();
              }),
        ]);
      });
}
