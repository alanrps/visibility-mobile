import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:app_visibility/shared/config.dart';
import 'package:app_visibility/models/badges.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Achievements extends StatefulWidget {
  const Achievements({Key? key}) : super(key: key);

  @override
  State<Achievements> createState() => _AchievementsState();
}

class _AchievementsState extends State<Achievements> {
  Dio dio = new Dio();
  List<Badges> ?_badges;
  FlutterSecureStorage storage = new FlutterSecureStorage();

  _getListData() {
    List<Widget> widgets = [];
    for (final badge in this._badges!) {
      widgets.add(
         Card(
            child: ListTile(
              leading: FlutterLogo(),
              title: Text('Descrição'),
              subtitle: Text(badge.description as String),
              // trailing: Icon(Icons.arrow_forward_ios),
              onTap: () => {},
            ),
          ),
      );
    }

    return widgets;
  }

  _getUserAchievements() async {
     Map<String, String> userData = await storage.readAll();

    try {
        final String url = '${Config.baseUrl}/users/${userData['id']}/achievements';
        final response = await dio.get(url,
            options: Options(
              headers: {
                'Authorization': 'Bearer ${userData['token']}',
              },
            ));

        final achievements = response.data;

        List<Badges> badges = List<Badges>.from(achievements.map((achievement) => Badges.fromJson(achievement)));

        return badges;
      } catch (e) {
        print(e);
      }
    }

  @override
  void initState() {
    super.initState();
    _getUserAchievements()
      .then((achievements) {
        print(achievements);

        setState(() {
          _badges = achievements;
        });

      });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      child: Center(
          child: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Text(
              'Conquistas',
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
          ),
          if(_badges == null)
          Container(
            child: Center(
              child: CircularProgressIndicator(
                color: Colors.black,
                value: null,
              ),
            ),
          ) 
          else
          ..._getListData()
        ],
      )),
    );
  }
}
