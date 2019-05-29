import 'dart:async';

import 'dart:convert';
import 'package:flutter/material.dart';
 import 'package:http/http.dart' as http;
import 'package:tarbalcom/model/Category.dart';
 
class ServiceProvScreen extends StatefulWidget {
  @override
  _ServiceProvScreenState createState() => new _ServiceProvScreenState();
}

class _ServiceProvScreenState extends State<ServiceProvScreen> {

  List<Provider> listProvinces;
  Provider _selectedProvince;

   Future<List<Provider>> getProvinceList() async {
     final response = await http.get(
      'http://turbalkom.falsudan.com/api/forms/service_providers',
      headers: {
        "Accept": "application/json"
      },
    
    );
        List<Provider> list = parseProvinces(response.body);
           return list;

  }

  List<Provider> parseProvinces(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

    return parsed.map<Provider>((json) => Provider.fromJson(json)).toList();
  }


  @override
  void initState() {

    getProvinceList();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text("service_providers_category"),),
      body: _provinceContainer(),
    );
  }

  Widget _provinceContainer(){
    return new Container(
        child: new InputDecorator(
          decoration: InputDecoration(
              suffixIcon: new Icon(
                Icons.account_balance,
                color: Colors.green,
              ),
              labelText:"service_providers_category"
          ),
          isEmpty: _selectedProvince == null,
          child: new DropdownButtonHideUnderline(
            child: new DropdownButton<Provider>(
              value: _selectedProvince,
              isDense: true,
              onChanged: (Provider newValue) {
                setState(() {
                  _selectedProvince = newValue;
                });
              },
              items: listProvinces?.map((Provider value) {
            return new DropdownMenuItem<Provider>(
              value: value,
              child: new Text(value.category.name, style: new TextStyle(fontSize: 16.0),),
            );
          })?.toList(),
            ),
          ),
        ),
        margin: EdgeInsets.only(bottom: 10.0));
  }

}