import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:h3_flutter/h3_flutter.dart';

const h3Factory = H3Factory();
final h3 = h3Factory.load();
// Get hexagons in specified triangle.
final hexagons = h3.polyfill(
  resolution: 5,
  coordinates: [
    const GeoCoord(lon: 20.4522, lat: 54.7104),
    const GeoCoord(lon: 37.6173, lat: 55.7558),
    const GeoCoord(lon: 39.7015, lat: 47.2357),
  ],
);


class H3 {
  H3._();

  static getH3Center(GeoPoint point) {
    BigInt h3Index =
        h3.geoToH3(GeoCoord(lon: point.longitude, lat: point.latitude), 11);
    GeoCoord coord = h3.h3ToGeo(h3Index);
    return (h3Index, GeoPoint(latitude: coord.lat, longitude: coord.lon));
  }
}
