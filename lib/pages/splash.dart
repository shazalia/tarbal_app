import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:async';
import 'home.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';

class SplashScreen extends StatefulWidget {

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  List _items ;
  List _cats ;
  List _user;
  int check = 0,isUser = 0;

  @override
  void initState() {
    super.initState();
  }

  Future _getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _user = prefs.getStringList("user");


  }

  SplashScreen splashScreen;
  Widget _screen;

  _SplashScreenState() {
    splashScreen = new SplashScreen();
  }


  Future<String> getItems() async {
    var response = await http.get(
      Uri.encodeFull("http://turbalkom.falsudan.com/api/services"),
    );


    if (response.body.toString() == "") {
      check = 1;
    } else {
      _items = json.decode(response.body)["data"];

      print("Splash screen get is :" + _items.toString());

    }

    print("Splash screen get is :" + response.body);
    print('Response status: ${response.statusCode}');
  }

  Future<String> getCats() async {
    var response = await http.get(
      Uri.encodeFull("http://turbalkom.falsudan.com/api/service_categories"),
    );

    if (response.body.toString() == "") {
      check = 1;
    } else {
      _cats = json.decode(response.body)["data"];
      print("Splash screen get is :" + _cats.toString());

    }

    print("Splash screen get is :" + response.body);
    print('Response status: ${response.statusCode}');
  }

  @override
  Widget build(BuildContext context) {

    _getUser().whenComplete((){
      if(_user != null){
        getItems().whenComplete(() {
          if (check == 0) {
            getCats().whenComplete(() {
              if (check == 0) {
                _onSplashEnd();
              }
            });
          }
        });
      }else{
        _onNoUser();
      }
    });



    return Scaffold(
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
                decoration: new BoxDecoration(color: Colors.black.withOpacity(0.7)),
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
                          radius: 80.0,
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Image.asset('assets/tarbalogo.png'),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10.0),
                        ),
                        Text(
                          "Tarbalcom",
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
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(Color(0xFF1F6E46)),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 40.0),
                      ),

                    ],
                  ),
                )
              ],
            )
          ),

        ],
      ),
    );
  }

  _onSplashEnd() {
    Navigator.pushReplacement(context,
        new MaterialPageRoute(builder: (BuildContext context) => HomeScreen(items : _items,cats : _cats)));
  }

  _onNoUser() {
    Navigator.pushReplacement(context,
        new MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));
  }


}
