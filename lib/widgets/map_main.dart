import 'dart:async';
// import 'dart:html';
import 'package:dio/dio.dart';
import 'package:geocore/geo.dart';
import 'package:geocore/parse_wkt.dart';
import 'package:location/location.dart';
import 'package:app_visibility/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:app_visibility/models/place.dart';

class MapMain extends StatefulWidget {
  @override
  _MapMainState createState() => _MapMainState();
}

class _MapMainState extends State<MapMain> {
  AppRoutes appRoutes = new AppRoutes();

  Map<String, String> icons = {
    'EDUCATION': 'assets/EDUCATION.png',
    'HOSPITALS': 'assets/HOSPITALS.png',
    'FOOD': 'assets/FOOD.png',
    'SUPERMARKET': 'assets/SUPERMARKET.png',
    'TRAVEL': 'assets/TRAVEL.png',
    'TRANSPORT': 'assets/TRANSPORT.png',
    'SERVICES': 'assets/SERVICES.png',
    'LEISURE': 'assets/LEISURE.png',
    'ACCOMMODATION': 'assets/ACCOMMODATION.png',
    'FINANCE': 'assets/FINANCE.png',
    'WHEELCHAIR_PARKING': 'assets/WHEELCHAIR_PARKING.png',
  };

  Map<String, String> acessibilityTypes = {
    'ACCESSIBLE': 'Acessível',
    'NOT ACCESSIBLE': 'Não acessível',
    'PARTIALLY': 'Parcialmente'
  };

  Map<String, Color> acessibilityTypesColors = {
    'ACCESSIBLE': Colors.lightGreen,
    'NOT ACCESSIBLE': Colors.redAccent,
    'PARTIALLY': Colors.yellow
  };

  Map<String, String> spaceTypes = {'PRIVATE': 'Privado', 'PUBLIC': 'Público'};

  Set<Marker> _markers = {};
  Place place = new Place();
  bool _openDialog = false;
  bool _inProgress = false;
  Dio dio = new Dio();
  late LatLng _center;
  String baseUrl = "https://visibility-production-api.herokuapp.com";

  _getCurrentUserLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LatLng center;

    Location location = new Location();

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
    }

    _permissionGranted = await location.hasPermission();
    if (_serviceEnabled && _permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
    }

    if(_serviceEnabled && _permissionGranted == PermissionStatus.granted){
       final LocationData location = await Location().getLocation();
        center = LatLng(location.latitude!, location.longitude!);
    }
    else{
      // Caso o usuário não passe o ponto inicial, usa-se um ponto fixo
      center = LatLng(-24.044453, -52.377743);
    }
    
    await _getMarkers(center);

        setState(() {
          _center = center;
          _inProgress = true;
        });
  }

  _loadImage(String? typeIcon) async {
    String iconPath = icons[typeIcon!]!;

    BitmapDescriptor icon =
        await BitmapDescriptor.fromAssetImage(ImageConfiguration(), iconPath);

    return icon;
  }

  LatLng _convertWktInLatLong(String coordinates) {
    GeoPoint point = wktGeographic.parse(coordinates) as GeoPoint;

    return new LatLng(point.lat, point.lon);
  }

  _getDialogData(int? id) async {
    print(id);

    String url = baseUrl + "/markers/places/$id";

    Response response = await dio.get(url);

    print(response.data);

    // if (response.data.length) {
    place.markerId = response.data['marker_id'];
    place.name = response.data['name'];
    place.classify = response.data['classify'];
    place.spaceType = response.data['space_type'];
    place.description = response.data['description'];
    // }

    setState(() {
      _openDialog = true;
    });
  }

  _getMarkers(LatLng coordinates) async {
    String currentPosition =
        "POINT(${coordinates.longitude} ${coordinates.latitude})";
    String url = "$baseUrl/markers/$currentPosition";

    Response response = await dio.get(url);

    print(response.data);

    for (Map<String, dynamic> marker in response.data) {
      LatLng coordinates = _convertWktInLatLong(marker['coordinates']);

      _markers.add(Marker(
        icon: await _loadImage(marker['markers_type_id'] == 'PLACE'
            ? marker['category_id']
            : marker['markers_type_id']),
        markerId: MarkerId(marker['id'].toString()),
        position: coordinates,
        onTap: marker['markers_type_id'] == 'PLACE'
            ? () {
                return _getDialogData(marker['id']);
              }
            : () => {},
      ));
    }
  }

  _getMarkersCamera(LatLng coordinates) async {
    String currentPosition =
        "POINT(${coordinates.longitude} ${coordinates.latitude})";
    String url = "$baseUrl/markers/$currentPosition";

    Response response = await dio.get(url);

    print(response.data);

    Set<Marker> _temporaryMarker = {};

    for (Map<String, dynamic> marker in response.data) {
      LatLng coordinates = _convertWktInLatLong(marker['coordinates']);

      _temporaryMarker.add(Marker(
          icon: await _loadImage(marker['markers_type_id'] == 'PLACE'
              ? marker['category_id']
              : marker['markers_type_id']),
          markerId: MarkerId(marker['id'].toString()),
          position: coordinates,
          onTap: marker['markers_type_id'] == 'PLACE'
              ? () {
                  return _getDialogData(marker['id']);
                }
              : () => {}));
    }

    setState(() {
      _markers = _temporaryMarker;
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    Completer<GoogleMapController> _controller = Completer();

    _controller.complete(controller);
  }

  void _selectPosition(LatLng position) async {
    double distanceToCenter = Geolocator.distanceBetween(
      position.latitude,
      position.longitude,
      _center.latitude,
      _center.longitude,
    );

    print(distanceToCenter);

    if (distanceToCenter < 500) {
      return;
    }

    _center = position;

    await _getMarkersCamera(position);
  }

  @override
  void initState() {
    super.initState();
    _getCurrentUserLocation();
  }

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
            mapType: MapType.normal,
            mapToolbarEnabled: false,
            zoomControlsEnabled: false,
            onMapCreated: _onMapCreated,
            markers: _markers,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 17,
            ),
            onCameraMove: (data) => _selectPosition(data.target),
            // onTap: _selectPosition,
          ),
          if (_openDialog != false) ...[
            AlertDialog(
              scrollable: true,
              backgroundColor: place.classify != ''
                  ? acessibilityTypesColors[place.classify!]
                  : Colors.white,
              title: Text("Detalhes do local", textAlign: TextAlign.center),
              content: Column(
                children: [
                  if (place.classify != '') ...[
                    Text(
                      "Classicação",
                      textAlign: TextAlign.left,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(acessibilityTypes[place.classify!]!),
                    SizedBox(
                      height: 20,
                    )
                  ],
                  if (place.name != '') ...[
                    Text(
                      "Nome do lugar",
                      textAlign: TextAlign.left,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(place.name!),
                    SizedBox(
                      height: 10,
                    )
                  ],
                  if (place.spaceType != '') ...[
                    Text(
                      "Tipo de Espaço",
                      textAlign: TextAlign.left,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(spaceTypes[place.spaceType!]!),
                    SizedBox(
                      height: 20,
                    )
                  ],
                  if (place.description != '') ...[
                    Text(
                      "Descrição",
                      textAlign: TextAlign.left,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(place.description!)
                  ]
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => {
                    setState(() {
                      _openDialog = false;
                    })
                  },
                  style: TextButton.styleFrom(
                    primary: Colors.black,
                  ),
                  child: Text("OK"),
                ),
              ],
            )
          ],
          if (_openDialog != true) ...[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Align(
                alignment: Alignment.bottomRight,
                child: FloatingActionButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, appRoutes.getCreateMarker),
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
          ]
        ],
      ],
    );
  }
}
