import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:great_places/models/place.dart';

class MapScreen extends StatefulWidget {
  final PlaceLocation initialLocation;
  final bool? isSelecting;
  const MapScreen(
      {Key? key, required this.initialLocation, this.isSelecting = false})
      : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _pickedlocation;

  void _selectLocation(LatLng position) {
    setState(() {
      _pickedlocation = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Map'),
        actions: [
          if (widget.isSelecting != null &&
              widget.isSelecting == true &&
              _pickedlocation != null)
            IconButton(
                onPressed: () {
                  Navigator.of(context).pop(_pickedlocation);
                },
                icon: const Icon(Icons.check))
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
            target: LatLng(widget.initialLocation.latitude,
                widget.initialLocation.longitude),
            zoom: 17),
        onTap: widget.isSelecting != null ? _selectLocation : null,
        markers: (_pickedlocation == null && widget.isSelecting == true)
            ? {}
            : {
                Marker(
                    markerId: const MarkerId('m1'),
                    position: _pickedlocation ??
                        LatLng(widget.initialLocation.latitude,
                            widget.initialLocation.longitude))
              },
      ),
    );
  }
}
