import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:hans/service/cookie_handler.dart';
import 'package:hans/service/state_service.dart';

http.Client client = http.Client();

Logger logger = Logger();

class HttpHandler {
  static CookieHandler? cookieHandler = isMobile ? CookieHandler() : null;
  static Future<String?> get cookie async => await cookieHandler?.getCookies();

  static Future<Map<String, dynamic>?> httpAuth(proto, url,
      [Map<String, dynamic>? body, auth = true]) async {
    try {
      logger.i("$proto $url $body $auth");
      String? sessionCookie =
          auth ? await cookie.timeout(const Duration(seconds: 60)) : null;
      logger.i("Session cookies $sessionCookie");
      http.Response response;
      Map<String, String> headers = <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      };
      if (sessionCookie != null) {
        headers.addAll(<String, String>{
          'cookie': sessionCookie,
        });
      }
      switch (proto) {
        case 'get':
          final request = http.Request('GET', Uri.parse(url));
          request.headers.addAll(headers);
          request.body = jsonEncode({});
          http.StreamedResponse streamedResponse =
              await client.send(request).timeout(const Duration(seconds: 5));
          response = await http.Response.fromStream(streamedResponse);
        case 'post':
          response = await client
              .post(
                Uri.parse(url),
                headers: headers,
                body: jsonEncode(body ?? {'empty': true}),
              )
              .timeout(const Duration(seconds: 10));
        case 'put':
          response = await client
              .put(
                Uri.parse(url),
                headers: headers,
                body: jsonEncode(body ?? {}),
              )
              .timeout(const Duration(seconds: 10));
        case 'delete':
          response = await client
              .delete(
                Uri.parse(url),
                headers: headers,
                body: jsonEncode(body ?? {}),
              )
              .timeout(const Duration(seconds: 10));
        default:
          return null;
      }
      if (response.statusCode == 200) {
        if (isMobile) {
          String? cookie = response.headers['set-cookie'];
          if (cookie != null) await cookieHandler?.updateCookies(cookie);
        }
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else if (response.statusCode == 401) {
        return null;
      } else {
        logger.e('Error requesting url $proto $url ${response.statusCode}, ${response.body}');
        return null;
      }
    } on http.ClientException catch (e, stacktrace) {
      logger.e('Clientexception, $proto $url',
          error: e, stackTrace: stacktrace);
      return null;
    } catch (e, stackTrace) {
      logger.e('Failed to load $proto $url', error: e, stackTrace: stackTrace);
      return null;
    }
  }

  static Future<Map<String, dynamic>?> getAuth(url) async {
    return await httpAuth('get', url);
  }

  static Future<Map<String, dynamic>?> postAuth(url, [body]) async {
    return await httpAuth('post', url, body);
  }

  static Future<Map<String, dynamic>?> putAuth(url, [body]) async {
    return await httpAuth('put', url, body);
  }

  static Future<Map<String, dynamic>?> deleteAuth(url, [body]) async {
    return await httpAuth('delete', url, body);
  }

  static void clearCookies() {
    cookieHandler?.clearCookies();
  }
}
