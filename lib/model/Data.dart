 
class Data {
  
 final String id;
  final String name;
   final List<Provider> provider;

 
 
      Data({this.id, this.name, this.provider});

factory Data.fromJson(Map<String, dynamic> parsedJson){

  return Data(
   
    // provider: parsedJson['service_providers_category']
  );
}


  
}

class Provider {

    final List<catDetailes> cato;
  Provider({this.cato});
factory Provider.fromJson(List<dynamic> parsedJson) {

    List<catDetailes> cato = new List<catDetailes>();

    return new Provider(
       cato: cato,
    );
  }
  }
  class catDetailes {
   final int id;
  final String name;

  catDetailes({this.id, this.name});
  factory catDetailes.fromJson(Map<String, dynamic> parsedJson){
 return catDetailes(
   id:parsedJson['id'],
   name:parsedJson['name']
 );
}
}