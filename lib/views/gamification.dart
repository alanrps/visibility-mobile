import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:app_visibility/widgets/badges.dart';
import 'package:app_visibility/widgets/scoreboard.dart';
import 'package:app_visibility/widgets/informations.dart';

class Gamification extends StatefulWidget {
  const Gamification({Key? key}) : super(key: key);

  @override
  State<Gamification> createState() => _GamificationState();
}

class _GamificationState extends State<Gamification> with SingleTickerProviderStateMixin {
  late TabController controller;
  int _selectedIndex = 0;


  @override
  void initState() {
    super.initState();

    controller = TabController(vsync: this, length: _tabBar.length);

    controller.addListener(() {
      setState(() {
        this._selectedIndex = controller.index;
      });
      print("Selected Index: " + controller.index.toString());
    });
  }

  List<Widget> _tabBar = [
    Tab(icon: Icon(Icons.assignment_rounded)),
    Tab(icon: Icon(Icons.people_alt)),
    Tab(icon: Icon(Icons.emoji_events)),
  ];

  @override
 void dispose() {
   controller.dispose();
   super.dispose();
 }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: this._tabBar.length,
      child: Scaffold(
        appBar: TabBar(
          controller: controller,
          tabs: _tabBar,
        ),
        body: TabBarView(
          controller: controller,
          children: [
            Informations(controller),
            Scoreboard(),
            Achievements(),
          ],
        ),
      ),
    );
  }
}
