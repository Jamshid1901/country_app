import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:osm_nominatim/osm_nominatim.dart';
import 'package:weather/pages/weathers_home.dart';
import 'package:weather/store/store.dart';

import '../repository/main_repository.dart';

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
        title: const Text("Google map"),
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        myLocationEnabled: true,
        onTap: (location) async {
          final reverseSearchResult = await Nominatim.reverseSearch(
            lat: location.latitude,
            lon: location.longitude,
            addressDetails: true,
            extraTags: true,
            nameDetails: true,
            language: "en"
          );
          print(reverseSearchResult.address);
          var data = await MainRepository.getInformationWeather(
              name: reverseSearchResult.address?["country"]);
          if (data["error"] == null) {
            await LocalStore.setCountry(
                reverseSearchResult.address?["country"]);
            // ignore: use_build_context_synchronously
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const WeathersHome()),
                (route) => false);
          } else {
            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  data["error"].toString(),
                ),
              ),
            );
          }
        },
        initialCameraPosition:
            CameraPosition(target: LatLng(widget.lat, widget.lon)),
      ),
    );
  }
}
