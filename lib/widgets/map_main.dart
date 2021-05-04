import 'dart:async';

import 'package:app_visibility/routes/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapMain extends StatefulWidget {
  @override
  _MapMainState createState() => _MapMainState();
}

class _MapMainState extends State<MapMain> {
  LatLng _pickedPosition;

  Completer<GoogleMapController> _controller = Completer();

  static const LatLng _center = const LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  void _selectPosition(LatLng position) {
    setState(() {
      _pickedPosition = position;
    });
  }

  static Set<Marker> _markersValues = <Marker>{
    Marker(markerId: MarkerId("123456"), position: const LatLng(1.21, 1.22)),
    Marker(markerId: MarkerId("1234567"), position: const LatLng(1.22, 1.23)),
  };

  MapType _currentMapType = MapType.normal;

  @override
  Widget build(BuildContext context) {
    return Stack(
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
              : _markersValues,
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              onPressed: () =>
                  Navigator.pushNamed(context, AppRoutes.CREATE_MARKER),
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
    );
  }
}
