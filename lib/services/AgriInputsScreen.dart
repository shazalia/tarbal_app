import 'dart:async';
import 'dart:collection';

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
  
class AgriInputsScreen extends StatefulWidget {
  
  @override
  _AgriInputsScreenState createState() => new _AgriInputsScreenState();
}

class _AgriInputsScreenState extends State<AgriInputsScreen> {
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




  final String url = "http://turbalkom.falsudan.com/api/forms/fertilisers";
void  getFertilise() async {
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
 
    getFertilise();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text("rfgf"),),
      body://new DropDownClass(name: "k",list: dropdownValue),
      Column(
        children:dropDownsWedgit,
      //    dropDownslist.map((dynamic drop){
      //       return DropDownClass(list: drop,name: "name",);
        



      // }).toList()
    
 
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
                  return  DropdownButton(
                                     hint: Text(name), // Not necessary for Option 1
                                       items: list.map((location) {
                                        return DropdownMenuItem(
                                          child: new Text(location,
                                           style: TextStyle(
                                          color: Colors.black45,
                                          fontSize: 8.0,
                                          letterSpacing: 0.5),
                                          ),
                                          
                                          value: location,
                                        );
                                      }).toList(),
                                  // value: selectedcity,
                                      onChanged: (newValue) {
                              
                                // List<String>  selectedTownList = newValue.toString().split('.');
                                //  globals.selectedTown = selectedTownList [1];
                                //  globals.selectedTownid = selectedTownList [0];
                               
                                //         setState(() {                                        
                                //         }
                                //         );
                                      },
                                    );
  
  }


}