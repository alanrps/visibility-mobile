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
  List<Widget> _scoreboard = [];
  FlutterSecureStorage storage = new FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _getUsersScoreboard()
      .then((usersScoreboard) => _getListData(usersScoreboard));
  }

  _getListData(List<Ranking> usersScoreboard){
    List<Widget> widgets = [];
    int index = 1;

    for (final user in usersScoreboard) {
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
                shape: BoxShape.circle,
                color: Colors.yellow[700],
              ),
            ),
            title: Text(user.name as String),
            trailing: Container(
                child: Text('Pontuação: ${user.weekly_points}')),
            onTap: () => {},
          ),
        ),
      );
      index += 1;
    }

    setState(() {
        _scoreboard = widgets;
    });
  }

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

      print(achievements);

      List<Ranking> usersInformations = List<Ranking>.from(achievements.map((achievement) => Ranking.fromJson(achievement)));

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
          child: RefreshIndicator(
            displacement: 150,
            backgroundColor: Colors.white,
            color: Colors.blue,
            strokeWidth: 3,
            triggerMode: RefreshIndicatorTriggerMode.onEdge,
            onRefresh: () async {
               List<Ranking> usersScoreboard = await _getUsersScoreboard();
              await _getListData(usersScoreboard);
            },
            child: ListView(
                  scrollDirection: Axis.vertical,
                  children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                'Ranking Semanal',
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
            ),
            if (this._scoreboard.isEmpty)
              Container(
                child: Center(
                  child: CircularProgressIndicator(
                    color: Colors.black,
                    value: null,
                  ),
                ),
              )
            else
              ...this._scoreboard
                  ],
                ),
          )),
    );
  }
}
