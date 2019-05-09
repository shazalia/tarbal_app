import 'dart:convert';
import "package:flutter/material.dart";
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
void main() => runApp(MaterialApp(
  title: "Hospital Management",
  home: ServiceProvScreen(),
));
class  ServiceProvScreen extends StatefulWidget {
  @override
  _ServiceProvScreenState createState() => _ServiceProvScreenState();
}
class _ServiceProvScreenState extends State<ServiceProvScreen> {
  String _mySelection;

  final String url = "http://turbalkom.falsudan.com/api/forms/service_providers";

  List data = List(); //edited line

  Future<String> getSWData() async {
    var res = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    var resBody = json.decode(res.body);

    setState(() {
      data = resBody;
    });

    print(resBody);

    return "Sucess";
  }


  @override
  void initState() {
    super.initState();
    this.getSWData();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("مزردو الخدمات"),
      ),
      body: new Center(
        child: new DropdownButton(
          items: data.map((item) {
            return new DropdownMenuItem(
              child: new Text(item['service_providers_category']),
              value: item['id'].toString(),
            );
          }).toList(),
          onChanged: (newVal) {
            setState(() {
              _mySelection = newVal;
            });
          },
          value: _mySelection,
        ),
      ),
    );
  }
}