// import 'package:applanga_flutter/applanga_flutter.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sticky_headers/sticky_headers.dart';
    
class ServiceProvScreen extends StatefulWidget {
  //  final String name;

  // const ServiceProvScreen({Key key, this.name}) :super(key: key);
  @override
  _ServiceProvScreenState createState() => new _ServiceProvScreenState();
}

class _ServiceProvScreenState extends State<ServiceProvScreen> {
    final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();

 
    // List _items  = new List(0),_dets= new List(0),name= new List(0);
    int postStatus;
      int check = 0,isCount = 0;
     String clientId;
 dynamic resultRawMap ;
 List <dynamic> resultRawsList ;
 
      //  final String name;
 
     List<String> userList;
       Map <String, dynamic> dataParent;
       Map <String, dynamic> data;
       List<dynamic> provider;
        List<String> dropdownValue = List();
        List<dynamic> dropdownValueid = List();
        
       List<String> textValue = List();
       List<String> cardValue = List();
      //  List <dynamic> dropDownslist  = List();
       List <String> dropDownsliststring  = List();
       List<Widget> dropDownsWedgit = new List();
       List<Widget> cardWedgit = new List();
        List<Widget> textWedgit = new List();
         

          List <String> temp  = new List();
          String nameId;
          String _selection;


      //  catDetailes _catDetailes;
       Map <String, dynamic> _catDetailes ;
       Map <String, dynamic> _catType ;
       var isLoading = false;


  _ServiceProvScreenState();


  @override
      void initState() {
     
        getCategory();
        // placeOrder();
        // TextClass(name: name);
    
        super.initState();
      }
  _getUser() async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userList = prefs.getStringList("user");
    });
  }
  final String url = "http://www.amock.io/api/shazawdidi/service_providers2";
void  getCategory() async {
    var res = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    var resBody = json.decode(res.body)["data"];
   
  
  
    data=resBody;

    print(data.toString());
   data.forEach((k,v)=> { // ptovider level
     print(k),
     provider=v,

       dropdownValue.clear(),
       dropdownValueid.clear(),

     provider.forEach((v)=>{ // catlist level
 print(v),
     _catDetailes=v,
   _catDetailes.forEach((k1,v1)=>{ 
     nameId=v1.toString(),
    // cat details level
     if(k1==("name")){   
             if(!k.toString().startsWith("n_")){
                // print(k), 
              dropdownValue.add(nameId),
              dropdownValueid.add(v),

             } else   if(k.toString().startsWith("n_")){
                 textWedgit.add(new TextClass(name:k,number: v1.toString(),list:textValue)),       

                // textValue=v1,
               textValue.add(nameId),

     },
     

}
    
   
  //  }),
    //  }),



     }),
    
 // cat details level 
    
     }),// catlist level
             // 

        print ('New Provider List: '),
        print(dropdownValue.toString()), 
 if(!k.toString().startsWith("n_")){
        dropDownsWedgit.add(DropDownClass(name: k,list: dropdownValueid.toList())),       
 }
//  else if(k.toString().startsWith("n_")){
//    textWedgit.add(TextClass(name: k,list:textValue.toList()))

//  }
   // ptovider level
   });

   
     

    //print(resBody);
       setState(() {
        isLoading = false;
      });
  }
  
 
  
   Future placeOrder(String clientId,List serviceProvider,List farmArea,
   List numberFarmAnimals,List irrigationMethod,List irrigationSource
   ,List powerSource,List workType) async {
    final response = await http.post(
      "http://turbalkom.falsudan.com/api/forms/service_providers",
      headers: {
        "Accept": "application/json"
      },
      body: {
        'user_id': clientId,
        'service_providers_category':serviceProvider,
        'farm_area':farmArea.toString(),
        'number_of_farm_animals':numberFarmAnimals.toString(),
        'irrigation_method':irrigationMethod,
        'source_of_irrigation':irrigationSource,
        'power_source':powerSource,
        'work_type':workType,


         
      },
    );

    if (response.body.toString().contains("success")) {
      setState(() {
        postStatus = response.statusCode;
      });

    }
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
    
     
    
          @override
      Widget build(BuildContext context) {
     
       return Scaffold(
                 key: scaffoldKey,
          appBar: AppBar(
            centerTitle: true,
            title: Text('مزوِّدو الخدمة'),
              backgroundColor: Colors.green[900],
          ),
           body:  Center (
             child: Card(
               elevation: 5,
               color: Colors.lightGreen[30],
            child :SingleChildScrollView(
              
                      child: new Form(
                          key: _formKey,

                child: new Column(
                   mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,

                       children: <Widget>[
                         isLoading
            ? Center(
                child: CircularProgressIndicator(),
              ):
                        
                               new Column(
                   mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,

                            children : <Widget>[
                                     Container(
                                       padding: EdgeInsets.only(left: 20,right: 20,bottom:30,top:30),
                                       
                               child:Column(  
                                children:dropDownsWedgit,
                                )
                           ),
                               Container(
                                   
                               child:
                               Text(
                                 " حدد أعداد/أحجام ,موجودات المزرعة ادناه",
                                 textAlign: TextAlign.center,
                                  style: TextStyle(
                                    
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0)
                               )
                           ),
                                     Container(
                               child:Column(  
                                children:textWedgit,
                                )
                           ),
                              Container(
                                 padding: EdgeInsets.only(left: 20,right: 20,bottom:30,top:30),
                               child: Material(
                                  color: Color(0xFF1F6E46),
                                  borderRadius: BorderRadius.circular(30.0),
                                  shadowColor: Colors.green,
                                  elevation: 5.0,
                                  child: MaterialButton(
                                    minWidth: 20,
                                    onPressed: () {
                                      if(isCount == 1){
                                    
                                      }else{
                                        _loading();
                                      }

                                    },
                                    child: Text('انشاء الطلب', style: TextStyle(color: Colors.white)),
                                  ),
                                ),
                      
                           ),
                              ]
                               )
                 
                        //  )
                         ],
                         )

                )
            )
           )
            ),
       
        );
       
       
       }

}
 
class DropDownClass extends StatefulWidget{
  
    DropDownClass({Key key,  @required this.name, @required this.list, this.id,this.number})
     :assert(name!=null||number!=null), super(key: key);
     final String name;
 
  final String number;
  final List list;
  final String id;



 //  final Text name2;
  
  @override
  _DropDownClass createState() => new _DropDownClass(this.name,this.list,this.number);
  
 
  }
  
  class _DropDownClass extends State<DropDownClass> {



          String name;
         final String number;
   final List list;
  

  _DropDownClass(this.name, this.list, this.number);
  
   
 

    @override
    Widget build(BuildContext context) {
      
     return Column(children: <Widget>[
       new Container(
         width: 300.0,
              padding: EdgeInsets.all(20.0),
      //  child: DropdownButtonHideUnderline(
 
        child: new DropdownButton(
           elevation: 2,
                  style: TextStyle(color:Colors.amber , fontSize: 18),
        isDense: true,
        iconSize: 20.0,
        
             hint: Text(name.toString()), 
                         items: list.map((location) {
                           expand: true;
                          return DropdownMenuItem(
                            
                             child: new Text(location['name'].toString(),
                                             style: TextStyle(
                                            color: Color(0xFF880E4F),
                                            fontSize: 10,
                                            letterSpacing: 0.5),
                                            ),
                                            value: location.toString(),
                                            
                                          );
                                          
                                        }).toList(), onChanged: (newValue) {
                                           setState(() {
                                       name =      newValue['name'].toString();   
                                    });

                                         }, 
        ),
      // ),
  
  ),
 
     ],);

    }


}


class TextClass extends StatefulWidget{
  
    TextClass({Key key,  @required this.name, @required this.list, this.id, this.number, this.text})
     :assert(name!=null||number!=null), super(key: key);
     final String name;
 
  final String number;
  final List list;
  final Text text;
 final String id;
 //  final Text name2;
  
  @override
  _TextClass createState() => new _TextClass(this.name,this.list,this.number.toString());
  
 
  }
  
  class _TextClass extends State<TextClass> {



         final String name;
         final String number;
       

 
   final List list;
   int serviceId;
  String _currentCatSub,id;
    static final TextEditingController _name = new TextEditingController();

  _TextClass(this.name, this.list, this.number);
  
   void initState() {
      super.initState();
  
  
  
  }
 
  @override
  Widget build(BuildContext context) {
    return new ListView.builder(itemBuilder: (context, index) {
      return new StickyHeader(
        header: new Container(
          height: 50.0,
          color: Colors.green[200],
          padding: new EdgeInsets.symmetric(horizontal: 16.0),
          alignment: Alignment.centerLeft,
          child: new Text(name.toString(),
            style: const TextStyle(color: Colors.white),
          ),
        ),
        content: new       Container(
            padding: EdgeInsets.only(left:20.0,right:20.0,top:10.0),
             width: 300.0,
      //  child: Padding(
               child: TextFormField(
                controller: _name,
                keyboardType: TextInputType.number,
                autofocus: false,
                textAlign: TextAlign.left,
                  style: TextStyle(color: Color(0xFF880E4F),fontSize: 15,
                  letterSpacing: 0.5),
                decoration: InputDecoration(
                  labelText:(number.toString()),
                  contentPadding:
                  EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                ),
              ),
            // ),
         )
      );
    });
  }
    // @override
    // Widget build(BuildContext context) {
    //    return Column(children: <Widget>[
    //      Container(
    //         padding: EdgeInsets.only(left:20.0,right:20.0,top:10.0),
    //          width: 300.0,
    //   //  child: Padding(
    //            child: TextFormField(
    //             controller: _name,
    //             keyboardType: TextInputType.number,
    //             autofocus: false,
    //             textAlign: TextAlign.left,
    //               style: TextStyle(color: Color(0xFF880E4F),fontSize: 15,
    //               letterSpacing: 0.5),
    //             decoration: InputDecoration(
    //               labelText:(number.toString()),
    //               contentPadding:
    //               EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
    //             ),
    //           ),
    //         // ),
    //      )
    //  ],
    //  );
    // } 
}


