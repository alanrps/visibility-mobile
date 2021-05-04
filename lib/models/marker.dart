// import 'dart:io';
import 'package:flutter/foundation.dart';

class Marker {
  int userId;
  String typeMarkerId;
  double latitude;
  double longitude;
  String description;
  String details;
  String deficiency;
  //Lugar
  String name = '';
  String classify;
  String detailsPlace;
  String descriptionPlace;

  // set userId(int userId) {
  //   this.userId = userId;
  // }

  // set typeMarkerId(String typeMarkerId) {
  //   this.typeMarkerId = typeMarkerId;
  // }

  // set latitude(double latitude) {
  //   this.latitude = latitude;
  // }

  // set longitude(double longitude) {
  //   this.longitude = longitude;
  // }

  // set description(String description) {
  //   this.description = description;
  // }
}

// class TypeMarkers extends Marker {

// }

class Place extends Marker {
  // set name(String nameValue) {
  //   this.name = nameValue;
  // }

  // set type(String typeValue) {
  //   this.type = typeValue;
  // }

  // set classify(String classifyValue) {
  //   this.classify = classifyValue;
  // }

  // set details(String detailsValue) {
  //   this.details = detailsValue;
  // }

  // set description(String descriptionValue) {
  //   this.description = descriptionValue;
  // }
}

class Markers {
  final List<Marker> location;

  Markers({
    @required this.location,
  });
}
