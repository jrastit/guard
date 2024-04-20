import 'dart:async';

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:hans/action/contract_action.dart';
import 'package:intl/intl.dart';
import 'package:tekflat_design/tekflat_design.dart';


final dateFormat = DateFormat('yyyy-MM-dd hh:mm:ss');


class LocationSection extends StatefulWidget {
  const LocationSection({
    super.key,
  });
  @override
  State<StatefulWidget> createState() => _LocationSection();
}

class _LocationSection extends State<LocationSection> {



  Future<LocationData?> _currentLocation() async {
    logger.d("Getting location");
    bool serviceEnabled = false;
    PermissionStatus permissionGranted;

    Location location = Location();
    logger.d("Check Service is enabled");
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      logger.d("Service is not enabled");
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        logger.d("Service is not requested");
        return null;
      }
    }
    logger.d("Service is enabled");

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }
    logger.d("Location ready to get");
    LocationData myLocation = await location.getLocation();
    logger.d("Location is ${myLocation.latitude} ${myLocation.longitude}");
    return myLocation;
  }

  // default constructor

  Timer? _timer;

  _LocationSection();


  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  
  @override
  Widget build(BuildContext context) {
    
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      
      SizedBox(
          height: TekResponsiveConfig().currentWidth,
          width: TekResponsiveConfig().currentWidth,
          child: FutureBuilder<LocationData?>(
            future: _currentLocation(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapchat) {
              if (snapchat.hasData) {
                final LocationData currentLocation = snapchat.data;
                return Column(
                  children: [
                    Text("Latitude: ${currentLocation.latitude}"),
                    Text("Longitude: ${currentLocation.longitude}"),
                    
                  ],
                );
              }
              return const Center(child: CircularProgressIndicator());
            },
          )),
      //Sharebutton
    ]);
  }
}
