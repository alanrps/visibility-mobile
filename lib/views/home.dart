// import 'package:app_visibility/views/form_create_marker.dart';
// import 'package:app_visibility/widgets/Bars.dart';
import 'package:flutter/material.dart';
import 'package:app_visibility/widgets/map_main.dart';
// import 'package:app_visibility/widgets/ranking.dart';
import 'package:app_visibility/widgets/users.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:app_visibility/routes/routes.dart';
// import 'dart:async';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // Widget _homeScreen() {
  //   return Column(children: <Widget>[
  //     Container(
  //       height: 450,
  //       width: double.infinity,
  //       alignment: Alignment.center,
  //       decoration: BoxDecoration(
  //           border: Border.all(
  //         width: 1,
  //         color: Colors.grey,
  //       )),
  //       child: currentLocation == null
  //           ? Text('Localização não informada!')
  //           : Image.network(currentLocation,
  //               fit: BoxFit.cover, width: double.infinity),
  //     ),
  //     SizedBox(
  //       height: 5,
  //     ),
  //     Row(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: <Widget>[
  //         TextButton.icon(
  //           icon: Icon(Icons.location_on),
  //           label: Text('Localização Atual'),
  //           style: TextButton.styleFrom(primary: Colors.black),
  //           // onPressed: _getCurrentUserLocation,
  //         ),
  //         TextButton.icon(
  //           icon: Icon(Icons.map),
  //           label: Text('Selecione no Mapa!'),
  //           style: TextButton.styleFrom(primary: Colors.black),
  //           onPressed: () {},
  //         ),
  //       ],
  //     )
  //   ]);
  // }

  // Widget _map(context) {
  //   return Stack(
  //     children: <Widget>[
  //       GoogleMap(
  //         mapType: _currentMapType,
  //         zoomControlsEnabled: false,
  //         onMapCreated: _onMapCreated,
  //         initialCameraPosition: CameraPosition(
  //           target: _center,
  //           zoom: 11.0,
  //         ),
  //         onTap: _selectPosition,
  //         markers: _pickedPosition != null
  //             ? {
  //                 Marker(
  //                     markerId: MarkerId("markedPosition"),
  //                     position: _pickedPosition)
  //               }
  //             : _markersValues,
  //       ),
  //     ],
  //   );
  // }

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
        // actions: <Widget>[
        // IconButton(icon: Icon(Icons.search), onPressed: () {})
        // ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.yellow[800],
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          // BottomNavigationBarItem(
          //     icon: Icon(Icons.star),
          //     label: "Ranking",
          //     backgroundColor: Colors.red),
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
        MapMain(),
        Users(),
        // Ranking(),
      ].elementAt(_selectedIndex),
    );
  }
}
