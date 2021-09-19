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
  LatLng _center;
  bool _inProgress = false;

  @override
  void initState() {
    super.initState();
    getCurrentUserLocation();
  }

  getCurrentUserLocation() async {
    final LocationData location = await Location().getLocation();
    LatLng center = LatLng(location.latitude, location.longitude);

    setState(() {
      _center = center;
      _inProgress = true;
    });
  }

  Completer<GoogleMapController> _controller = Completer();

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  void _selectPosition(LatLng position) {
    print(position);

    setState(() {
      _pickedPosition = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Selecione a Localização'),
          backgroundColor: Colors.yellow[700],
        ),
        body: Center(
            child: Stack(
          children: <Widget>[
            if (_inProgress == false) ...[
              Container(
                child: Center(
                  child: CircularProgressIndicator(
                    color: Colors.black,
                    value: null,
                  ),
                ),
              )
            ],
            if (_inProgress != false) ...[
              GoogleMap(
                mapType: _currentMapType,
                mapToolbarEnabled: false,
                zoomControlsEnabled: false,
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: _center,
                  zoom: 17,
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
            ],
            if (_pickedPosition != null)
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: FloatingActionButton(
                    onPressed: () => Navigator.pushNamed(
                        context, AppRoutes.CREATE_MARKER,
                        arguments: {
                          'latitude': _pickedPosition.latitude,
                          'longitude': _pickedPosition.longitude,
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
