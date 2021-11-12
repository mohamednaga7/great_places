import 'dart:io';

import 'package:flutter/material.dart';
import 'package:great_places/helpers/db_helper.dart';
import 'package:great_places/helpers/location_helper.dart';
import 'package:great_places/models/place.dart';

class GreatPlaces with ChangeNotifier {
  List<Place> _items = [];

  List<Place> get items {
    return [..._items];
  }

  Future<void> addPlace(
      String title, File image, PlaceLocation pickedLocation) async {
    final address = await LocationHelper.getPlaceAddress(
        pickedLocation.latitude, pickedLocation.longitude);
    final newPlace = Place(
        id: DateTime.now().toString(),
        title: title,
        location: PlaceLocation(
            latitude: pickedLocation.latitude,
            longitude: pickedLocation.longitude,
            address: address),
        image: image);
    _items.add(newPlace);
    notifyListeners();
    DBHelper.insert('user_places', {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path,
      'loc_lat': newPlace.location.latitude,
      'loc_lng': newPlace.location.longitude,
      'address': newPlace.location.address
    });
  }

  Future<void> fetchAndSetPlaces() async {
    final dataList = await DBHelper.getData('user_places');
    _items = dataList.map((e) {
      return Place(
          id: e['id'],
          title: e['title'],
          // location: location,
          location: PlaceLocation(
              latitude: e['loc_lat'],
              longitude: e['loc_lng'],
              address: e['address']),
          image: File(e['image']));
    }).toList();
    notifyListeners();
  }

  Place getPlaceById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }
}
