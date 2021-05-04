import 'package:app_visibility/widgets/map_main.dart';
import 'package:app_visibility/widgets/ranking.dart';
import 'package:app_visibility/widgets/users.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Bars extends StatefulWidget {
  @override
  _BarsState createState() => _BarsState();
}

class _BarsState extends State<Bars> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Visibility'),
        backgroundColor: Colors.yellow[700],
        actions: <Widget>[
          IconButton(icon: Icon(Icons.search), onPressed: () {})
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.yellow[800],
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.star),
              label: "Ranking",
              backgroundColor: Colors.red),
          BottomNavigationBarItem(
              icon: Icon(Icons.house),
              label: "Home",
              backgroundColor: Colors.green),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: "Usuário",
              backgroundColor: Colors.blue),
        ],
      ),
      body: <Widget>[
        Ranking(),
        MapMain(), //context
        Users(),
      ].elementAt(_selectedIndex),
    );
  }
}
