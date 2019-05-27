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
     List<Category> listCategory;

 var map;
   Category _selectedCategory;
  final String url = "http://turbalkom.falsudan.com/api/forms/service_providers";
Future<Category> getCategory() async {
    var res = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    var resBody = json.decode(res.body)["data"];
  
      setState(() {
      listCategory = map;
    });

    print(resBody);

    return Category.fromJson(resBody);
  }
  
  
  
    
 
   
  
  @override
  void initState() {
 
    getCategory();

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
                color: Colors.pink,
              ),
              labelText:"فئة مزودو الخدمات"
          ),
          isEmpty: _selectedCategory == null,
          child: new DropdownButtonHideUnderline(
            child: new DropdownButton<Category>(
              value: _selectedCategory,
              isDense: true,
              onChanged: (Category newValue) {
                setState(() {
                  _selectedCategory = newValue;
                });
              },
              items: listCategory?.map((Category value) {
            return new DropdownMenuItem<Category>(
              value: value,
              child: new Text(value.prov.name
              ,style: new TextStyle(fontSize: 16.0),),
            
            );
          })?.toList(),

              
            ),
          ),
        ),
        margin: EdgeInsets.only(bottom: 10.0));
  }

}