import 'dart:io';

import 'package:logger/logger.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

const baseUrlProd = "https://grietje.fexhu.com/api";
const baseUrlTest = "https://grietje.fexhu.com/api";

var logger = Logger();

String getBaseUrl() {
  if (kIsWeb) return baseUrlTest;
  try {
    if (Platform.isAndroid || Platform.isIOS) {
      return baseUrlProd;
    }
  } catch (e) {
    logger.e("Error get base url", error: e);
  }
  return baseUrlTest;
}
