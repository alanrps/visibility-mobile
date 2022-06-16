import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:app_visibility/shared/config.dart';
import 'package:app_visibility/models/ranking.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Scoreboard extends StatefulWidget {
  @override
  _ScoreboardState createState() => _ScoreboardState();
}

class _ScoreboardState extends State<Scoreboard> {
  Dio dio = new Dio();
  List<Widget> _scoreboard = [];
  FlutterSecureStorage storage = new FlutterSecureStorage();
  final ScrollController _scrollController = ScrollController();
  bool _loading = false;
  int _lastindex = 1;
  int _page = 1;

  @override
  void initState() {
    super.initState();
    _getUsersScoreboard(update:true)
      .then((usersScoreboard) => _getListData(usersScoreboard));
    _scrollController.addListener(() { 
       if(_scrollController.position.pixels >= _scrollController.position.maxScrollExtent){
      _getUsersScoreboard()
        .then((usersScoreboard) => _getListData(usersScoreboard));
    }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  _getListData(List<Ranking> usersScoreboard, {bool restart = false}){
    List<Widget> widgets = [];
    
    if(restart){
      _lastindex = 1;
      _page = 1;
    }

    for (final user in usersScoreboard) {
      widgets.add(
        Card(
          child: ListTile(
            leading: Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              child: Text(
                '${_lastindex.toString()}',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 16),
              ),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.yellow[700],
              ),
            ),
            title: Text(user.name as String),
            trailing: Container(
                child: Text('Pontuação: ${user.weekly_points}', style: TextStyle(
                                // fontWeight: FontWeight.bold,
                                // color: Colors.black,
                                fontSize: 13))),
            onTap: () => {},
          ),
        ),
      );
      _lastindex += 1;
    }

    if(restart)
      _scoreboard = widgets;
    else
      _scoreboard.addAll(widgets);
    
    setState(() {
        _scoreboard = _scoreboard;
        _loading = false; 
        _page = _page += 1;
    });
  }

  _getUsersScoreboard({bool update = false}) async {
    Map<String, String> userData = await storage.readAll();

    if(update != true){
      setState(() => _loading = true);
    }

    try {
      final String url = '${Config.baseUrl}/ranking?page=${update ? 1 : this._page}';
      final response = await dio.get(url,
          options: Options(
            headers: {
              'Authorization': 'Bearer ${userData['token']}',
            },
          ));

      final achievementsAndPagination = response.data;
      final achievements = achievementsAndPagination['data'];

      print('conquistas');
      print(achievements);

      List<Ranking> usersInformations = List<Ranking>.from(achievements.map((achievement) => Ranking.fromJson(achievement)));

      return usersInformations;
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;

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
               List<Ranking> usersScoreboard = await _getUsersScoreboard(update: true);
              await _getListData(usersScoreboard, restart: true );
            },
            child: Stack(
              children: [
                ListView(
                    controller: _scrollController,
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
                  if(this._loading)
                    ...[
                      Positioned(
                      left: 0,
                      bottom: 0,
                      child: Container(
                        width: deviceWidth,
                        alignment: Alignment.center,
                        height: 80,
                        child: Center(
                          child: CircularProgressIndicator(),
                        )
                    )
                  )
                    ]
              ]
              
            ),
          )),
    );
  }
}
