import 'package:flutter/material.dart';
//routes
import 'package:app_visibility/routes/routes.dart';
//views
import 'views/form_create_marker.dart';
import 'package:app_visibility/views/home.dart';
import 'views/login.dart';

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
        initialRoute: AppRoutes.HOME,
        routes: {
          AppRoutes.CREATE_MARKER: (context) => FormCreateMark(),
          AppRoutes.HOME: (context) => Home(),
          AppRoutes.LOGIN: (context) => Login(),
        });
  }
}
