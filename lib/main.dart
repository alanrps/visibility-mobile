import 'package:flutter/material.dart';
//routes
import 'package:app_visibility/routes/routes.dart';
//views
import 'package:app_visibility/views/home.dart';
import 'package:app_visibility/widgets/ranking.dart';
import 'package:app_visibility/widgets/map_main.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:app_visibility/widgets/users.dart';
import 'views/form_create_marker.dart';
import 'views/sign_up.dart';
import 'views/login.dart';
import 'widgets/map.dart';

void main() {
   runApp( MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: [const Locale('pt', 'BR')],
      home: MyApp(),
      ),
    );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Visibility',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.yellow,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: AppRoutes.LOGIN,
        routes: {
          AppRoutes.SIGNUP: (context) => Register(),
          AppRoutes.CREATE_MARKER: (context) => FormCreateMark(),
          AppRoutes.HOME: (context) => Home(),
          AppRoutes.LOGIN: (context) => Login(),
          AppRoutes.MAP: (context) => Map(),
          AppRoutes.RANKING: (context) => Ranking(),
          AppRoutes.MAPMAIN: (context) => MapMain(),
          AppRoutes.USERS: (context) => Users(),
        });
  }
}
