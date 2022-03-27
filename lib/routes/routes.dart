import 'package:flutter/widgets.dart';
//Views and Widgets
import 'package:app_visibility/views/home.dart';
import 'package:app_visibility/views/profile.dart';
import 'package:app_visibility/views/recovery_password.dart';
import 'package:app_visibility/views/update_password.dart';
import 'package:app_visibility/widgets/scoreboard.dart';
import 'package:app_visibility/widgets/map_main.dart';
import 'package:app_visibility/widgets/users.dart';
import '../views/form_create_marker.dart';
import '../views/sign_up.dart';
import '../views/login.dart';
import '../widgets/map.dart';

class AppRoutes {
  String login = "/";
  String home = "/home";
  String createMarker = "/createMarker";
  String map = "/map";
  String ranking = "/ranking";
  String mapmain = "/mapmain";
  String users = "/users";
  String signup = "/signup";
  String profile = "/profile";
  String recoveryPassword = '/recoveyPassword';
  String updatePassword = '/updatePassword';

  String get getHome => this.home;
  String get getCreateMarker => this.createMarker;
  String get getLogin => this.login;
  String get getMap => this.map;
  String get getRanking => this.ranking;
  String get getMapmain => this.mapmain;
  String get getUsers => this.users;
  String get getSignup => this.signup;
  String get getProfile => this.profile;
  String get getRecoveryPassword => this.recoveryPassword;
  String get getUpdatePassword => this.updatePassword;

  routes() {  
    return <String, WidgetBuilder>{
      signup: (context) => Register(),
      createMarker: (context) => FormCreateMark(),
      home: (context) => Home(),
      login: (context) => Login(),
      map: (context) => Map(),
      ranking: (context) => Scoreboard(),
      mapmain: (context) => MapMain(),
      users: (context) => Users(),
      profile: (context) => ProfilePage(),
      recoveryPassword: (context) => RecoveryPassword(),
      updatePassword: (context) => UpdatePassword(),
    };
  }
}
