import 'package:flutter/material.dart';
import 'package:bee_mobile/utils/servicewrapper.dart';

void showRoutesModal(BuildContext context, ServiceWrapper serviceWrapper) {
  var response;
  serviceWrapper.getData().then((value) {
    response = value;
  });

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
