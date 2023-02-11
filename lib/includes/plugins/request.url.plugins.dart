import 'dart:convert';
import 'package:http/http.dart' as http;

Future<dynamic> requestURL(String url) async {
  http.Response urlResponse = await http.get(Uri.parse(url));

  if (urlResponse.statusCode == 200) {
    var response = urlResponse.body;
    var decodeResponse = jsonDecode(response);
    return decodeResponse;
  }
}
