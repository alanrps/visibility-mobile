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
  List<Widget> tabBar = [
    Informations(),
    Scoreboard(),
    Achievements(),
  ];

  late TabController _tabController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: tabBar.length);

    // _tabController.animateTo(_selectedIndex += 1);

    _tabController.addListener(() {
    setState(() {
      _selectedIndex = _tabController.index;
    });
    print("Selected Index: " + _tabController.index.toString());
  });
  }

  @override
 void dispose() {
   _tabController.dispose();
   super.dispose();
 }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabBar.length,
      child: Scaffold(
        appBar: const TabBar(
          tabs: [
            Tab(icon: Icon(Icons.assignment_rounded)),
            Tab(icon: Icon(Icons.people_alt)),
            Tab(icon: Icon(Icons.emoji_events)),
          ],
        ),
        body: TabBarView(
          // controller: _tabController,
          children: tabBar,
        ),
      ),
    );
  }
}
