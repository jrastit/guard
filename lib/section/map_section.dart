import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:hans/action/contract_action.dart';
import 'package:hans/model/nft.dart';
import 'package:hans/model/user.dart';
import 'package:hans/service/h3.dart';
import 'package:hans/service/state_service.dart';
import 'package:hans/widget/loading_widget.dart';
import 'package:intl/intl.dart';
import 'package:tekflat_design/tekflat_design.dart';

import 'dart:developer' as developer;

final dateFormat = DateFormat('yyyy-MM-dd hh:mm:ss');

class MapSection extends StatefulWidget {
  final String address;
  final String contract;
  final User user;
  const MapSection({
    super.key,
    required this.address,
    required this.contract,
    required this.user,
  });
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
    )
  );

  GeoPoint? _location;
  DateTime _now = DateTime.now();
  Timer? _timer;
  bool loading = false;
  List<NFT> _nfts = [];

  _MapSection();

  loadNFTs() async {
    if (_location == null || _location?.latitude == 0 || _location?.longitude == 0) {
      return;
    }
    List<NFT> nfts = await ContractAction.loadNFTs(widget.address, _location?.latitude, _location?.longitude, 5, widget.contract);
    logger.d(nfts);
    setState(() {
      _nfts = nfts;
    });
  }

  publishLocation() async {
    GeoPoint? location = await mapController.myLocation();
    if (_location == null || _location?.latitude == 0 || _location?.longitude == 0) {
      return;
    }
    await ContractAction.createNFTExec(
      widget.address, 
      widget.user.login, 
      "${widget.user.login} was here at ${dateFormat.format(DateTime.now())}", 
      "https://greitje.fexhu.com", 
      _location?.latitude, 
      _location?.longitude, 
      widget.contract
      );
    setState(() {
      loading = false;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  _redraw(location) async {
    try {
        loadNFTs();
        await mapController.goToLocation(location);


        // time = Random().nextInt(100);
        var (BigInt h3Index, GeoPoint center) =
            H3.getH3Center(location);
        developer.log("center $center");
        developer.log("point $location");
        Color color = Colors.red;
        Color colorTime = Colors.blue;
        
        var boundaryList = h3.h3ToGeoBoundary(h3Index);
        var i = 0;
        for (i = 0; i < boundaryList.length; i++) {
          await mapController.drawCircle(CircleOSM(
            key: "${i}boundary",
            centerPoint: GeoPoint(
                latitude: boundaryList[i].lat, longitude: boundaryList[i].lon),
            radius: 1,
            color: Colors.black,
            strokeWidth: 10,
          ));

        }
        logger.d("draw nfts $_nfts");
        for (var nft in _nfts) {
          logger.d("draw nft $nft");
          logger.d("draw nft position ${nft.position}");
          logger.d("draw nft position ${nft.position.split(',')[0].substring(1)}");
          logger.d("draw nft position ${nft.position.split(',')[1].substring(0, nft.position.split(',')[1].length - 1)}");
          double latitude = double.parse(nft.position.split(',')[0].substring(1));
          double longitude = double.parse(nft.position.split(',')[1].substring(0, nft.position.split(',')[1].length - 1));
          logger.d("draw nft $latitude $longitude");
          GeoPoint geopoint = GeoPoint(
            latitude: latitude,
            longitude: longitude,
          );
          await mapController.drawCircle(CircleOSM(
            key: "nft${nft.id}",
            centerPoint: geopoint,
            radius: 5,
            color: Colors.green,
            strokeWidth: 10,
          ));
        }
        // await mapController.drawCircle(CircleOSM(
        //   key: "1circle",
        //   centerPoint: location,
        //   radius: 3,
        //   color: colorTime,
        //   strokeWidth: 10,
        // ));
        // await mapController.drawCircle(CircleOSM(
        //   key: "circle$h3Index",
        //   centerPoint: center,
        //   radius: 5,
        //   color: color,
        //   strokeWidth: 10,
        // ));
        // await mapController.drawCircle(CircleOSM(
        //   key: "2circle",
        //   centerPoint: center,
        //   radius: 1,
        //   //borderColor: Colors.black,
        //   color: Colors.black,
        //   strokeWidth: 10,
        // ));

        developer.log("location found");
      } catch (e, stacktrace) {
        developer.log("location error $e");
        developer.log(e.toString(), stackTrace: stacktrace);
      }
  }

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer t) async {
      //GeoPoint? location = mapController.initPosition;
      developer.log("Looking for location");
      GeoPoint? location;
      //await mapController.currentLocation();
      try {
        location = await mapController.myLocation();
        await _redraw(location);
      } catch (e) {
        developer.log("location error $e");
      }
        
      
      setState(() {
        _location = location;
        _now = DateTime.now();
      });
    });
  }

  void _openPopUpShareLoc(){
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          alignment: Alignment.center,
          scrollable: false,
          title: const Text('Share'),
          content: SingleChildScrollView(
            child: Column(
              //shrinkWrap: true,
              children: [
                Container(
                  width: 300,
                  height: 400,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: ExactAssetImage(getAsset("HANS.png")),
                      fit: BoxFit.cover
                      ),
                    )
                  ),
                ],
              ),
            ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Copy Link'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  loading = false;
                });
                publishLocation();
                Navigator.pop(context);
              },
              child: const Text('Send'),
            ),
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _openPopUpSharePic(){
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          alignment: Alignment.center,
          scrollable: false,
          title: const Text('Share'),
          content: SingleChildScrollView(
            child: Column(
              //shrinkWrap: true,
              children: [
                Container(
                  width: 300,
                  height: 400,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: ExactAssetImage(getAsset("HANS.png")),
                      fit: BoxFit.cover
                      ),
                    )
                  ),
                ],
              ),
            ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Copy Link'),
            ),
            TextButton(
              onPressed: () {
                // Send them to your email maybe?
                //var email = emailController.text;
                //var message = messageController.text;
                Navigator.pop(context);
              },
              child: const Text('Send'),
            ),
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const LoadingWidget(title: 'Minting NFT...');
    }
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      TekTypography(
          text:
              "${dateFormat.format(_now)}\nLongitude : ${_location?.longitude}\nLatitude ${_location?.latitude}"),
      SizedBox(
        height: TekResponsiveConfig().currentWidth,
        width: TekResponsiveConfig().currentWidth,
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
        //Sharebutton
        TekVSpace.p18,
        TekButton( //Share Location of map screenshot
          key: const Key('shareLocButton'),
          text: 'Share Location',
          width: TekResponsiveConfig().currentWidth/2,
          type: TekButtonType.primary,
          onPressed: _openPopUpShareLoc,
        ),
        TekButton( //Share mobile picture/camera picture
          key: const Key('sharePicButton'),
          text: 'Share Picture',
          width: TekResponsiveConfig().currentWidth/2,
          type: TekButtonType.primary,
          onPressed: _openPopUpSharePic,
        ),
      ]
    );
  }
}
