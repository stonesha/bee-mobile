import 'package:flutter/material.dart';

void showSettingsModal(BuildContext context) {
  showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(children: <Widget>[
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Set Evacuee Name'),
            onTap: () => print('setting 1 pressed'),
          ),
        ]);
      });
}
