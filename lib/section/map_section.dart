import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:intl/intl.dart';
import 'package:tekflat_design/tekflat_design.dart';
import 'dart:developer' as developer;

final dateFormat = DateFormat('yyyy-MM-dd hh:mm:ss');

class MapSection extends StatefulWidget {
  const MapSection({super.key});

  @override
  State<StatefulWidget> createState() => _MapSection();
}

class _MapSection extends State<MapSection> {
  /*
  MapController mapController = MapController.withUserPosition(
      trackUserLocation: const UserTrackingOption(
    enableTracking: true,
    unFollowUser: false,
  ));
  */
  // default constructor
  MapController mapController = MapController.withUserPosition(
      trackUserLocation: const UserTrackingOption(
    enableTracking: true,
    unFollowUser: false,
  ));

  GeoPoint? _location;
  DateTime _now = DateTime.now();
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) async {
      //GeoPoint? location = mapController.initPosition;
      developer.log("Looking for location");
      GeoPoint? location;
      try {
        //await mapController.currentLocation();
        location = await mapController.myLocation();
        await mapController.goToLocation(location);
        await mapController.addMarker(
          location,
          markerIcon: const MarkerIcon(
              icon: Icon(
            Icons.location_on,
            color: Colors.green,
          )),
        );
        await mapController.drawCircle(CircleOSM(
            key: "circle${location.latitude}",
            centerPoint: location,
            radius: 10,
            color: Colors.red,
            strokeWidth: 10));
      } catch (e) {
        developer.log("location error");
      }
      developer.log("location found");
      setState(() {
        if (location != null) {
          _location = location;
        }

        _now = DateTime.now();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      TekTypography(
          text:
              "${dateFormat.format(_now)}\nLongitude : ${_location?.longitude}\nLatitude ${_location?.latitude}"),
      SizedBox(
        height: TekResponsiveConfig().currentWidth,
        child: OSMFlutter(
            controller: mapController,
            osmOption: OSMOption(
              userTrackingOption: const UserTrackingOption(
                enableTracking: true,
                unFollowUser: false,
              ),
              zoomOption: const ZoomOption(
                initZoom: 18,
                minZoomLevel: 3,
                maxZoomLevel: 19,
                stepZoom: 1.0,
              ),
              userLocationMarker: UserLocationMaker(
                personMarker: const MarkerIcon(
                  icon: Icon(
                    Icons.location_history_rounded,
                    color: Colors.red,
                    size: 48,
                  ),
                ),
                directionArrowMarker: const MarkerIcon(
                  icon: Icon(
                    Icons.double_arrow,
                    size: 48,
                  ),
                ),
              ),
              roadConfiguration: const RoadOption(
                roadColor: Colors.yellowAccent,
              ),
              /* markerOption: MarkerOption(
                  defaultMarker: const MarkerIcon(
                icon: Icon(
                  Icons.person_pin_circle,
                  color: Colors.blue,
                  size: 56,
                ),
              )), */
            )),
      ),
    ]);
  }
}
