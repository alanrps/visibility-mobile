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

  static const LatLng _center = const LatLng(-24.043870, -52.376412);

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  void _selectPosition(LatLng position) {
    setState(() {
      _pickedPosition = position;
    });
  }

  static Set<Marker> _markersValues = <Marker>{
    Marker(
        markerId: MarkerId("123456634"),
        position: const LatLng(-24.041654, -52.375419)),
    Marker(
        markerId: MarkerId("123453467"),
        position: const LatLng(-24.043006, -52.376041)),
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
