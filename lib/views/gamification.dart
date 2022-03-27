import 'package:flutter/material.dart';
import 'package:app_visibility/widgets/badges.dart';
import 'package:app_visibility/widgets/scoreboard.dart';
import 'package:app_visibility/widgets/informations.dart';

class Gamification extends StatefulWidget {
  const Gamification({ Key? key }) : super(key: key);

  @override
  State<Gamification> createState() => _GamificationState();
}

class _GamificationState extends State<Gamification> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.assignment_rounded)),
                Tab(icon: Icon(Icons.people_alt)),
                Tab(icon: Icon(Icons.emoji_events)),
              ],
            ),
            // title: const Text('Tabs Demo'),
          
          body: TabBarView(
            children: [
              Informations(),
              Scoreboard(),
              Achievements(),
            ],
          ),
        ),
      );
  }
}