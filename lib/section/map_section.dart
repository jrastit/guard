import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geopoint3/geopoint3.dart';
import 'package:hans/action/contract_action.dart';
import 'package:hans/model/nft.dart';
import 'package:hans/model/user.dart';
import 'package:hans/popup/share_popup.dart';
import 'package:hans/widget/loading_widget.dart';
import 'package:intl/intl.dart';
import 'package:tekflat_design/tekflat_design.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:latlong2/latlong.dart';

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
  GeoPoint? _location = GeoPoint(latitude: 48.866667, longitude: 2.333333);
  DateTime _now = DateTime.now();
  Timer? _timer;
  bool loading = false;

  late MapController mapController;

  List<NFT> _nfts = [];

  // default constructor

  loadNFTs() async {
    if (_location == null ||
        _location?.latitude == 0 ||
        _location?.longitude == 0) {
      return;
    }
    List<NFT> nfts = await ContractAction.loadNFTs(widget.address,
        _location?.latitude, _location?.longitude, 5, widget.contract);
    logger.d(nfts);
    setState(() {
      _nfts = nfts;
    });
  }

  _MapSection();

  publishLocation() async {
    if (_location == null ||
        _location?.latitude == 0 ||
        _location?.longitude == 0) {
      return;
    }
    await ContractAction.createNFTExec(
        widget.address,
        widget.user.login,
        "${widget.user.login} was here at ${dateFormat.format(DateTime.now())}",
        "https://grietje.fexhu.com/images/HANS.png",
        _location?.latitude,
        _location?.longitude,
        widget.contract);
    setState(() {
      loading = false;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<GeoPoint?> getCurrentLocation() async {
    logger.d("Getting location");
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    logger.d("location service enabled: $serviceEnabled");
    if (!serviceEnabled) {
      logger.d("Service is not enabled");
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Location Service Disabled'),
          content: const Text('Please enable location services.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return null;
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      logger.d("Permission is denied");
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Location Permission Denied'),
            content: const Text('Please grant location permission.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
        return null;
      }
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    mapController.move(
      LatLng(position.latitude, position.longitude),
      15.0,
    );
    return GeoPoint(
      latitude: position.latitude,
      longitude: position.longitude,
    );
  }

  Future _updateLocation() async {
    var location = await getCurrentLocation();
    setState(() {
      _location = location;
      _now = DateTime.now();
    });
    await loadNFTs();
  }

  OverlayImage nftToOverlay (NFT nft) {
    double latitude = double.parse(nft.position.split(',')[0].substring(1));
    double longitude = double.parse(nft.position.split(',')[1].substring(0, nft.position.split(',')[1].length - 1));
    return OverlayImage(
      bounds: LatLngBounds(
        LatLng(latitude - 0.0001, longitude - 0.0001),
        LatLng(latitude + 0.0001, longitude + 0.0001),
      ),
      imageProvider: NetworkImage(nft.imageURI),
    );
  }

  List<OverlayImage> getNFTMarkers() {
    return _nfts.map((nft) => nftToOverlay(nft)).toList();
  }

  @override
  void initState() {
    super.initState();
    mapController = MapController();
    _updateLocation();
    _timer = Timer.periodic(const Duration(seconds: 10), (Timer t) async {
      await _updateLocation();
    });
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
          child: FlutterMap(
              mapController: mapController,
              options: MapOptions(
                initialCenter: LatLng(
                  _location?.latitude ?? 0.0,
                  _location?.longitude ?? 0.0,
                ),
                initialZoom: 15.0,
              ),
              children: [
                TileLayer(
                  tileProvider: CancellableNetworkTileProvider(),
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                ),
                MarkerLayer(
                  markers: [
                    if (_location != null)
                      Marker(
                        point: LatLng(
                          _location!.latitude ?? 0.0,
                          _location!.longitude ?? 0.0,
                        ),
                        child: const Icon(Icons.location_on),
                      ),
                  ],
                ),
                OverlayImageLayer(
                  overlayImages: getNFTMarkers(),
                ),
              ])),
      //Sharebutton
      TekVSpace.p18,
      TekButton(
        //Share Location of map screenshot
        key: const Key('shareLocButton'),
        text: 'Share Location',
        width: TekResponsiveConfig().currentWidth / 2,
        type: TekButtonType.primary,
        onPressed: () => openPopUpShareLoc(context, publishLocation),
      ),
      TekVSpace.p18,
      TekButton(
        //Share mobile picture/camera picture
        key: const Key('sharePicButton'),
        text: 'Share Picture',
        width: TekResponsiveConfig().currentWidth / 2,
        type: TekButtonType.primary,
        onPressed: () => openPopUpSharePic(context),
      ),
    ]);
  }
}
