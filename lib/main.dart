import 'package:app_visibility/utils/app_routes.dart';
import 'package:app_visibility/views/form_register_mark.dart';
// import 'package:example/views/login_screen.dart';
import 'package:flutter/material.dart';

import 'views/form_register_mark.dart';
// ignore: unused_import
import 'views/login_screen.dart';
// import 'package:example/views/maps.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Visibility',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.yellow,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: LoginScreen(),
        routes: {
          AppRoutes.MAPS: (ctx) => FormRegisterMark(),
          AppRoutes.LOGIN: (ctx) => LoginScreen(),
        });
  }
}
