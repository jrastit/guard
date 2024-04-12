import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:hans/action/base_action.dart';
import 'package:hans/model/user.dart';
import 'package:hans/service/http_handler.dart';

var logger = Logger();

http.Client client = http.Client();

class UserAction {
  static Future<User?> loadSessionUser() async {
    var ret = await HttpHandler.postAuth("${getBaseUrl()}/user");
    if (ret == null) {
      return null;
    }
    return User.fromJson(ret);
  }

  static Future<User?> loginExec(login, password) async {
    var ret = await HttpHandler.postAuth("${getBaseUrl()}/user/login", {
      'login': login,
      'password': password,
    });
    if (ret == null) {
      return null;
    }
    return User.fromJson(ret);
  }


  static Future<User?> logoutExec() async {
    var ret = await HttpHandler.postAuth("${getBaseUrl()}/user/logout", null);
    if (ret == null) {
      return null;
    }
    User user = User.fromJson(ret);
    if (user.id == 0) {
      return null;
    }
    return user;
  }

  static Future<User> registerExec(login, password) async {
    var ret = await HttpHandler.putAuth("${getBaseUrl()}/user/register", {
      'login': login,
      'password': password,
    });
    if (ret == null) {
      throw Exception("Register failed");
    }
    return User.fromJson(ret);
  }
}
