 import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';



class AgriInputsScreen extends StatefulWidget{


    @override
  _agriInputsScreenState createState() => new _agriInputsScreenState();
}
class _agriInputsScreenState extends State<AgriInputsScreen>{
     final scaffoldKey = new GlobalKey<ScaffoldState>();
    final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
   bool typeValue = false; 
   
   List<String> userList;
   Map <String, dynamic> dataParent;
       Map <String, dynamic> data;
       List<dynamic> services;
        List<String> dropdownValue = List();
       List<String> textValue = List();
       List<String> cardValue = List();
       List <String> dropDownsliststring  = List();
       List<Widget> dropDownsWedgit = new List();
       List<Widget> checkBoxWedgit = new List();
        List<Widget> textFieldWedgit = new List();
  Widget checkbox(String title, bool boolValue) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(title),
        Checkbox(
          value: boolValue,
          onChanged: (bool value) {},
        )
      ],
    );
  }
          List <String> temp  = new List();
          Map <String, dynamic> _servicesDetailes ;
           var isLoading = false;

  _getUser() async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userList = prefs.getStringList("user");
    });
  }
    @override
      void initState() {
     
        getServices();
    
        super.initState();
      }
 final String url = "http://www.amock.io/api/shazawdidi/api/forms/fertilisers";
void  getServices() async {
    var res = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    var resBody = json.decode(res.body)["data"];
    
    data=resBody;

    print(data.toString());
   data.forEach((k,v)=> { // ptovider level
     print(k),
     services=v,

       dropdownValue.clear(),

     services.forEach((v)=>{ // catlist level
 print(v),
     _servicesDetailes=v,
   _servicesDetailes.forEach((k1,v1)=>{ 
      if(k1==("name")){   
             if(!k.toString().startsWith("n_")){
                print(k), 
              dropdownValue.add(v1),
             } else   if(k.toString().startsWith("n_")){
                textValue.add(v1),

     },
                  textFieldWedgit.add(new TextFieldClass(number: v1.toString(),list:textValue.toList())),       

     
 } 
 
     }),  // serv level
     }), // serv details level 
          print ('New Provider List: '),
        print(dropdownValue.toString()), 
 if(!k.toString().startsWith("n_")){
                  dropDownsWedgit.add(DropDownClass(name: k,list: dropdownValue.toList())),       
 }
 
 
   });

    //print(resBody);
       setState(() {
        isLoading = false;
      });
  }




  @override
  Widget build(BuildContext context) {
     return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("مدخلات الانتاج"),
       backgroundColor: Color(0xFF1F6E46),
      ),
      body: Center(
        child: Card(
          child: SingleChildScrollView(
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
                               child:Column(  
                                children:dropDownsWedgit,
                                )
                           ),

                           
                               Container(
                               child:
                               Text(
                                 " حدد الكمية المطلوبة ومساحتك بالفدان",
                                 textAlign: TextAlign.center,
                                  style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0)
                               )
                           ),
                                     Container(
                               child:Column(  
                                children:textFieldWedgit,
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

          ),
        ),
      ),

    );
  }
  

}
class DropDownClass extends StatefulWidget{
   final String name;
   final String number;
   final List list;

  const DropDownClass({Key key, this.name, this.number, this.list}) : super(key: key);
  @override
  _DropDownClass createState() => new _DropDownClass(this.name,this.number,this.list);

  
}
  
  class _DropDownClass extends State<DropDownClass> {
  _DropDownClass(this.name, this.number, this.list);

      final String name;
         final String number;
            final List list;
            String _selection;

  @override
  Widget build(BuildContext context) {
      return Column(children: <Widget>[
       new Container(
              padding: EdgeInsets.all(20.0),
       child: DropdownButtonHideUnderline(
        child: DropdownButton(
                  elevation: 2,
                  style: TextStyle(color:Colors.amber , fontSize: 18),
        isDense: true,
        iconSize: 20.0,
          disabledHint: Text("يجب اختيار خيار من بين الخيارات."),
       hint: Text(name), 
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
                                        }).toList(), onChanged: (value) {
                                          _selection=value;
                                        }, 
                                        
                                                     

        ),
      ),
  
  ),
 
     ],);

  }
  }
  class TextFieldClass extends StatefulWidget{
   final String name;
   final String number;
   final List list;

  const TextFieldClass({Key key, this.name, this.number, this.list}) : super(key: key);
  @override
  _textFieldClass createState() => new _textFieldClass(this.name,this.number,this.list);

  
}
  
  class _textFieldClass extends State<TextFieldClass> {
  _textFieldClass(this.name, this.number, this.list);

      final String name;
         final String number;
            final List list;

  @override
  Widget build(BuildContext context) {
 return Column(children: <Widget>[
            
      
       Container(
              padding: EdgeInsets.only(left: 40.0,right: 40.0,bottom: 10),
 
    child:TextFormField(
     style: TextStyle(
        color: Colors.black,fontWeight: FontWeight.w300,
    ),
  decoration: InputDecoration(
    labelText:(number.toString()),
  ),
  keyboardType: TextInputType.number
   )
    ),  
     ],
     );
   
    
  }
  }
  class CheckBoxClass extends StatefulWidget{
   final String name;
   final String number;
   final List list;

  const CheckBoxClass({Key key, this.name, this.number, this.list}) : super(key: key);
  @override
  _checkBoxClass createState() => new _checkBoxClass(this.name,this.number,this.list);

  
}
  
  class _checkBoxClass extends State<CheckBoxClass> {
  _checkBoxClass(this.name, this.number, this.list);

      final String name;
         final String number;
            final List list;

  @override
  Widget build(BuildContext context) {
 return Column(children: <Widget>[
            
      
       Container(
              padding: EdgeInsets.only(left: 40.0,right: 40.0,bottom: 10),
 
    child:TextFormField(
     style: TextStyle(
        color: Colors.black,fontWeight: FontWeight.w300,
    ),
  decoration: InputDecoration(
    labelText:(number.toString()),
  ),
  keyboardType: TextInputType.number
   )
    ),  
     ],
     );
   
    
  }
  }
  
  
  