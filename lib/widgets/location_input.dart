import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:great_places/helpers/location_helper.dart';
import 'package:great_places/models/place.dart';
import 'package:great_places/screens/map_screen.dart';
import 'package:location/location.dart';

class LocationInput extends StatefulWidget {
  final Function selectPlace;
  const LocationInput(this.selectPlace, {Key? key}) : super(key: key);

  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  Future<void> _getCurrentUserLocation() async {
    final locData = await Location().getLocation();
    if (locData.longitude != null && locData.latitude != null) {
      _showPreview(locData.latitude!, locData.longitude!);
      widget.selectPlace(locData.latitude, locData.longitude);
    }
  }

  void _showPreview(double lat, double lng) {
    setState(() {
      _previewImageUrl = LocationHelper.generateLocationPreviewImage(
          latitude: lat, longitude: lng);
    });
  }

  Future<void> _selectOnMap() async {
    final locData = await Location().getLocation();
    if (locData.longitude != null && locData.latitude != null) {
      final LatLng? selectedLocation = await Navigator.of(context).push(
          MaterialPageRoute(
              fullscreenDialog: true,
              builder: (ctx) => MapScreen(
                  initialLocation: PlaceLocation(
                      latitude: locData.latitude!,
                      longitude: locData.longitude!,
                      address: ''))));
      if (selectedLocation == null) {
        return;
      }
      _showPreview(selectedLocation.latitude, selectedLocation.longitude);
      widget.selectPlace(selectedLocation.latitude, selectedLocation.longitude);
    }
  }

  String? _previewImageUrl;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            alignment: Alignment.center,
            height: 170,
            width: double.infinity,
            decoration:
                BoxDecoration(border: Border.all(width: 1, color: Colors.grey)),
            child: _previewImageUrl == null
                ? const Text(
                    'No Location Chosen',
                    textAlign: TextAlign.center,
                  )
                : Image.network(
                    _previewImageUrl!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  )),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
              onPressed: _getCurrentUserLocation,
              icon: const Icon(Icons.location_on),
              label: const Text('Current Location'),
              style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(
                      Theme.of(context).primaryColor)),
            ),
            TextButton.icon(
              onPressed: _selectOnMap,
              icon: const Icon(Icons.map),
              label: const Text('Select on Map'),
              style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(
                      Theme.of(context).primaryColor)),
            )
          ],
        )
      ],
    );
  }
}
