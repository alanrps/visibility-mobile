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
  List<Widget>? _cards;
  FlutterSecureStorage storage = new FlutterSecureStorage();

  Map<String, Widget> iconsCategories = {
    "evaluations": Icon(Icons.add_location_alt, color: Colors.black,),
    "public_evaluations": Icon(Icons.fmd_good_outlined, color: Colors.black,),
    "private_evaluations": Icon(Icons.fmd_good_rounded, color: Colors.black,),
    "place": Icon(Icons.place, color: Colors.black,),
    "wheelchair_parking": Icon(Icons.directions_car, color: Colors.black,),
    "travel": Icon(Icons.card_travel, color: Colors.black,),
    "transport": Icon(Icons.directions_bus_rounded, color: Colors.black,),
    "supermarket": Icon(Icons.shopping_bag, color: Colors.black,),
    "services": Icon(Icons.miscellaneous_services, color: Colors.black,),
    "leisure": Icon(Icons.sports_soccer, color: Colors.black,),
    "education": Icon(Icons.school, color: Colors.black,),
    "food": Icon(Icons.food_bank_rounded, color: Colors.black,),
    "hospital": Icon(Icons.medical_services, color: Colors.black,),
    "accommodation": Icon(Icons.hotel, color: Colors.black,),
    "finance": Icon(Icons.attach_money, color: Colors.black,),
    "points": Icon(Icons.moving_rounded, color: Colors.black,),
    "level": Icon(Icons.arrow_circle_up, color: Colors.black,),
    "accessible_place": Icon(Icons.accessible, color: Colors.black,),
    "not_accessible_place": Icon(Icons.not_accessible, color: Colors.black,),
    "partially_accessible_place": Icon(Icons.error_rounded, color: Colors.black,),
    "weekly_points": Icon(Icons.groups_rounded, color: Colors.black,),
    "edit_evaluations": Icon(Icons.create_rounded, color: Colors.black,),
    "comments": Icon(Icons.comment, color: Colors.black,),
  };

  Map<String, String> mapNames = {
    "evaluations": "Avaliações",
    "public_evaluations": "Avaliações públicas",
    "private_evaluations": "Avaliações privadas",
    "place": "Locais",
    "wheelchair_parking": "Vagas para cadeirantes",
    "travel": "Viagem",
    "transport": "Transporte",
    "supermarket": "Supermercado",
    "services": "Serviços",
    "leisure": "Lazer",
    "education": "Educação",
    "food": "Alimentação",
    "hospital": "Hospital",
    "accommodation": "Hospedagem",
    "finance": "Financias",
    "points": "Pontos",
    "level": "Nível",
    "accessible_place": "Local acessível",
    "not_accessible_place": "Local não acessível",
    "partially_accessible_place": "Local parcialmente acessível",
    "weekly_points": "Pontos semenais",
    "edit_evaluations": "Avaliações editadas",
    "comments": "Comentários",
  };

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

  _getListData(List<Badges> badges) {
    List<Widget> widgets = [];
    
    for (final badge in badges) {
      print(badge.category);
      print(mapNames[badge.category]!);

      widgets.add(
        Card(
          child: ListTile(
            contentPadding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
            leading: Padding(
              padding: const EdgeInsets.only(top: 5, bottom: 5, right: 5, left: 15),
              child: iconsCategories[badge.category],
            ),
            title: Text(mapNames[badge.category]!),
            subtitle: Text(badge.description as String),
            trailing: Padding(
              padding: EdgeInsets.only(right: 15, left: 5),
              child: new CircularPercentIndicator(
                radius: 20.0,
                lineWidth: 5.0,
                percent: ((badge.amount)! * 100/ badge.actionsAmount!) / 100,
                header: new Text('${badge.amount.toString()}/${badge.actionsAmount.toString()}', style: TextStyle(
                                // fontWeight: FontWeight.bold,
                                // color: Colors.black,
                                fontSize: 13)),
                backgroundColor: Colors.grey,
                progressColor: badge.amount != badge.actionsAmount ? Colors.blue : Colors.green,
              ),
            ),
            onTap: () => {},
          ),
        ),
      );
    }

    setState(() {
        _cards = widgets;
    });
  }

  @override
  void initState() {
    super.initState();
    _getUserAchievements()
    .then((achievements) => _getListData(achievements));
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
              List<Badges> achievements = await _getUserAchievements();
              await _getListData(achievements);    
            },
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
            if (this._cards == null)
              Container(
                child: Center(
                  child: CircularProgressIndicator(
                    color: Colors.black,
                    value: null,
                  ),
                ),
              )
            else
              ...this._cards!
                  ],
                ),
          )),
    );
  }
}
