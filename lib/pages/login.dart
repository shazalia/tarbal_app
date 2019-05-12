import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tarbalcom/pages/signup.dart';
import 'dart:async';
//import 'signup.dart';
import 'home.dart';
import 'package:http/http.dart' as http;
import 'package:tarbalcom/utils/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'splash.dart';


class LoginScreen extends StatefulWidget {

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  String _items = "";
  String _cats = "";
  int check = 0;

  @override
  void initState() {
    super.initState();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  static final TextEditingController _fullname = new TextEditingController();
  static final TextEditingController _email = new TextEditingController();
  static final TextEditingController _pass = new TextEditingController();
  static final TextEditingController _phone = new TextEditingController();
  final _loginForm = GlobalKey<FormState>();

  int postStatus;

  Future _saveUser(String id,String name,String phone,String email,String image) async {
    List<String> user = [id,name,phone,email,image];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('user', user);
  }

  // ignore: missing_return
  Future<User> submitForm(String phone,String pass) async {
    final response = await http.post(
      "http://turbalkom.falsudan.com/api/login",
      headers: {
        "Accept": "application/json"
      },
      body: {
        'phone_number': phone,
        'password': pass
      },
    );

    if (response.body.toString().contains("success")) {
      setState(() {
        postStatus = response.statusCode;
      });
      return User.fromJson(json.decode(response.body)["data"]);
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: new BoxDecoration(
              borderRadius:
              BorderRadius.all(Radius.circular(15.0)),
              image: new DecorationImage(
                image: new AssetImage("assets/plant.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: new BackdropFilter(
              filter: new ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
              child: new Container(
                decoration: new BoxDecoration(color: Colors.black.withOpacity(0.6)),
              ),
            ),
          ),
          Container(

              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          CircleAvatar(

                            backgroundColor: Colors.transparent,
                            radius: 50.0,
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Image.asset('assets/tarbalogo.png'),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10.0),
                          ),
                          Text(
                            "تربالكم",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 2,
                      child: Container(
                          padding: EdgeInsets.only(left: 20,right: 20),
                          child: Form(
                            key: _loginForm,
                              child: new SingleChildScrollView(
                                  child: new ConstrainedBox(
                                      constraints: new BoxConstraints(),
                                      child: new Column(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: <Widget>[
                                          new TextFormField(
                                            controller: _phone,
                                            keyboardType: TextInputType.number,
                                            textAlign: TextAlign.right,
                                            autofocus: false,
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                            decoration: InputDecoration(
                                              hintText: 'رقم الهاتف',
                                              filled: true,
                                              fillColor: Color(0x88FFFFFF),
                                              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                                              border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(50.0)),
                                            ),
                                            validator: (value) {

                                              if (value.isEmpty) {
                                                return 'الرجاء ملأ الحقل';
                                              }
                                              if (value.length != 10) {
                                                return 'رقم الهاتف يجب ان يكون 10 ارقام';
                                              }
                                            },
                                          ),

                                          SizedBox(height: 20.0),

                                          TextFormField(
                                            controller: _pass,
                                            keyboardType: TextInputType.text,
                                            textAlign: TextAlign.right,
                                            autofocus: false,
                                            obscureText: true,
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                            decoration: InputDecoration(
                                              hintText: 'كلمة السر',
                                              filled: true,
                                              fillColor: Color(0x88FFFFFF),
                                              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                                              border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(32.0)),
                                            ),
                                            validator: (value) {

                                              if (value.isEmpty) {
                                                return 'الرجاء ادخال كلمة السر';
                                              }
                                            },
                                          ),

                                          Padding(
                                            padding: EdgeInsets.only(bottom: 10,top: 40),
                                            child: Material(
                                              color: Color(0xFF1F6E46),
                                              borderRadius: BorderRadius.circular(30.0),
                                              shadowColor: Colors.green,
                                              elevation: 5.0,
                                              child: MaterialButton(
                                                //minWidth: 200.0,
                                                height: 50.0,
                                                minWidth: screenWidth,
                                                onPressed: () {

                                                  if(_loginForm.currentState.validate()){

                                                    submitForm(_phone.text.toString(),_pass.text.toString()).then((user) {
                                                      if (postStatus == 200) {
                                                        _saveUser(user.user_id.toString(),user.name,user.phone,user.email,user.image).whenComplete(
                                                            (){
                                                              _onToLog();
                                                              _scaffoldKey.currentState.hideCurrentSnackBar();
                                                            }
                                                        );

                                                      } else {
                                                        _scaffoldKey.currentState.hideCurrentSnackBar();
                                                        _wrongPost();
                                                      }
                                                    });

                                                    _scaffoldKey.currentState.showSnackBar(
                                                      new SnackBar(duration: new Duration(seconds: 40), content:
                                                      new Row(
                                                        children: <Widget>[
                                                          new CircularProgressIndicator(),
                                                          new Text("جار تسجيل الدخول ...")
                                                        ],
                                                      ),
                                                      ),
                                                    );

                                                  }

                                                },

                                                child: Text('تسجيل الدخول', style: TextStyle(color: Colors.white)),
                                              ),
                                            ),
                                          ),

                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              FlatButton(
                                                child: Text ("انشاء", style: TextStyle(color: Colors.green),),
                                                onPressed: (){
                                                  _onToSign();
                                                },
                                              ),
                                              Text ("ليس لديك حساب ؟", style: TextStyle(color: Colors.white)),

                                            ],
                                          )
                                        ],
                                      )
                                  )
                              )
                          )

                      )
                  )
                ],
              )
          ),

        ],
      ),
    );
  }

  _onToLog() {
    Navigator.pushReplacement(context,
        new MaterialPageRoute(builder: (BuildContext context) => SplashScreen()));
  }

  _onToSign() {
    Navigator.pushReplacement(context,
        new MaterialPageRoute(builder: (BuildContext context) => SignUp()));
  }

  Future<void> _wrongPost() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("خطأ"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("حدث خطأ ما"),
                Text("يرجى التأكد من ملأ كل الحقول او المستخدم موجود فعليا"),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("نم"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
