

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  final double lat;
  final double lon;

  const MapPage({Key? key, required this.lat, required this.lon})
      : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Google map"),
      ),
      body: GoogleMap(
        initialCameraPosition:
            CameraPosition(target: LatLng(widget.lat, widget.lon)),
      ),
    );
  }
}
