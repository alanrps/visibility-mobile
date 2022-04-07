import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:app_visibility/shared/config.dart';
import 'package:app_visibility/models/ranking.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Scoreboard extends StatefulWidget {
  @override
  _ScoreboardState createState() => _ScoreboardState();
}

class _ScoreboardState extends State<Scoreboard> {
  Dio dio = new Dio();
  List<Ranking>? _users;
  FlutterSecureStorage storage = new FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _getUsersScoreboard().then((usersScoreboard) {
      print(usersScoreboard);

      setState(() {
        _users = usersScoreboard;
      });
    });
  }

  _getListData() {
    List<Widget> widgets = [];
    int index = 1;

    for (final user in this._users!) {
      widgets.add(
        Card(
          child: ListTile(
            leading: Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              child: Text(
                '${index.toString()}',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 30),
              ),
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.yellow[700],
              ),
            ),
            title: Text(user.name as String),
            trailing: Container(
                child: Text('Pontuação: ${user.points}')),
            onTap: () => {},
          ),
        ),
      );
      index += 1;
    }

    return widgets;
  }

  // Nível: ${user.level} \n\n

  _getUsersScoreboard() async {
    Map<String, String> userData = await storage.readAll();

    try {
      final String url = '${Config.baseUrl}/ranking';
      final response = await dio.get(url,
          options: Options(
            headers: {
              'Authorization': 'Bearer ${userData['token']}',
            },
          ));

      final achievements = response.data;

      List<Ranking> usersInformations = List<Ranking>.from(
          achievements.map((achievement) => Ranking.fromJson(achievement)));

      return usersInformations;
    } catch (e) {
      print(e);
    }
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
              'Ranking de Contribuidores',
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
          ),
          if (_users == null)
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
