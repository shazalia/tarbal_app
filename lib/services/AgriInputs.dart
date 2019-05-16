import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tarbalcom/services/ServiceProvScreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:tarbalcom/utils/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AgriInputsScreen extends StatefulWidget {
   MyFormCallback onSubmit;
  List units;
  String id;
   List items;
   List cats;
  List _values;

  AgriInputsScreen({Key key, this.items,this.cats}) : super(key: key);

  @override
  _AgriInputsScreenState createState() => new _AgriInputsScreenState();
}

class _AgriInputsScreenState extends State<AgriInputsScreen>{
  String _currentCatSub,_id;


  final scaffoldKey  = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  String _mySelection;

  String _filter;
  int check = 0,isCount = 0;
  List _filterList;
  int postStatus;
  List data = List(); //edited line
  List<String> userList;
  List<DropdownMenuItem<String>> _dropCatsSub;


  List _items = new List(0),_cats = new List(0),_dets= new List(0),_units= new List(0);
  var map;

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

  @override
  void initState() {
//    _values = widget.units;

    super.initState();
    this.getServicePro();

    _getUser();
    _filterList = widget.cats;

    if(widget.cats == null){
      _filterList = new List(0);
    }else{
      _filterList = widget.cats;

    }

    if(widget.items == null){
      _items = new List(0);
    }else{
      _items = widget.items;
      print(_items.toString());
    }
    //_filter = _filterList[0]["name"];
    _dropCatsSub = getDropCatsSub(_filterList);


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
  // ignore: missing_return


  Future<String> getServicePro() async {
    var res = await http
        .get(Uri.encodeFull("http://turbalkom.falsudan.com/api/forms/service_providers")
        , headers: {"Accept": "application/json"});
    var resBody = json.decode(res.body);

    setState(() {
      data = resBody;
    });

    print(resBody);

    return "success";
  }

  List<DropdownMenuItem<String>> getDropCatsSub(List _cats) {
    List<DropdownMenuItem<String>> items = new List();
    for (int i = 0;i<=_cats.length;i++) {
      String a;
      if(i==0){
        a = "-الكل-";
      }else{
        a = _cats[i-1]["name"];
      }
      items.add(new DropdownMenuItem(value: a, child:  new SizedBox(
          child: new Text(a)
      ),));
    }
    return items;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {


    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          elevation: 3,
          backgroundColor: Color(0xFF1F6E46),
          centerTitle: true,
          title: Text("تربالكم",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold
              )),

          actions: <Widget>[

            new IconButton(
              icon: new Icon(Icons.person),
              color: Colors.white,
              onPressed: (){

                _wedd();
              },
            ),
            new IconButton(
              icon: new Icon(Icons.search),
              color: Colors.white,
              onPressed: (){},
            ),
          ],

        ),
        body: Container(
            color: Color(0x111F6E46),
            child: Center(
              child: Column(
                 children: <Widget>[
                  new Column(
                    crossAxisAlignment: CrossAxisAlignment.end,

                    children: <Widget>[


                      Container(
                        height: 1.0,
                        color: Colors.grey,
                        margin: const EdgeInsets.only(left: 10.0, right: 10.0,top: 20.0),
                      ),
                      new DropdownButton(
                        value: _currentCatSub,
                        items: _dropCatsSub,
                        hint: Text("مساحة المزرعة بالفدان"),
                        onChanged: changedDropDownItemSub,


                      ),
                      new DropdownButton(
                        value: _currentCatSub,
                        items: _dropCatsSub,
                        hint: Text("اعداد ثروات المزرعة"),
                        onChanged: changedDropDownItemSub,

                      ),
                      new DropdownButton(
                        value: _currentCatSub,
                        items: _dropCatsSub,
                        hint: Text("طريقة الري"),
                        onChanged: changedDropDownItemSub,

                      ),
                      new DropdownButton(
                        value: _currentCatSub,
                        items: _dropCatsSub,
                        hint: Text("مصدر الري"),
                        onChanged: changedDropDownItemSub,

                      ),
                      new DropdownButton(
                        value: _currentCatSub,
                        items: _dropCatsSub,
                        hint: Text("مصدر الطاقة"),
                        onChanged: changedDropDownItemSub,

                      ),
                      new DropdownButton(
                        value: _currentCatSub,
                        items: _dropCatsSub,
                        hint: Text("طريقة العمل"),
                        onChanged: changedDropDownItemSub,

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

                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),

            )
        )
    );
  }

  void _wedd(){
    double screenheught = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    showModalBottomSheet(
        context: context,
        builder: (builder){
          return new Container(
            height: screenheught,
            color: Color(0xFF737373), //could change this to Color(0xFF737373),
            //so you don't have to change MaterialApp canvasColor
            child: new Container(
                margin: EdgeInsets.only(left: 40,right: 40),
                decoration: new BoxDecoration(
                    color: Colors.white,
                    borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(30.0),
                        topRight: const Radius.circular(30.0))),
                child: new Center(
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Container(
                            height: 3,
                            color: Color(0x88AAAAAA),
                            margin: EdgeInsets.only(left: 100,right: 100,top: 20),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),

                      CircleAvatar(
                        backgroundColor: Colors.grey.shade300,
                        radius: 40.0,
                        child: Padding(
                          padding: EdgeInsets.all(15),
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            placeholder: Image.asset('assets/user.png'),
                            imageUrl: userList[4],
                          ),
                        ),
                      ),

                      SizedBox(height: 10),

                      Text(userList[1],style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),

                      Expanded(
                          flex: 1,
                          child: Container(
                            padding: EdgeInsets.only(right: 40),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[

                                Text(
                                  userList[3],
                                  style: TextStyle(color: Colors.grey, fontWeight: FontWeight.normal,fontSize: 16),
                                ),

                                SizedBox(width: 10,),

                                Icon(Icons.email,size: 20,color: Colors.grey,),

                              ],
                            ),
                          )
                      ),

                      Expanded(
                          flex: 1,
                          child: Container(
                            padding: EdgeInsets.only(right: 40),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[

                                Text(
                                  userList[2],
                                  style: TextStyle(color: Colors.grey, fontWeight: FontWeight.normal,fontSize: 16),
                                ),

                                SizedBox(width: 10,),

                                Icon(Icons.phone,size: 20,color: Colors.grey,),

                              ],
                            ),
                          )
                      ),

                      Expanded(
                          flex: 1,
                          child: Container(
                            padding: EdgeInsets.only(right: 40),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[

                                Text(
                                  "+24991400444",
                                  style: TextStyle(color: Colors.grey, fontWeight: FontWeight.normal,fontSize: 16),
                                ),

                                SizedBox(width: 10,),

                                Icon(Icons.phone,size: 20,color: Colors.grey,),

                              ],
                            ),
                          )
                      ),

                      Expanded(
                          flex: 2,
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[

                                Container(
                                  child: Material(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(30.0),
                                    shadowColor: Colors.red,
                                    elevation: 5.0,
                                    child: MaterialButton(
                                      //minWidth: 200.0,
                                        height: 50.0,
                                        onPressed: () {
                                          _deleteUser().whenComplete((){
                                            _onToSign();
                                          });
                                        },

                                        child:Row(
                                          children: <Widget>[
                                            Icon(Icons.power_settings_new,color: Colors.white,),
                                            SizedBox(width: 5,),
                                            Text('تسجيل خرج', style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
                                          ],
                                        )
                                    ),
                                  ),
                                ),

                              ],
                            ),
                          )
                      ),



                    ],

                  ),
                )
            ),
          );
        }
    );


  }


  void _modalBottomSheetMenu(List _details,String name, String desc,String id){

    double screenheught = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    scaffoldKey.currentState.showBottomSheet((context){
      return new Container(
        //color: Color(0xFFEEEEEE),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0x111F6E46),
              Color(0x111F6E46),
              Color(0x111F6E46),
            ],
            begin: FractionalOffset.topCenter,
            end: FractionalOffset.bottomCenter,
          ),
        ),

        child: new Column(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.only(left: 10.0,right: 40.0, top: 10.0),
                child: Row(

                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.close,
                        size: 20,
                        color: Colors.black54,

                      ),
                      onPressed: (){
                        Navigator.pop(context);
                      },
                    ),

                  ],
                )
            ),
            Container(
                padding: EdgeInsets.only(left: 20,right: 20,bottom: 30),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                            flex: 2,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Material(
                                  color: Color(0xFF1F6E46),
                                  borderRadius: BorderRadius.circular(30.0),
                                  shadowColor: Colors.green,
                                  elevation: 5.0,
                                  child: MaterialButton(
                                    //minWidth: 200.0,
                                    height: 30.0,
                                    minWidth: 20,
                                    onPressed: () {

                                      if(isCount == 1){
                                        showDialog(
                                            context: context, child: new MyForm(onSubmit: onSubmit,units: _units,id: id));
                                      }else{
                                        _loading();
                                        placeOrder(userList[0],id).whenComplete(() {
                                          if (postStatus == 200) {
                                            Navigator.pop(context);
                                            _alert("نجاح","تم انشاء طلبك بنجاح \n ستتواصل معك الادارة");

                                          } else {
                                            Navigator.pop(context);
                                            _alert("خطأ","حدث خطأ ما \n يرجى المحاولة مرة اخرى");
                                          }
                                        });
                                      }

                                    },
                                    child: Text('انشاء الطلب', style: TextStyle(color: Colors.white)),
                                  ),
                                ),
                              ],
                            )
                        ),

                        Expanded(
                            flex: 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                  name,
                                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontSize: 18),
                                ),
                              ],
                            )
                        ),

                      ],

                    ),
                    SizedBox(height: 10,),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          desc,
                          textAlign: TextAlign.right,
                          style: TextStyle(color: Colors.grey, fontWeight: FontWeight.normal,fontSize: 14),
                        ),

                      ],

                    ),
                  ],
                )
            ),



            Expanded(
                child:ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemCount: _details.length,
                    // itemExtent: 10.0,
                    //reverse: true, //makes the list appear in descending order
                    itemBuilder: (BuildContext context, int index) {
                      return new Container(
                        child: Column(
                          children: <Widget>[
                            index !=0?Container(
                              margin: EdgeInsets.only(left: 20,right: 20),
                              height: 1,
                              color: Color(0x331F6E46),
                            ):Container(),
                            Container(
                              padding: EdgeInsets.all(20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Text(
                                    _details[index]["value"],
                                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal,fontSize: 14),
                                  ),

                                  Text(
                                    "   :   ",
                                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal,fontSize: 14),
                                  ),

                                  Text(
                                    _details[index]["label"],
                                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal,fontSize: 18),
                                  ),


                                ],

                              ),
                            ),


                          ],
                        ),
                      );
                    }
                )

            ),

          ],
        ),

      );


    });


  }

  Future<void> _loading() async {
    return showDialog<void>(
      context: context,
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

  _onToSign() {
    Navigator.pushReplacement(context,
        new MaterialPageRoute(builder: (BuildContext context) => ServiceProvScreen()));
  }
  void changedDropDownItemSub(String selectedCat) {
    setState(() {
      _currentCatSub = selectedCat;

    }
    );
  }


}






typedef void MyFormCallback(int unit,int count,String id);

// ignore: must_be_immutable
class MyForm extends StatefulWidget {
  final MyFormCallback onSubmit;
  List units;
  String id;

  MyForm({this.onSubmit,this.units,this.id});

  @override
  _MyFormState createState() => new _MyFormState();
}

class _MyFormState extends State<MyForm> {
  String _currentCatSub,_id;
  String cValue = "all";
  bool isBezin = false;
  bool isDesiel = false;
  List _uints;
  List _values;
  List<DropdownMenuItem<String>> _dropCatsSub;

  static final TextEditingController _name = new TextEditingController();
  @override
  void initState() {
    _values = widget.units;
    _id = widget.id;
    _dropCatsSub = getDropCatsSub();
    _currentCatSub = _values[0];
  }
  int unit_id;

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
  _onToSign() {
    Navigator.pushReplacement(context,
        new MaterialPageRoute(builder: (BuildContext context) => ServiceProvScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return new SimpleDialog(
      title: new Text("تفاصيل الطلب",textAlign: TextAlign.right,),
      children: <Widget>[
        new Column(
          crossAxisAlignment: CrossAxisAlignment.end,

          children: <Widget>[


            Container(
              height: 1.0,
              color: Colors.grey,
              margin: const EdgeInsets.only(left: 10.0, right: 10.0,top: 20.0),
            ),
            new DropdownButton(
              value: _currentCatSub,
              items: _dropCatsSub,
              hint: Text("مساحة المزرعة بالفدان"),
              onChanged: changedDropDownItemSub,


            ),
            new DropdownButton(
              value: _currentCatSub,
              items: _dropCatsSub,
              hint: Text("اعداد ثروات المزرعة"),
              onChanged: changedDropDownItemSub,

            ),
            new DropdownButton(
              value: _currentCatSub,
              items: _dropCatsSub,
              hint: Text("طريقة الري"),
              onChanged: changedDropDownItemSub,

            ),
            new DropdownButton(
              value: _currentCatSub,
              items: _dropCatsSub,
              hint: Text("مصدر الري"),
              onChanged: changedDropDownItemSub,

            ),
            new DropdownButton(
              value: _currentCatSub,
              items: _dropCatsSub,
              hint: Text("مصدر الطاقة"),
              onChanged: changedDropDownItemSub,

            ),
            new DropdownButton(
              value: _currentCatSub,
              items: _dropCatsSub,
              hint: Text("طريقة العمل"),
              onChanged: changedDropDownItemSub,

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

                onPressed: () {
                  Navigator.pop(context);
                  widget.onSubmit(unit_id,int.tryParse(_name.text),_id);
                },
              ),
            ),
          ],
        ),
      ],
    );

  }
}

enum Answer { OK, CANCEL }



