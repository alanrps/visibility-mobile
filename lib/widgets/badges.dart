import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:app_visibility/shared/config.dart';
import 'package:app_visibility/models/badges.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class Achievements extends StatefulWidget {
  const Achievements({Key? key}) : super(key: key);

  @override
  State<Achievements> createState() => _AchievementsState();
}

class _AchievementsState extends State<Achievements> {
  Dio dio = new Dio();
  List<Badges>? _badges;
  FlutterSecureStorage storage = new FlutterSecureStorage();

  Map<String, String> mapNames = {
    "evaluations": "Avaliações",
    "public_evaluations": "Avaliações Públicas",
    "private_evaluations": "Avaliações Privadas",
    "place": "Lugares",
    "wheelchair_parking": "Vagas para Cadeirantes",
    "travel": "Viagem",
    "transpont": "Transporte",
    "supermarket": "Supermercado",
    "services": "Serviços",
    "leisure": "Lazer",
    "education": "Educação",
    "food": "Comida",
    "hospital": "Hospital",
    "accomodation": "Alojamentos",
    "finance": "Financias",
  };

  _getListData() {
    
    List<Widget> widgets = [];
    for (final badge in this._badges!) {
      widgets.add(
        Card(
          child: ListTile(
            leading: FlutterLogo(),
            title: Text('Descrição'),
            subtitle: Text(badge.description as String),
            trailing: new CircularPercentIndicator(
              radius: 20.0,
              lineWidth: 5.0,
              percent: ((badge.amount)! * 100/ badge.actionsAmount!) / 100,
              header: new Text('${badge.amount.toString()}/${badge.actionsAmount.toString()}'),
              // center: new Icon(
              //   Icons.person_pin,
              //   size: 30.0,
              //   color: Colors.blue,
              // ),
              backgroundColor: Colors.grey,
              progressColor: badge.amount != badge.actionsAmount ? Colors.blue : Colors.green,
            ),
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
    _getUserAchievements().then((achievements) {
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
          if (_badges == null)
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
