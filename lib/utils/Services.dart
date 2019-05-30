import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tarbalcom/model/Data.dart';
  
class Services {
  static const String url = "http://turbalkom.falsudan.com/api/forms/service_providers";

  static Future<List<Data>> getPhotos() async {
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        List<Data> list = parsePhotos(response.body);
        return list;
      } else {
        throw Exception("Error");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static List<Data> parsePhotos(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Data>((json) => Data.fromJson(json)).toList();
  }
}
