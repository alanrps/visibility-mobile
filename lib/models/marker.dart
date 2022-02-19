class Marker {
  int? userId;
  String? typeMarker;
  double? latitude;
  double? longitude;
  String? description;
  String? details;
  String? deficiency;
  String? category;
  //Lugar
  String? name;
  String? classify;
  String? detailsPlace;
  String? spaceType;
  String? descriptionPlace;
}

// class TypeMarkers extends Marker {
// }

class Place extends Marker {
}

class Markers {
  final List<Marker> location;

  Markers({
    required this.location,
  });
}
