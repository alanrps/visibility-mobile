import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:app_visibility/routes/routes.dart';
import 'package:location/location.dart';
import 'dart:async';

class Map extends StatefulWidget {
  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> {
  MapType _currentMapType = MapType.normal;
  LatLng _pickedPosition;

  static const LatLng _center = const LatLng(-24.034517, -52.372695);
  Completer<GoogleMapController> _controller = Completer();

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  Future<void> _getCurrentUserLocation() async {
    final LocationData location = await Location().getLocation();

    return location;
    // print("Latitude ${location.latitude}/${location.longitude}");
  }

  void _selectPosition(LatLng position) {
    setState(() {
      _pickedPosition = position;
    });
  }

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
        body: Center(
            child: Stack(
          children: <Widget>[
            GoogleMap(
              mapType: _currentMapType,
              zoomControlsEnabled: false,
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 11.0,
              ),
              onTap: _selectPosition,
              markers: _pickedPosition != null
                  ? {
                      Marker(
                          markerId: MarkerId("markedPosition"),
                          position: _pickedPosition)
                    }
                  : {},
            ),
            if (_pickedPosition != null)
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: FloatingActionButton(
                    onPressed: () => Navigator.pushNamed(
                        context, AppRoutes.CREATE_MARKER,
                        arguments: {
                          'position': {
                            'latitude': _pickedPosition.latitude,
                            'longitude': _pickedPosition.longitude,
                          },
                        }),
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                    backgroundColor: Colors.white,
                    child: const Icon(
                      Icons.check,
                      size: 45.0,
                      color: Colors.black,
                    ),
                  ),
                ),
              )
          ],
        )),
      ),
    );
  }
}
