import 'package:flutter/material.dart';

void showRoutesModal(BuildContext context) {
  showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(children: <Widget>[
          ListTile(
            leading: Icon(Icons.run_circle),
            title: Text('Evacuation Route 1'),
            onTap: () => print('route pressed'),
          ),
          ListTile(
            leading: Icon(Icons.run_circle),
            title: Text('Evacuation Route 2'),
            onTap: () => print('route pressed'),
          ),
          ListTile(
            leading: Icon(Icons.run_circle),
            title: Text('Evacuation Route 3'),
            onTap: () => print('route pressed'),
          ),
        ]);
      });
}
