import 'package:hans/model/user.dart';
import 'package:hans/service/http_handler.dart';
import 'package:http/http.dart' as http;
import 'package:hans/action/base_action.dart';

class TestAction {
  static Future<bool> pingExec() async {
    try {
      final response = await http.get(
        Uri.parse("${getBaseUrl()}/test/ping"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception("$e");
    }
  }

  static Future<User?> deleteUserExec() async {
    var ret = await HttpHandler.deleteAuth("${getBaseUrl()}/test/user", null);
    if (ret == null) {
      return null;
    }
    User user = User.fromJson(ret);
    if (user.id == 0) {
      return null;
    }
    return user;
  }

  static Future<User?> deleteWalletExec() async {
    var ret = await HttpHandler.deleteAuth("${getBaseUrl()}/test/wallet", null);
    if (ret == null) {
      return null;
    }
    User user = User.fromJson(ret);
    if (user.id == 0) {
      return null;
    }
    return user;
  }
}
  