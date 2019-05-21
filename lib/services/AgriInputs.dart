import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:tarbalcom/model/Category.dart';




class AgriInputsScreen extends StatefulWidget {
  AgriInputsScreen({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _AgriInputsScreenState createState() => new _AgriInputsScreenState();
}

class _AgriInputsScreenState extends State<AgriInputsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  List<String> _provider = <String>['','طلب مدخلات انتاج نباتي - سمكي',  'طلب مدخلات انتاج حيواني'];
   String _color = '';
  Category newCategory = new Category();
  final TextEditingController _controller = new TextEditingController();







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
        title: Text("تربالكم-مدخلات الانتاج ",
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
