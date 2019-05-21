import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:tarbalcom/model/Category.dart';


class ContactService {
  static const _serviceUrl = 'http://turbalkom.falsudan.com/api/forms/service_providers';
  static final _headers = {'success': 'application/json'};

  Future<Category> createContact(Category category) async {
    try {
      String json = _toJson(category);
      final response =
      await http.get(_serviceUrl, headers: _headers);
      var c = _fromJson(response.body);
      return c;
    } catch (e) {
      print('Server Exception!!!');
      print(e);
      return null;
    }
  }

  Category _fromJson(String jsonContact) {
    Map<String, dynamic> map = json.decode(jsonContact);
    var category = new Category();
    category.id = map['id'];
    category.name = map['name'];

    return category;
  }

  String _toJson(Category category) {
    var mapData = new Map();
    mapData["id"] = category.id;
    mapData["name"] = category.name;

    String jsonContact = json.encode(mapData);
    return jsonContact;
  }
}
