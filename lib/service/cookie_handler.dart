import 'dart:io';

import 'package:logger/logger.dart';
import 'package:guard/service/storage_handler.dart';

var logger = Logger();

getSecureStorageCookie() async {
  return await secureStorageHandler.read(key: "cookie");
}

Future<void> setSecureStorageCookie(String value) async {
  await secureStorageHandler.write(key: "cookie", value: value);
}

Future<void> deleteSecureStorageCookie() async {
  await secureStorageHandler.delete(key: "cookie");
}

Map<String, Cookie> parseCookies(String value, Map<String, Cookie> cookies) {
  final regex = RegExp('(?:[^,]|, )+');
  Iterable<Match> rawCookies = regex.allMatches(value);
  for (var rawCookie in rawCookies) {
    try {
      if (rawCookie.group(0) != null) {
        final cookie = Cookie.fromSetCookieValue(rawCookie.group(0)!);
        cookies[cookie.name] = cookie;
      }
    } on Exception {
      // the cookie might be invalid. do something or ignore it.
      continue;
    }
  }

  return cookies;
}

String getHttpCookiesAsString(Map<String, Cookie> cookies) {
  List<String> rawCookies = [];
  cookies.forEach((key, cookie) {
    if (cookie.expires == null || cookie.expires!.isAfter(DateTime.now())) {
      rawCookies.add("$key=${cookie.value}");
    } else {
      logger.w("Cookie $key expired");
    }
  });
  return rawCookies.join('; ');
}

String getHttpCookiesFull(Map<String, Cookie> cookies) {
  List<String> rawCookies = [];
  cookies.forEach((key, cookie) {
    if (cookie.expires == null || cookie.expires!.isAfter(DateTime.now())) {
      rawCookies.add("$cookie");
    } else {
      logger.w("Cookie $key expired");
    }
  });
  return rawCookies.join(',');
}

class CookieHandler {
  Map<String, Cookie> cookies = {};
  bool isCookieLoaded = false;

  CookieHandler() {
    loadCookiesFromSecureStorage().then((value) {
      isCookieLoaded = true;
    }).catchError((e) {
      logger.e('Secure storage error', error: e);
      isCookieLoaded = true;
    });
  }

  Future<void> loadCookiesFromSecureStorage() async {
    String? rawCookie = await getSecureStorageCookie();
    if (rawCookie != null) {
      cookies = parseCookies(rawCookie, cookies);
    }
  }

  Future<void> updateCookies(String rawCookie) async {
    await waitForCookiesLoaded();
    logger.i("updateCookies $rawCookie");
    cookies = parseCookies(rawCookie, cookies);
    logger.i("updatedCookies ${getHttpCookiesFull(cookies)}");
    String? cokiesString = getHttpCookiesFull(cookies);
    logger.i("saveCookiesToSecureStorage $cokiesString");
    await setSecureStorageCookie(cokiesString);
  }

  void saveCookiesToSecureStorage() async {
    await waitForCookiesLoaded();
    String? cokiesString = getHttpCookiesFull(cookies);
    logger.i("saveCookiesToSecureStorage $cokiesString");
    await setSecureStorageCookie(cokiesString);
  }

  void deleteCookiesFromSecureStorage() async {
    await waitForCookiesLoaded();
    await deleteSecureStorageCookie();
  }

  void clearCookies() {
    cookies = {};
    deleteCookiesFromSecureStorage();
  }

  Future<String> getCookies() async {
    await waitForCookiesLoaded();
    return getHttpCookiesAsString(cookies);
  }

  Future<Map<String, DateTime?>> getCookieinfo() async {
    await waitForCookiesLoaded();
    Map<String, DateTime?> cookieInfo = {};
    for (var key in cookies.keys) {
      cookieInfo[key] = cookies[key]?.expires;
    }
    return Future.value(cookieInfo);
  }

  Future<void> waitForCookiesLoaded() async {
    while (!isCookieLoaded) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }
}
