import 'dart:convert';
import 'package:http/http.dart' as http;

class Request {
  static Future<dynamic> requestURL(String url) async {
    http.Response urlResponse = await http.get(Uri.parse(url));
    try {
      if (urlResponse.statusCode == 200) {
        var response = urlResponse.body;
        var decodeResponse = jsonDecode(response);
        return decodeResponse;
      } else {
        return "Error Occured!";
      }
    } catch (e) {
      return "Error Occured!";
    }
  }
}
