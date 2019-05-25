import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tarbalcom/model/Category.dart';
 
class Services {
  static const String url = "http://turbalkom.falsudan.com/api/forms/service_providers";

  static Future<List<Category>> getPhotos() async {
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        List<Category> list = parsePhotos(response.body);
        return list;
      } else {
        throw Exception("Error");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static List<Category> parsePhotos(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Category>((json) => Category.fromJson(json)).toList();
  }
}
