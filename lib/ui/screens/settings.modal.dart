import 'package:bee_mobile/utils/servicewrapper.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

void showSettingsModal(BuildContext context, ServiceWrapper serviceWrapper) {
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
                content: TextField(
                  decoration: InputDecoration(
                    icon: Icon(Icons.account_circle),
                    labelText: 'Name',
                  ),
                ),
                buttons: [
                  DialogButton(
                    child: Text(
                      "Enter",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      serviceWrapper.sendUser();
                    },
                    width: 120,
                  )
                ],
              ).show();
            },
          ),
        ]);
      });
}
