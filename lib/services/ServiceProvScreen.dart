// import 'package:applanga_flutter/applanga_flutter.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
    
class ServiceProvScreen extends StatefulWidget {
  
  @override
  _ServiceProvScreenState createState() => new _ServiceProvScreenState();
}

class _ServiceProvScreenState extends State<ServiceProvScreen> {
    List _items  = new List(0),_dets= new List(0),name= new List(0);
    int postStatus;
      int check = 0,isCount = 0;
     String clientId;
      List serviceProvider,
       farmArea,
       numberFarmAnimals,
       irrigationMethod,
       irrigationSource,
       powerSource,
       workType;
 
     List<String> userList;
       Map <String, dynamic> dataParent;
       Map <String, dynamic> data;
       List<dynamic> provider;
       List<String> dropdownValue = List();
       List <dynamic> dropDownslist  = List();
       List <String> dropDownsliststring  = List();
       List<Widget> dropDownsWedgit = new List();
          List <String> temp  = new List();


      //  catDetailes _catDetailes;
       Map <String, dynamic> _catDetailes ;



  _getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userList = prefs.getStringList("user");
    });
  }
  final String url = "http://turbalkom.falsudan.com/api/forms/service_providers";
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

     provider.forEach((v)=>{ // catlist level
      //  _catDetailes=new catDetailes.fromJson(json.decode(v.toString())),
      //  print(_catDetailes.name),
      _catDetailes=v,
   
   _catDetailes.forEach((k1,v1)=>{ // cat details level
     if(k1=="name"){
       print(v1),
       
       dropdownValue.add(v1.toString()),
        
     }
   
  
     }),// cat details level 
    
     }),// catlist level
   
        print ('New Provider List: '),
        print(dropdownValue.toString()), 

        dropDownsliststring.add(dropdownValue.toString()),
     
        dropDownsWedgit.add(DropDownClass(name: k,list: dropdownValue.toList())),
       
   
   // ptovider level
   });

   
      setState(() {
     });

    //print(resBody);

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


      List _irrigationMethod = new List(0),_serviceProvider = new List(0),_farmArea= new List(0),_numberFarmAnimals= new List(0),
       _irrigationSource = new List(0),_powerSource = new List(0),
       _workType = new List(0);

   void onSubmit(String clientId,List  serviceProvider,List farmArea,
   List numberFarmAnimals,List irrigationMethod,List irrigationSource,
    List powerSource,List workType) {

    _loading();
    postCategory(clientId,serviceProvider,farmArea,
    numberFarmAnimals,irrigationMethod,irrigationSource
    ,powerSource,workType).whenComplete(() {
          if (postStatus == 200) {
            Navigator.pop(context);
            _alert("نجاح","تم انشاء طلبك بنجاح \n ستتواصل معك الادارة");
    
          } else {
            Navigator.pop(context);
            _alert("خطأ","حدث خطأ ما \n يرجى المحاولة مرة اخرى");
          }
        });
    
     
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
      void initState() {
     
        getCategory();
    
        super.initState();
      }
          @override
      Widget build(BuildContext context) {
       return Scaffold(
          appBar: AppBar(
            title: Text('مزوِّدو الخدمة'),
              backgroundColor: Color(0xFF1F6E46),
          ),
           body:  Center (
            child :SingleChildScrollView(
			 
                child: new Column(
                   mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                       children: <Widget>[
                              Container(
                                
                               child:Column(  
                                children:dropDownsWedgit,
                                )
                           ),
                              Container(
                                 padding: EdgeInsets.only(left: 20,right: 20,bottom:30),
                               child: Material(
                                  color: Color(0xFF1F6E46),
                                  borderRadius: BorderRadius.circular(30.0),
                                  shadowColor: Colors.green,
                                  elevation: 5.0,
                                  child: MaterialButton(
                                    minWidth: 20,
                                    onPressed: () {
                                      if(isCount == 1){
                                        showDialog(
                                          // this.farmArea, this.numberFarmAnimals, this.irrigationMethod, this.irrigationSource, this.powerSource, this.workType
                                            context: context, child: new DropDownClass(onSubmit: onSubmit,id: clientId, farmArea: _farmArea, irrigationMethod: _irrigationMethod,
                                             irrigationSource:_irrigationSource, name: null, numberFarmAnimals: _numberFarmAnimals,
                                              powerSource: _powerSource, serviceProvider: _serviceProvider, workType: _workType,

                                            // 
                                            
                                            ));
                                      }else{
                                        _loading();
                                        placeOrder(clientId,serviceProvider,farmArea
                                        ,numberFarmAnimals,irrigationMethod,irrigationSource
                                        ,powerSource,workType).whenComplete(() {
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
                      
                           ),
                     
                 
                     ],

                )
			 
            ),
       
        ),
       );
      }
    
     
      postCategory(String clientId,List  serviceProvider,List farmArea,
   List numberFarmAnimals,List irrigationMethod,List irrigationSource,
    List powerSource,List workType) {}

 



}
typedef void MyFormCallback(String clientId,List  serviceProvider,List farmArea,
   List numberFarmAnimals,List irrigationMethod,List irrigationSource,
    List powerSource,List workType);
class DropDownClass extends StatefulWidget{
    final MyFormCallback onSubmit;
 
    DropDownClass({Key key,  @required this.name, @required this.list, this.onSubmit, this.id, 
     @required this.serviceProvider,@required this.farmArea,@required this.numberFarmAnimals
     ,@required this.irrigationMethod,
    @required this.irrigationSource,@required this.powerSource,@required this.workType})
     :assert(name!=null), super(key: key);
     final String name;
      final List serviceProvider;
        final List farmArea;
        final List numberFarmAnimals;
        final List irrigationMethod;
        final List irrigationSource;
        final List powerSource;
       final List  workType;
 
  final List list;
 final String id;
  
  @override
  _DropDownClass createState() => new _DropDownClass(this.name,this.list);
  
 
  }
  
  class _DropDownClass extends State<DropDownClass> {
         final String name;
         List _serviceProvider;
         List _farmArea;
         List _numberFarmAnimals;
         List _irrigationMethod;
         List _irrigationSource;
         List _powerSource;
         List  _workType;
         List _values;

 
   final List list;
   int serviceId;
  String _currentCatSub,id;

  _DropDownClass(this.name, this.list);
  
   void initState() {
      super.initState();
 
  
  
  }
  void changedDropDownItemSub(String selectedCat) {
    setState(() {
      _currentCatSub = selectedCat;
      for(int x=1;x<_values.length;x++){
        if(_values[x] == selectedCat){
          serviceId = x;
        }
      }
    }
    );
  }

    @override
    Widget build(BuildContext context) {
      
     return Container(
             padding: EdgeInsets.only(left: 20.0,right: 20.0,bottom: 10),
       child: DropdownButtonHideUnderline(
        child: DropdownButton(
       hint: Text(name), // Not necessary for Option 1
                         items: list.map((location) {
                          return DropdownMenuItem(
                             child: new Text(location,
                                             style: TextStyle(
                                            color: Color(0xFF880E4F),
                                            fontSize: 8.0,
                                            letterSpacing: 0.5),
                                            ),
                                            value: location,
                                          );
                                        }).toList(),
                                        //  value: _currentCatSub,
                                    // value: selectedcity,
                                        onChanged: (changedDropDownItemSub) {
                          
                                        },
                                        
                                    // onChanged: changedDropDownItemSub,

        ),
      ),
  
  );
    }
  
  
}