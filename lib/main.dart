import 'package:flutter/material.dart';
import 'package:app_visibility/theme/style.dart';
import 'package:app_visibility/routes/routes.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future main() async {
  // Carrega as váriaveis de ambiente do aquivo .env
  await dotenv.load(fileName: ".env");

  return runApp(
    MaterialApp(
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
  AppRoutes appRoutes = new AppRoutes();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Visibility',
        debugShowCheckedModeBanner: false,
        theme: appTheme(),
        initialRoute: appRoutes.getLogin,
        routes: appRoutes.routes());
  }
}
