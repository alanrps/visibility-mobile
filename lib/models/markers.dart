import 'dart:io';
import 'package:flutter/foundation.dart';

class Marker {
  final double latitude;
  final double longitude;
  final String address;

  Marker({
    @required this.latitude,
    @required this.longitude,
    this.address,
  });
}

class Markers {
  final String id;
  final String title;
  final Marker location;
  final File image;

  Markers({
    @required this.id,
    @required this.title,
    @required this.location,
    @required this.image,
  });
}
