import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
 import 'package:tarbalcom/model/Category.dart';




class ServiceProvScreen extends StatefulWidget {
  ServiceProvScreen({Key key, this.title, this.service}) : super(key: key);
  final String title;
  final List service;

  @override
  _ServiceProvScreenState createState() => new _ServiceProvScreenState();
}

class _ServiceProvScreenState extends State<ServiceProvScreen> {
  List _items = new List(0),_cats = new List(0),_dets= new List(0),_serv= new List(0);
  var map;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  int check = 0,isCount = 0;
  int postStatus;
  List<String> _provider;
  List<String> userList;
  String _color = '';
  Category newCategory = new Category();
  final TextEditingController _controller = new TextEditingController();






  @override
  void initState() {
    super.initState();
    _getUser();

    if(widget.service == null){
      _items = new List(0);
    }else{
      _items = widget.service;
      print(_items.toString());
    }
   }
  _getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userList = prefs.getStringList("user");
    });
  }
  Future _deleteUser() async {
    List<String> user = new List(0);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('user', user);
  }
  Future<String> getDetails(String id) async {
    final response = await http.post(
      "http://turbalkom.falsudan.com/api/forms/service_providers",
      headers: {
        "Accept": "application/json"
      },
      body: {
        'service_id': id
        //image': image,
      },
    );
    setState(() {
       if(json.decode(response.body)["data"]["service_providers_category"].toString().length >0){

        setState(() {
          isCount = 1;
          map= json.decode(response.body)["data"]["service_providers_category"];
          _serv = List.from(map.values).toList();

          if(_serv.length >0){
            isCount = 1;
          }
        });

      }

    });

    //List responseJson = json.decode(response.body)["data"];
    return "done";
  }
  void showMessage(String message, [MaterialColor color = Colors.red]) {
    _scaffoldKey.currentState.showSnackBar(
        new SnackBar(backgroundColor: color, content: new Text(message)));
  }

  void _submitForm() {
    final FormState form = _formKey.currentState;

    if (!form.validate()) {
      print(':اختر خيار رجاء ${newCategory.name}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: Text("تربالكم",
            style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold
            )),      ),
      body: new SafeArea(
          top: false,
          bottom: false,
          child: new Form(
              key: _formKey,
              autovalidate: true,
              child: new ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                children: <Widget>[

                  new FormField<String>(
                    builder: (FormFieldState<String> state) {
                      return InputDecorator(
                        decoration: InputDecoration(
                          icon: const Icon(Icons.ac_unit),
                          labelText: 'فئة مزوِّد الخدمة',
                          errorText: state.hasError ? state.errorText : null,
                        ),
                        isEmpty: _color == '',
                        child: new DropdownButtonHideUnderline(
                          child: new DropdownButton<String>(
                            value: _color,
                            isDense: true,
                            onChanged: (String newValue) {
                              setState(() {
                                newCategory.name = newValue;
                                _items = _items.where((i) =>  i["name"].toString().contains(newValue)).toList();
                                state.didChange(newValue);
                              });
                            },

                          ),
                        ),
                      );
                    },
                    validator: (val) {
                      return val != '' ? null : 'الرجاء الاختيار من بين الفئات';
                    },
                  ),
                  new FormField<String>(
                    builder: (FormFieldState<String> state) {
                      return InputDecorator(
                        decoration: InputDecoration(
                          icon: const Icon(Icons.ac_unit),
                          labelText: 'مساحة المزرعة المخصصة للانتاج الزراعي (بالفدان)',
                          errorText: state.hasError ? state.errorText : null,
                        ),
                        isEmpty: _color == '',
                        child: new DropdownButtonHideUnderline(
                          child: new DropdownButton<String>(
                            value: _color,
                            isDense: true,
                            onChanged: (String newValue) {
                              setState(() {
                                newCategory.name = newValue;
                                _color = newValue;
                                state.didChange(newValue);
                              });
                            },
                            items: _provider.map((String value) {
                              return new DropdownMenuItem<String>(
                                value: value,
                                child: new Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      );
                    },
                    validator: (val) {
                      return val != '' ? null : 'الرجاء الاختيار من بين الفئات';
                    },
                  ),
                  new FormField<String>(
                    builder: (FormFieldState<String> state) {
                      return InputDecorator(
                        decoration: InputDecoration(
                          icon: const Icon(Icons.ac_unit),
                          labelText: 'أعداد وأحجام موجودات المزرعة من الثروة الحيوانية',
                          errorText: state.hasError ? state.errorText : null,
                        ),
                        isEmpty: _color == '',
                        child: new DropdownButtonHideUnderline(
                          child: new DropdownButton<String>(
                            value: _color,
                            isDense: true,
                            onChanged: (String newValue) {
                              setState(() {
                                newCategory.name = newValue;
                                _color = newValue;
                                state.didChange(newValue);
                              });
                            },
                            items: _provider.map((String value) {
                              return new DropdownMenuItem<String>(
                                value: value,
                                child: new Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      );
                    },
                    validator: (val) {
                      return val != '' ? null : 'الرجاء الاختيار من بين الفئات';
                    },
                  ),
                  new FormField<String>(
                    builder: (FormFieldState<String> state) {
                      return InputDecorator(
                        decoration: InputDecoration(
                          icon: const Icon(Icons.ac_unit),
                          labelText: 'طريقة الري',
                          errorText: state.hasError ? state.errorText : null,
                        ),
                        isEmpty: _color == '',
                        child: new DropdownButtonHideUnderline(
                          child: new DropdownButton<String>(
                            value: _color,
                            isDense: true,
                            onChanged: (String newValue) {
                              setState(() {
                                newCategory.name = newValue;
                                _color = newValue;
                                state.didChange(newValue);
                              });
                            },
                            items: _provider.map((String value) {
                              return new DropdownMenuItem<String>(
                                value: value,
                                child: new Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      );
                    },
                    validator: (val) {
                      return val != '' ? null : 'الرجاء الاختيار من بين الفئات';
                    },
                  ),
                  new FormField<String>(
                    builder: (FormFieldState<String> state) {
                      return InputDecorator(
                        decoration: InputDecoration(
                          icon: const Icon(Icons.ac_unit),
                          labelText: 'مصدر الري',
                          errorText: state.hasError ? state.errorText : null,
                        ),
                        isEmpty: _color == '',
                        child: new DropdownButtonHideUnderline(
                          child: new DropdownButton<String>(
                            value: _color,
                            isDense: true,
                            onChanged: (String newValue) {
                              setState(() {
                                newCategory.name = newValue;
                                _color = newValue;
                                state.didChange(newValue);
                              });
                            },
                            items: _provider.map((String value) {
                              return new DropdownMenuItem<String>(
                                value: value,
                                child: new Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      );
                    },
                    validator: (val) {
                      return val != '' ? null : 'الرجاء الاختيار من بين الفئات';
                    },
                  ),
                  new FormField<String>(
                    builder: (FormFieldState<String> state) {
                      return InputDecorator(
                        decoration: InputDecoration(
                          icon: const Icon(Icons.ac_unit),
                          labelText: 'مصدر الطاقة',
                          errorText: state.hasError ? state.errorText : null,
                        ),
                        isEmpty: _color == '',
                        child: new DropdownButtonHideUnderline(
                          child: new DropdownButton<String>(
                            value: _color,
                            isDense: true,
                            onChanged: (String newValue) {
                              setState(() {
                                newCategory.name = newValue;
                                _color = newValue;
                                state.didChange(newValue);
                              });
                            },
                            items: _provider.map((String value) {
                              return new DropdownMenuItem<String>(
                                value: value,
                                child: new Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      );
                    },
                    validator: (val) {
                      return val != '' ? null : 'الرجاء الاختيار من بين الفئات';
                    },
                  ),
                  new FormField<String>(
                    builder: (FormFieldState<String> state) {
                      return InputDecorator(
                        decoration: InputDecoration(
                          icon: const Icon(Icons.ac_unit),
                          labelText: 'علاقة العمل',
                          errorText: state.hasError ? state.errorText : null,
                        ),
                        isEmpty: _color == '',
                        child: new DropdownButtonHideUnderline(
                          child: new DropdownButton<String>(
                            value: _color,
                            isDense: true,
                            onChanged: (String newValue) {
                              setState(() {
                                newCategory.name = newValue;
                                _items = _items.where((i) =>  i["name"].toString().contains(newValue)).toList();
                                 state.didChange(newValue);
                              });
                            },
                            items: _provider.map((String value) {
                              return new DropdownMenuItem<String>(
                                value: value,
                                child: new Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      );
                    },
                    validator: (val) {
                      return val != '' ? null : 'الرجاء الاختيار من بين الفئات';
                    },
                  ),
                  new Container(
                      padding: const EdgeInsets.only(left: 40.0, top: 20.0),
                      child: new RaisedButton(
                        child: const Text('طلب'),
                        onPressed: _submitForm,
                      )),
                ],
              ))),
    );
  }
}
