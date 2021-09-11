import 'dart:async';
import 'package:dio/dio.dart';
import 'package:geocore/geo.dart';
import 'package:geocore/parse_wkt.dart';
import 'package:location/location.dart';
import 'package:app_visibility/routes/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapMain extends StatefulWidget {
  @override
  _MapMainState createState() => _MapMainState();
}

class _MapMainState extends State<MapMain> {
  Map<String, String> icons = {
    'EDUCATION': 'assets/educacao.png',
  };
  Set<Marker> _markers = {};
  bool _openModal = false;
  bool _inProgress = false;
  Dio dio = new Dio();
  LatLng _pickedPosition;
  LatLng _center;
  BitmapDescriptor mapMarker1;
  BitmapDescriptor mapMarker2;
  BitmapDescriptor mapMarker3;
  BitmapDescriptor mapMarker4;
  Completer<GoogleMapController> _controller = Completer();

  Future<LatLng> _getCurrentUserLocation() async {
    final LocationData location = await Location().getLocation();
    LatLng center = LatLng(location.latitude, location.longitude);

    await _getMarkers(center);

    setState(() {
      _center = center;
      _inProgress = true;
    });
  }

  LatLng _convertWktInLatLong(String coordinates) {
    GeoPoint point = wktGeographic.parse(coordinates);

    return new LatLng(point.lat, point.lon);
  }

  // List <Map>_formatMarkers(List<Map> markers){
  //   List<Map> formatedMarkers = markers.map((marker){
  //        LatLng coordinates = _convertWktInLatLong(marker.coordinates);

  //       return Marker(
  //         markerId: MarkerId(marker['id'].toString()),
  //         position: coordinates,
  //         icon: marker['category_id'],
  //     )
  //   });
  // }

  _getMarkers(LatLng coordinates) async {
    String currentPosition =
        "POINT(${coordinates.longitude} ${coordinates.latitude})";
    String url = "http://192.168.237.70:3000/markers/${currentPosition}";

    Response response = await dio.get(url);

    print(response.data);

    for (Map<String, dynamic> marker in response.data) {
      LatLng coordinates = _convertWktInLatLong(marker['coordinates']);

      if (_markers.isNotEmpty) {
        _markers = {};
      }

      _markers.add(Marker(
          markerId: MarkerId(marker['id'].toString()), position: coordinates));
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  void _selectPosition(LatLng position) async {
    print(position);

    // setState(() {
    //   _inProgress = true;
    // });

    await _getMarkers(position);

    // setState(() {
    //   _inProgress = false;
    // });
  }

  @override
  void initState() {
    super.initState();
    _getCurrentUserLocation();
    // setCustomMarker();
  }

  // void setCustomMarker() async {
  // mapMarker1 = await BitmapDescriptor.fromAssetImage(
  //     ImageConfiguration(), 'assets/educacao.png');
  //   mapMarker2 = await BitmapDescriptor.fromAssetImage(
  //       ImageConfiguration(), 'assets/hospital.png');
  //   mapMarker3 = await BitmapDescriptor.fromAssetImage(
  //       ImageConfiguration(), 'assets/restaurante.png');
  //   mapMarker4 = await BitmapDescriptor.fromAssetImage(
  //       ImageConfiguration(), 'assets/supermercado.png');
  // }

  // static Set<Marker> _markersValues = <Marker>{
  //   Marker(
  //       // onTap: ,
  //       markerId: MarkerId("123456634"),
  //       position: const LatLng(-24.041654, -52.375419)),
  //   Marker(
  //       markerId: MarkerId("123453467"),
  //       position: const LatLng(-24.043006, -52.376041)),
  // };

  // Set<Marker> _createMarker() {
  //   return {
  //     Marker(
  //         markerId: MarkerId("marker_1"),
  //         position: LatLng(-24.043006, -52.376041),
  //         // icon: mapMarker1,
  //         infoWindow: InfoWindow(title: 'Marker 1')),
  //     Marker(
  //       markerId: MarkerId("marker_2"),
  //       position: LatLng(-24.034282, -52.374618),
  //       // icon: mapMarker2,
  //     ),
  //     Marker(
  //       markerId: MarkerId("marker_3"),
  //       position: LatLng(-24.034654, -52.43270),
  //       // icon: mapMarker3,
  //     ),
  //     Marker(
  //       markerId: MarkerId("marker_4"),
  //       position: LatLng(-24.036070, -52.374071),
  //       // icon: mapMarker4,
  //     ),
  //     Marker(
  //       markerId: MarkerId("marker_5"),
  //       position: LatLng(-24.236070, -52.374071),
  //       // icon: mapMarker3,
  //     ),
  //     Marker(
  //       markerId: MarkerId("marker_6"),
  //       position: LatLng(-24.056070, -52.374071),
  //       // icon: mapMarker1,
  //     ),
  //     Marker(
  //       markerId: MarkerId("marker_7"),
  //       position: LatLng(-24.0786070, -52.374071),
  //       // icon: mapMarker2,
  //     ),
  //     Marker(
  //       markerId: MarkerId("marker_8"),
  //       position: LatLng(-24.0456070, -52.474071),
  //       // icon: mapMarker3,
  //     ),
  //     Marker(
  //       markerId: MarkerId("marker_8"),
  //       position: LatLng(-24.024451, -52.382979),
  //       // icon: mapMarker3,
  //     ),
  //   };
  // }

  MapType _currentMapType = MapType.normal;

  @override
  Widget build(BuildContext context) {
    return Stack(
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
            zoomControlsEnabled: true,
            onMapCreated: _onMapCreated,
            markers: _markers,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 17,
            ),
            // onCameraMove: (data) => print(data.target.longitude),
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
      ],
    );
  }
}
