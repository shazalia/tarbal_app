import 'dart:convert';
import "package:flutter/material.dart";
import 'dart:async';
import 'package:http/http.dart' as http;
void main() => runApp(MaterialApp(
  title: "Hospital Management",
  home: ServiceProvScreen(),
));

class ServiceProvScreen extends StatefulWidget {
  @override
  _ServiceProvScreenState createState() => _ServiceProvScreenState();
}

class _ServiceProvScreenState extends State<ServiceProvScreen> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

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

    return "success";
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
        title: Text("طلب مزرد خدمة"),
      ),
      body: new SafeArea(
        top: false,
        bottom: false,
        child: new Form(
            key: _formKey,
            autovalidate: true,
            child: new ListView(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                children: <Widget>[
         new DropdownButton(
          items: data.map((item) {
            return new DropdownMenuItem(
              child: new Text(item['name']),
              value: item['id'].toString(),
            );
          }).toList(),
          hint: Text("مزوِّدو الخدمة"),
          onChanged: (newVal) {
            setState(() {
              _mySelection = newVal;
            });
          },
          value: _mySelection,
        ),
                  new DropdownButton(
                    items: data.map((item) {
                      return new DropdownMenuItem(
                        child: new Text(item['name']),
                        value: item['id'].toString(),
                      );
                    }).toList(),
                    hint: Text("مساحة المزرعة بالفدان"),
                    onChanged: (newVal) {
                      setState(() {
                        _mySelection = newVal;
                      });
                    },
                    value: _mySelection,
                  ),
                  new DropdownButton(
                    items: data.map((item) {
                      return new DropdownMenuItem(
                        child: new Text(item['name']),
                        value: item['id'].toString(),
                      );
                    }).toList(),
                    hint: Text("اعداد ثروات المزرعة"),
                    onChanged: (newVal) {
                      setState(() {
                        _mySelection = newVal;
                      });
                    },
                    value: _mySelection,
                  ),
                  new DropdownButton(
                    items: data.map((item) {
                      return new DropdownMenuItem(
                        child: new Text(item['name']),
                        value: item['id'].toString(),
                      );
                    }).toList(),
                    hint: Text("طريقة الري"),
                    onChanged: (newVal) {
                      setState(() {
                        _mySelection = newVal;
                      });
                    },
                    value: _mySelection,
                  ),
                  new DropdownButton(
                    items: data.map((item) {
                      return new DropdownMenuItem(
                        child: new Text(item['name']),
                        value: item['id'].toString(),
                      );
                    }).toList(),
                    hint: Text("مصدر الري"),
                    onChanged: (newVal) {
                      setState(() {
                        _mySelection = newVal;
                      });
                    },
                    value: _mySelection,
                  ),
                  new DropdownButton(
                    items: data.map((item) {
                      return new DropdownMenuItem(
                        child: new Text(item['name']),
                        value: item['id'].toString(),
                      );
                    }).toList(),
                    hint: Text("مصدر الطاقة"),
                    onChanged: (newVal) {
                      setState(() {
                        _mySelection = newVal;
                      });
                    },
                    value: _mySelection,
                  ),
                  new DropdownButton(
                    items: data.map((item) {
                      return new DropdownMenuItem(
                        child: new Text(item['name']),
                        value: item['id'].toString(),
                      );
                    }).toList(),
                    hint: Text("طريقة العمل"),
                    onChanged: (newVal) {
                      setState(() {
                        _mySelection = newVal;
                      });
                    },
                    value: _mySelection,
                  ),
                  new MaterialButton(
                    child: Text("طلب",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0)),
                    color: Colors.green.shade800,
                    onPressed: () {

                    },
                  ),
                  new FlatButton(
                      child: Text("الغاء",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0)),
                      color: Colors.transparent,
                      onPressed: () {
                        Navigator.pop(context, Answer.CANCEL);
                      }
                  )

                ],
            ))),
    );
  }
}
enum Answer { OK, CANCEL }