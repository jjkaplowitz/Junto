import 'package:http/http.dart' as http;
import 'dart:convert';

Future Getdata(url) async {
  http.Response Response = await http.get(Uri.parse(url));
  String ret = jsonDecode(Response.body)['Query'];

  return ret;
}
