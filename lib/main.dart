import 'package:flutter/material.dart';
import 'package:app_visibility/theme/style.dart';
import 'package:app_visibility/routes/routes.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future main() async {
  // Carrega as váriaveis de ambiente do aquivo .env
  await dotenv.load(fileName: ".env");
  AppRoutes appRoutes = new AppRoutes();

  return runApp(
    MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: [const Locale('pt', 'BR')],
      // home: Login(),
      title: 'Visibility',
      debugShowCheckedModeBanner: false,
      theme: appTheme(),
      routes: appRoutes.routes(),
      initialRoute: appRoutes.getLogin,
    ),
  );
}