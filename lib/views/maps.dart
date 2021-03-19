import 'package:app_visibility/utils/app_routes.dart';
import 'package:flutter/material.dart';

class Maps extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Meus Lugares'),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  Navigator.of(context).pushNamed(AppRoutes.MAPS);
                })
          ],
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ));
  }
}
