import 'package:flutter/material.dart';

void showRoutesModal(BuildContext context) {
  showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(children: <Widget>[
          ListTile(
            leading: Icon(Icons.ac_unit),
            title: Text('Cooling'),
            onTap: () => print('route pressed'),
          ),
        ]);
      });
}
