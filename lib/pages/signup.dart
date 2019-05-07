import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:async';
import 'login.dart';
import 'home.dart';
import 'package:http/http.dart' as http;
import 'package:tarbalcom/utils/user.dart';
import 'splash.dart';


class SignUp extends StatefulWidget {

  @override
  _SignupScreen createState() => _SignupScreen();
}

class _SignupScreen extends State<SignUp> {
  int postStatus;
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

  String message;

  Future<User> submitForm(String phone,String pass,String name, String email) async {
    final response = await http.post(
      "http://turbalkom.falsudan.com/api/register",
      headers: {
        "Accept": "application/json"
      },
      body: {
        'phone_number':phone,
        'full_name':name,
        'password': pass,
        'email': email

      },
    );

    if (response.body.toString().contains("success")) {
      setState(() {
        postStatus = response.statusCode;
        message = json.decode(response.body)["ResponseMessage"].toString();
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
                    flex: 1,
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          CircleAvatar(
                            backgroundColor: Colors.white70,
                            radius: 50.0,
                            child: Padding(
                              padding: EdgeInsets.all(0),
                              child: Image.asset('assets/user.png',fit: BoxFit.cover,),
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 2,
                      child: Container(
                        alignment: Alignment.center,
                          padding: EdgeInsets.only(left: 20,right: 20),
                          child: Form(
                              key: _loginForm,
                              child: new SingleChildScrollView(
                                  child: new ConstrainedBox(
                                      constraints: new BoxConstraints(),
                                      child: new Column(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: <Widget>[

                                          TextFormField(
                                            controller: _phone,
                                            keyboardType: TextInputType.number,
                                            textAlign: TextAlign.right,
                                            autofocus: false,
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                            decoration: InputDecoration(
                                              hintText: '* رقم الهاتف',
                                              filled: true,
                                              fillColor: Color(0x88FFFFFF),
                                              contentPadding: EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 15.0),
                                              border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(32.0)),
                                            ),
                                            validator: (value) {

                                              if (value.isEmpty) {
                                                return 'الرجاء ملأ الحقل';
                                              }
                                              if (value.length != 10) {
                                                return 'رقم الهاتف يجب ان يتكون من 10 ارقام';
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
                                              contentPadding: EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 15.0),
                                              border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(32.0)),
                                            ),
                                            validator: (value) {

                                              if (value.isEmpty) {
                                                return 'الرجاء ادخال كلمة السر';
                                              }
                                              if (value.length < 6) {
                                                return 'يجب ان يكون اكثر من 6 احرف';
                                              }
                                            },
                                          ),

                                          SizedBox(height: 20.0),

                                          TextFormField(
                                            controller: _fullname,
                                            keyboardType: TextInputType.text,
                                            textAlign: TextAlign.right,
                                            autofocus: false,
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                            decoration: InputDecoration(
                                              hintText: 'الاسم كاملا',
                                              filled: true,
                                              fillColor: Color(0x88FFFFFF),
                                              contentPadding: EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 15.0),
                                              border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(32.0)),
                                            ),
                                            validator: (value) {

                                              if (value.isEmpty) {
                                                return 'الرجاء ملأ الحقل';
                                              }
                                            },
                                          ),

                                          SizedBox(height: 20.0),

                                          TextFormField(
                                            controller: _email,
                                            keyboardType: TextInputType.emailAddress,
                                            textAlign: TextAlign.right,
                                            autofocus: false,
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                            decoration: InputDecoration(
                                              hintText: 'البريد الالكتروني',
                                              filled: true,
                                              fillColor: Color(0x88FFFFFF),
                                              contentPadding: EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 15.0),
                                              border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(32.0)),
                                            ),
                                            validator: (value) {

                                              if (value.isEmpty) {
                                                return 'الرجاء ملأ الحقل';
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
                                                    submitForm(_phone.text.toString(),_pass.text.toString(),_fullname.text.toString(),_email.text.toString()).then((user) {
                                                      if (postStatus == 200) {
                                                        _onToSign();
                                                        _scaffoldKey.currentState.hideCurrentSnackBar();
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

                                                child: Text('انشاء حساب', style: TextStyle(color: Colors.white)),
                                              ),
                                            ),
                                          ),

                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              FlatButton(
                                                child: Text ("تسجيل دخول", style: TextStyle(color: Colors.green),),
                                                onPressed: (){
                                                  _onToLog();
                                                },
                                              ),
                                              Text ("لديك حساب بالفعل ؟", style: TextStyle(color: Colors.white)),

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
        new MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));
  }

  _onToSign() {
    Navigator.pushReplacement(context,
        new MaterialPageRoute(builder: (BuildContext context) => SplashScreen()));
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
                Text(message),
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
