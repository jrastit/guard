import 'package:flutter/foundation.dart';

enum AppState {
  biometric,
  retrieveSession,
  login,
  retrieveWallet,
  wallet,
  map,
  camer,
  preview,
}

final bool isMobile = defaultTargetPlatform == TargetPlatform.android ||
    defaultTargetPlatform == TargetPlatform.iOS;

getAsset(String str) {
  return isMobile ? "assets/$str" : str;
}
