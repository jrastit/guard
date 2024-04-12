import 'package:http/http.dart' as http;
import 'package:hans/action/base_action.dart';

class TestAction {
  static Future<bool> pingExec() async {
    try {
      final response = await http.get(
        Uri.parse("${getBaseUrl()}/ping"),
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
}
  