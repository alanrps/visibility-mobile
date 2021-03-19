import 'package:app_visibility/models/markers.dart';
import 'package:flutter/cupertino.dart';

class Markers with ChangeNotifier {
  List<Marker> _items = [];

  List<Marker> get items {
    return [..._items];
  }

  int get itemsCount {
    return _items.length;
  }

  Marker itemByIndex(int index) {
    return _items[index];
  }
}
