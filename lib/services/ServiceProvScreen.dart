import 'dart:async';
import 'dart:collection';

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
 import 'package:tarbalcom/model/Data.dart';
  
class ServiceProvScreen extends StatefulWidget {
  
  @override
  _ServiceProvScreenState createState() => new _ServiceProvScreenState();
}

class _ServiceProvScreenState extends State<ServiceProvScreen> {
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
      body: Center(
      child:Container(
          padding: EdgeInsets.only(
                                    top: 15.0,
                                    bottom: 5.0,
                                    left: 25.0,
                                    right: 25.0),
          child:     Column(
       
            children:dropDownsWedgit,
     
    )
       
      ),
   )
    );
  }

 
}
class DropDownClass extends StatelessWidget{
  
 
    DropDownClass({Key key,  @required this.name, @required this.list})
     :assert(name!=null), super(key: key);
     final String name;
  final List list;

  @override
  Widget build(BuildContext context) {
   return Container(
     
    width: 300.0,
    child: DropdownButtonHideUnderline(
      child: DropdownButton(
        
     hint: Text(name), // Not necessary for Option 1
                                       items: list.map((location) {
                                        return DropdownMenuItem(
                                          child: new Text(location,
                                                  style: Theme.of(context).textTheme.title,

                                          //  style: TextStyle(
                                          // color: Colors.black45,
                                          // fontSize: 8.0,
                                          // letterSpacing: 0.5),
                                          ),
                                          
                                          value: location,
                                        );
                                      }).toList(),
                                  // value: selectedcity,
                                      onChanged: (newValue) {
                        
                                      },
      ),
    ),
);
  }


}