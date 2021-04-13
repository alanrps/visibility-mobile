import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:app_visibility/routes/routes.dart';
// import 'package:location/location.dart';
import 'dart:async';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Completer<GoogleMapController> _controller = Completer();

  // Location location = new Location();

  static const LatLng _center = const LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  // Future<LocationData> _getCurrentUserLocation() async {
  //   return await Location().getLocation();
  // }

  // var _serviceEnabled = await location.serviceEnabled();
  // if (!_serviceEnabled) {
  //   _serviceEnabled = await location.requestService();
  //   if (!_serviceEnabled) {
  //     return;
  //   }
  // }

  // var _permissionGranted = await location.hasPermission();
  // if (_permissionGranted == PermissionStatus.denied) {
  //   _permissionGranted = await location.requestPermission();
  //   if (_permissionGranted != PermissionStatus.granted) {
  //     return;
  //   }
  // }

  // currentLocation = await location.getLocation();
  // print(currentLocation);
  // }

  MapType _currentMapType = MapType.normal;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Visibility'),
          backgroundColor: Colors.yellow[700],
          actions: <Widget>[
            IconButton(icon: Icon(Icons.search), onPressed: () {})
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 0,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.star), label: "Ranking"),
            BottomNavigationBarItem(icon: Icon(Icons.house), label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_circle), label: "Usuário"),
          ],
        ),
        body: Stack(
          children: <Widget>[
            GoogleMap(
              mapType: _currentMapType,
              zoomControlsEnabled: false,
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 11.0,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Align(
                alignment: Alignment.bottomRight,
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(AppRoutes.CREATE_MARKER);
                  },
                  materialTapTargetSize: MaterialTapTargetSize.padded,
                  backgroundColor: Colors.white,
                  child: const Icon(
                    Icons.add,
                    size: 45.0,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
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
  //           onPressed: _getCurrentUserLocation,
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
}
