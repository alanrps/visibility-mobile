import 'package:flutter/material.dart';
import 'package:location/location.dart';

class MyLocation extends StatefulWidget {
  @override
  _MyLocationState createState() => _MyLocationState();
}

class _MyLocationState extends State<MyLocation> {
  var currentLocation;
  var location = new Location();

  Future<void> _getCurrentUserLocation() async {
    Location location = new Location();

    var _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    var _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    currentLocation = await location.getLocation();
    print(currentLocation);
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Container(
        height: 450,
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            border: Border.all(
          width: 1,
          color: Colors.grey,
        )),
        child: currentLocation == null
            ? Text('Localização não informada!')
            : Image.network(currentLocation,
                fit: BoxFit.cover, width: double.infinity),
      ),
      SizedBox(
        height: 5,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextButton.icon(
            icon: Icon(Icons.location_on),
            label: Text('Localização Atual'),
            style: TextButton.styleFrom(primary: Colors.black),
            onPressed: _getCurrentUserLocation,
          ),
          TextButton.icon(
            icon: Icon(Icons.map),
            label: Text('Selecione no Mapa!'),
            style: TextButton.styleFrom(primary: Colors.black),
            onPressed: () {},
          ),
        ],
      )
    ]);
  }
}
