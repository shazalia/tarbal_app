import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:tarbalcom/services/ServiceProvScreen.dart';
import 'package:tarbalcom/services/AgriInputsScreen.dart';
import 'package:tarbalcom/services/ServicFarmScreen.dart';
import 'package:tarbalcom/services/EstabFarmsScreen.dart';
import 'login.dart';
import 'package:flutter/cupertino.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
//
class HomeScreen extends StatefulWidget {
  final List items;
  final List cats;

  HomeScreen({Key key, this.items,this.cats}) : super(key: key);

  @override
  _HomeScreenState createState() => new _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{

  final scaffoldKey = new GlobalKey<ScaffoldState>();
  List _filterList;
  int check = 0,isCount = 0;
  int postStatus;
  List<String> userList;
  int index;
  List<DropdownMenuItem<String>> _dropCatsSub;
  List _items = new List(0),_cats = new List(0),_dets= new List(0),_units= new List(0);
  var map;
  void onSubmit(int unit, int count,String service) {

 
 

    //print("type: "+result.toString()+"ben: "+ben.toString()+"desiel: "+des.toString());

  }

  @override
  void initState() {
    super.initState();
    _getUser();
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
    final response = await http.get(
      "http://www.amock.io/api/shazawdidi/api/service_categories",
      headers: {
        "Accept": "application/json"
      },

    );

    return "done";
  }
  Future<String> getSWData(String id) async {
    final String url = "http://turbalkom.falsudan.com/api/forms/service_providers";
    List data = List(); //edited line


    var res = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});

    var resBody = json.decode(res.body);

    setState(() {
      data = resBody;
    });

    print(resBody);

    return "success";
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
        body: NestedScrollView(
     headerSliverBuilder: (BuildContext context, bool boxIsScrolled) {    
        return <Widget>[
          //  key: scaffoldKey,
        SliverAppBar(
          elevation: 3,
          backgroundColor: Colors.lightGreen[50],
          centerTitle: true,
          title: Text("تربالكم",
              style: TextStyle(
                  fontFamily: 'RobotoMono',
                  color: Colors.lightGreen[900],
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold
              )),

          actions: <Widget>[

            new IconButton(
              icon: new Icon(Icons.person),
              color: Colors.lightGreen[900],
              onPressed: (){
                _wedd();
              },
            ),
            new IconButton(
              icon: new Icon(Icons.search),
              color: Colors.lightGreen[900],
              onPressed: (){},
            ),
          ],

        ),
           ];
     },
        
         body:Container(
           padding: EdgeInsets.only(
                                    top: 15.0,
                                    bottom: 5.0,
                                    left: 20.0,
                                    right: 30.0),
            color: Color(0x111F6E46),
            child: Center(

              child: Column(
                children: <Widget>[
                  SizedBox(height: 20,),

                  
                 Expanded(
                    child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,  
                        // physics: const ClampingScrollPhysics(),
                        itemCount: _items.length,
                        // itemExtent: 10.0,
                        //reverse: true, //makes the list appear in descending order
                        itemBuilder: (BuildContext context, int index) {

                          return new GestureDetector(
                            onTap: (){
                              scaffoldKey.currentState.showSnackBar(
                                new SnackBar(duration: new Duration(seconds: 40), content:
                                new Row(
                                  children: <Widget>[
                                    new CircularProgressIndicator(),
                                    new Text("   جاري جلب التفاصيل ...     ")
                                  ],
                                ),
                                ),
                              );


                              getDetails(_items[index]["id"].toString()).whenComplete(() {
                                setState(() {
                                  scaffoldKey.currentState.hideCurrentSnackBar();
                                  _modalBottomSheetMenu(_dets,_items[index]["name"],_items[index]["description"],_items[index]["id"].toString(),_items[index]["image"]);
                                });

                              });

                            },
                            child: Container(
                                height: 50.0,
                                width: screenWidth,
                                padding: EdgeInsets.only(
                                    top: 20.0,
                                    bottom: 350.0,
                                    left: 10.0,
                                    right: 30.0),
                                child: Material(
                                    color: Colors.lightGreen[50],
                                    animationDuration: Duration(milliseconds: 500),
                                    elevation: 2.0,
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                    child: Row(
                                      children: <Widget>[

                                        Expanded(
                                          flex: 2,
                                          child: Column(
                                            children: <Widget>[
                                              SizedBox(height: 10,),
                                              Expanded(
                                                flex: 1,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: <Widget>[
                                                    Column(

                                                      crossAxisAlignment: CrossAxisAlignment.end,
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: <Widget>[
                                                        Text(
                                                          _items[index]["name"],
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontSize: 18),
                                                        ),

                                                      ],
                                                    ),

                                                  ],
                                                ),
                                              ),
 
                                              SizedBox(height: 10,)

                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                            decoration: new BoxDecoration(
                                              borderRadius:
                                              BorderRadius.all(Radius.circular(15.0)),
                                            ),
                                            child: CircleAvatar(
                                              backgroundColor: Colors.lightGreen[50],
                                              radius: 40.0,
                                              child: Padding(
                                                padding: EdgeInsets.all(15),
                                                child: CachedNetworkImage(
                                                  fit: BoxFit.cover,
                                                  placeholder: Image.asset('assets/user.png'),
                                                  imageUrl: _items[index]["image"],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),

                                      ],
                                    )
                                )
                            ),
                          );
                        }
                    ),
                  ),
                 
                 
                ],
              ),


            )
        )
     ),
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
                      Card(
                          margin: EdgeInsets.only(left: 40,right: 40),
                    child: SizedBox(
                           height: 10.0,
                           width: 10.0,
                          child: CachedNetworkImage(
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
                                            _onToLog();
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


  void _modalBottomSheetMenu(List _details,String name, String desc,String id,String img){

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
                        color: Colors.lightGreen[900],

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
              child: CachedNetworkImage(
                                                  fit: BoxFit.cover,
                                                  placeholder: Image.asset('assets/user.png'),
                                                  imageUrl: img,
                                                ),

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
                                  shadowColor: Colors.lightGreen[900],
                                  elevation: 5.0,
                                  child: MaterialButton(
                                    //minWidth: 200.0,
                                    height: 30.0,
                                    minWidth: 20,
                                    onPressed: () {
                                       if(id==1.toString()){  
                                      Navigator.pushReplacement(context,
                                      new MaterialPageRoute(builder: (BuildContext context) => ServiceProvScreen()));
                                       }
                                          if(id==2.toString()){  
                                      Navigator.pushReplacement(context,
                                      new MaterialPageRoute(builder: (BuildContext context) => AgriInputsScreen()));
                                       }
                                           if(id==3.toString()){  
                                      Navigator.pushReplacement(context,
                                      new MaterialPageRoute(builder: (BuildContext context) => AgriInputsScreen()));
                                       }
                                              if(id==4.toString()){  
                                      Navigator.pushReplacement(context,
                                      new MaterialPageRoute(builder: (BuildContext context) => AgriInputsScreen()));
                                       }
                                                   if(id==5.toString()){  
                                      Navigator.pushReplacement(context,
                                      new MaterialPageRoute(builder: (BuildContext context) => AgriInputsScreen()));
                                       }
                                                   if(id==6.toString()){  
                                      Navigator.pushReplacement(context,
                                      new MaterialPageRoute(builder: (BuildContext context) => AgriInputsScreen()));
                                       }
                                                   if(id==4.toString()){  
                                      Navigator.pushReplacement(context,
                                      new MaterialPageRoute(builder: (BuildContext context) => AgriInputsScreen()));
                                       }
                                                   if(id==7.toString()){  
                                      Navigator.pushReplacement(context,
                                      new MaterialPageRoute(builder: (BuildContext context) => AgriInputsScreen()));
                                       }
                                                      if(id==8.toString()){  
                                      Navigator.pushReplacement(context,
                                      new MaterialPageRoute(builder: (BuildContext context) => EstabFarmsScreen()));
                                       }
                                                        if(id==9.toString()){  
                                      Navigator.pushReplacement(context,
                                      new MaterialPageRoute(builder: (BuildContext context) => EstabFarmsScreen()));
                                       }
                                                        if(id==10.toString()){  
                                      Navigator.pushReplacement(context,
                                      new MaterialPageRoute(builder: (BuildContext context) => EstabFarmsScreen()));
                                       }
                                                        if(id==11.toString()){  
                                      Navigator.pushReplacement(context,
                                      new MaterialPageRoute(builder: (BuildContext context) => EstabFarmsScreen()));
                                       }
                                                        if(id==12.toString()){  
                                      Navigator.pushReplacement(context,
                                      new MaterialPageRoute(builder: (BuildContext context) => EstabFarmsScreen()));
                                       }
                                                            if(id==13.toString()){  
                                      Navigator.pushReplacement(context,
                                      new MaterialPageRoute(builder: (BuildContext context) => ServicFarmScreen()));
                                       }
                                                            if(id==14.toString()){  
                                      Navigator.pushReplacement(context,
                                      new MaterialPageRoute(builder: (BuildContext context) => ServicFarmScreen()));
                                       }
                                                            if(id==15.toString()){  
                                      Navigator.pushReplacement(context,
                                      new MaterialPageRoute(builder: (BuildContext context) => ServicFarmScreen()));
                                       }
                                                            if(id==16.toString()){  
                                      Navigator.pushReplacement(context,
                                      new MaterialPageRoute(builder: (BuildContext context) => ServicFarmScreen()));
                                       }
                                    },
                                    child: Text('انشاء الطلب', style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
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
                          style: TextStyle(color: Colors.lightGreen[900], fontWeight: FontWeight.normal,fontSize: 14),
                        ),

                      ],

                    ),
                  ],
                )
            ),
           


            // Expanded(
            //     child:ListView.builder(
            //         scrollDirection: Axis.vertical,
            //         shrinkWrap: true,
            //         physics: const ClampingScrollPhysics(),
            //         itemCount: _details.length,
            //         // itemExtent: 10.0,
            //         //reverse: true, //makes the list appear in descending order
            //         itemBuilder: (BuildContext context, int index) {
            //           return new Container(
            //             child: Column(
            //               children: <Widget>[
            //                 index !=0?Container(
            //                   margin: EdgeInsets.only(left: 20,right: 20),
            //                   height: 1,
            //                   color: Color(0x331F6E46),
            //                 ):Container(),
            //                 Container(
            //                   padding: EdgeInsets.all(20),
            //                   child: Row(
            //                     mainAxisAlignment: MainAxisAlignment.end,
            //                     children: <Widget>[
            //                       Text(
            //                         _details[index]["value"],
            //                         style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal,fontSize: 14),
            //                       ),

            //                       Text(
            //                         "   :   ",
            //                         style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal,fontSize: 14),
            //                       ),

            //                       Text(
            //                         _details[index]["label"],
            //                         style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal,fontSize: 18),
            //                       ),


            //                     ],

            //                   ),
            //                 ),


            //               ],
            //             ),
            //           );
            //         }
            //     )

            // ),

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

  _onToLog() {
    Navigator.pushReplacement(context,
        new MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));
  }

}




typedef void MyFormCallback(int unit,int count,String id);

// ignore: must_be_immutable
class MyForm extends StatefulWidget {
  final MyFormCallback onSubmit;
  List units;
  String id;

  MyForm({this.onSubmit,this.id,this.units});

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
     _id = widget.id;
    _dropCatsSub = getDropCatsSub();
    _currentCatSub = _values[0];
  }
  int unit_id;

  List<DropdownMenuItem<String>> getDropCatsSub() {
    List<DropdownMenuItem<String>> items = new List();

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






