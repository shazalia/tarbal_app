import 'dart:convert';

import 'package:flutter/material.dart';
// import 'login.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:tarbalcom/utils/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EstabFarmsScreen extends StatefulWidget {
  final List items;
  final List cats;
  //  final MyFormCallback onSubmit;
  List units;
  String id;


  EstabFarmsScreen({Key key, this.items,this.cats}) : super(key: key);

  @override
  _HomeScreenState createState() => new _HomeScreenState();
}

class _HomeScreenState extends State<EstabFarmsScreen>{

  final scaffoldKey = new GlobalKey<ScaffoldState>();

  String _filter;
  int check = 0,isCount = 0;
  List _filterList;
  int postStatus;
  List<String> userList;
  List<DropdownMenuItem<String>> _dropCatsSub;
    String _currentCatSub,_id;
  String cValue = "all";
  bool isBezin = false;
  bool isDesiel = false;
  List _uints;
  List _values;
    static final TextEditingController _name = new TextEditingController();
  @override
  void initState() {
    _values = widget.units;
    _id = widget.id;
    //  _currentCatSub = _values[0];
  }
  int unit_id;

 


  List _items = new List(0),_cats = new List(0),_dets= new List(0),_units= new List(0);
  var map;
  Future<void> _loading() async {
    return showDialog<void>(
      // context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("جار المعالجه"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                new Row(
                  children: <Widget>[
                    new Container(
                      padding: EdgeInsets.all(10),

                      child: new CircularProgressIndicator(),
                    ),

                    new Text("جار انشاء الطلب ...")
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _alert(String tiltle,String contetn) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(tiltle),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(contetn),
                //Text("يرجى التأكد من ملأ كل الحقول او المستخدم موجود فعليا"),
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

  void onSubmit(int unit, int count,String service) {

    _loading();
    placeOrderDetailed(userList[0],service,count,unit).whenComplete(() {
      if (postStatus == 200) {
        Navigator.pop(context);
        _alert("نجاح","تم انشاء طلبك بنجاح \n ستتواصل معك الادارة");

      } else {
        Navigator.pop(context);
        _alert("خطأ","حدث خطأ ما \n يرجى المحاولة مرة اخرى");
      }
    });

    //print("type: "+result.toString()+"ben: "+ben.toString()+"desiel: "+des.toString());

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
      "http://turbalkom.falsudan.com/api/service_details",
      headers: {
        "Accept": "application/json"
      },
      body: {
        'service_id': id
        //image': image,
      },
    );
    setState(() {
      _dets= json.decode(response.body)["data"]["details"];
      if(json.decode(response.body)["data"]["quantity_units"].toString().length >0){

        setState(() {
          isCount = 1;
          map= json.decode(response.body)["data"]["quantity_units"];
          _units = List.from(map.values).toList();

          if(_units.length >0){
            isCount = 1;
          }
        });

      }

    });

    //List responseJson = json.decode(response.body)["data"];
    return "done";
  }

  Future placeOrderDetailed(String phone,String pass,int count,int unit) async {
    final response = await http.post(
      "http://turbalkom.falsudan.com/api/add_order",
      headers: {
        "Accept": "application/json"
      },
      body: {
        'client_id': phone,
        'service_id': pass,
        'quantity': count.toString(),
        'unit_id': unit.toString()
      },
    );

    if (response.body.toString().contains("success")) {
      setState(() {
        postStatus = response.statusCode;
      });

    }
  }

  Future placeOrder(String phone,String pass) async {
    final response = await http.post(
      "http://turbalkom.falsudan.com/api/add_order",
      headers: {
        "Accept": "application/json"
      },
      body: {
        'client_id': phone,
        'service_id': pass
      },
    );

    if (response.body.toString().contains("success")) {
      setState(() {
        postStatus = response.statusCode;
      });

    }
  }
 

  @override
  void dispose() {
    super.dispose();
  }

 
  List<DropdownMenuItem<String>> getDropCatsSub() {
    List<DropdownMenuItem<String>> items = new List();
    for (int i = 0;i<_values.length;i++) {
      String a ;
      a = _values[i];
      items.add(new DropdownMenuItem(value: a, child:  new SizedBox(
          width: 200.0,
          child: new Text(a)
      ),));
    }
    return items;
  }

  String get name => _name.text;

  void changedDropDownItemSub(String selectedCat) {
    setState(() {
      _currentCatSub = selectedCat;
      for(int x=1;x<_values.length;x++){
        if(_values[x] == selectedCat){
          unit_id = x;
        }
      }
    }
    );
  }

  @override
  Widget build(BuildContext context) {
    return new SimpleDialog(
      title: new Text("تفاصيل الطلب",textAlign: TextAlign.right,),
      children: <Widget>[
        new Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[


            new Padding(
              padding: EdgeInsets.only(right: 20.0, left: 20.0, top: 10.0),
              child: TextFormField(
                controller: _name,
                keyboardType: TextInputType.number,
                autofocus: false,
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                  hintText: 'العدد',
                  contentPadding:
                  EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32.0)),
                ),
                validator: (value) {
                  final RegExp regex = new RegExp(
                      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");

                  if (value.isEmpty) {
                    return 'Please enter some text';
                  }
                },
              ),
            ),

            /*new Padding(
              padding: EdgeInsets.only(right: 20.0, left: 20.0, top: 10.0),
              child: TextFormField(
                controller: _region,
                keyboardType: TextInputType.text,
                autofocus: false,
                decoration: InputDecoration(
                  hintText: 'Address filter',
                  contentPadding:
                  EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32.0)),
                ),
                validator: (value) {
                  final RegExp regex = new RegExp(
                      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");

                  if (value.isEmpty) {
                    return 'Please enter some text';
                  }
                },
              ),
            ),*/

            Container(
              height: 1.0,
              color: Colors.grey,
              margin: const EdgeInsets.only(left: 10.0, right: 10.0,top: 20.0),
            ),
            DropdownButton(
              value: _currentCatSub,
              items: _dropCatsSub,
              onChanged: changedDropDownItemSub,
            )
          ],
        ),


        new Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            new Padding(
              padding: EdgeInsets.only(right: 10.0, top: 20.0),
              child: new FlatButton(
                  child: Text("الغاء",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0)),
                  color: Colors.transparent,
                  onPressed: () {
                    Navigator.pop(context, Answer.CANCEL);
                  }),
            ),
            new Padding(
              padding: EdgeInsets.only(right: 20.0, top: 20.0),
              child: new MaterialButton(
                elevation: 5.0,
                height: 50.0,
                child: Text("طلب",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0)),
                color: Colors.green.shade800,

                // onPressed: () {
                //   Navigator.pop(context);
                //   widget.onSubmit(unit_id,int.tryParse(_name.text),_id);
                // },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

enum Answer { OK, CANCEL }

 

 


 

