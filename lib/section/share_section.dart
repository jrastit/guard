import 'package:hans/model/user.dart';
import 'package:hans/service/http_handler.dart';
import 'package:hans/service/state_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:hans/widget/user_widget.dart';
import 'package:tekflat_design/tekflat_design.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';

class SharingSection extends StatefulWidget {
  final Function(AppState appState) setAppState;
  final User? user;
  const SharingSection({super.key});

  @override
  State<SharingSection> createState() => _SharingSection();
}

class _SharingSection extends State<SharingSection> {
  Map<String, DateTime?>? _cookies;
  var currentLocation;

  MapController mapController = MapController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('MapBox')),
        body: FlutterMap(
          mapController: mapController,
          options: const MapOptions(
              initialCenter: LatLng(56.946285, 24.105078),
              minZoom: 6,
              maxZoom: 20),
          children: [
            TileLayer(
              urlTemplate:'url',
              // userAgentPackageName: 'com.example.app',
              additionalOptions: {'accessToken':'token' },
            ),
            RichAttributionWidget(
              attributions: [
                TextSourceAttribution(
                  'OpenStreetMap contributors',
                  onTap: () => launchUrl(
                      Uri.parse('https://openstreetmap.org/copyright')),
                ),
              ],
            ),
            CurrentLocationLayer(
              // followOnLocationUpdate: FollowOnLocationUpdate.always,
              turnOnHeadingUpdate: TurnOnHeadingUpdate.never,
              style: const LocationMarkerStyle(
                marker: DefaultLocationMarker(
                  // color: Colors.blue,
                  child: Icon(
                    Icons.navigation,
                    color: Colors.white,
                  ),
                ),
                markerSize: Size(40, 40),
                markerDirection: MarkerDirection.heading,
              ),
            ),
            TextButton(
                child: Text("Go home"),
                onPressed: () {
                  Geolocator.getCurrentPosition(
                          desiredAccuracy: LocationAccuracy.high)
                      .then((pickedCurrentLocation) {
                    setState(() {
                      currentLocation = pickedCurrentLocation;
                    });
                    mapController.move(
                        LatLng(currentLocation.latitude,
                            currentLocation.longitude),
                        6);
                  });
                })
          ],
        ));
  }
}
  }
}