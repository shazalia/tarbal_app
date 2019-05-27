import 'Provider.dart';

class Category {
  
    final Map<String,dynamic> provider;
    final List<String> farmArea;
    final List<String> animalNum;
    final List<String> irrigMethod;
    final List<String> sourceIrrig;
    final List<String> powerSource; 
    final List<String> workType;
    final Provider prov;

 
   Category( {this.prov,this.provider, this.farmArea, this.animalNum, this.irrigMethod, this.sourceIrrig,
    this.powerSource, this.workType});
 factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
    prov: Provider.fromJson( json['name'], ),
     provider: parseProvider(json['service_providers_category']), // json['places']);
      farmArea: parseFarmArea(json['farm_area'],),
       animalNum: parseAnimalNum(json['number_of_farm_animals'],),
        irrigMethod: parseIrrigMethod(json['irrigation_method'],),
         sourceIrrig: parseSourceIrrig(json['source_of_irrigation'],),
          powerSource: parsepowerSource(json['power_source'],),
           workType: parseWorkType(json['work_type'],),
    );
  }
  
 
  static Map<String,dynamic> parseProvider(providerJson) {
    Map<String,dynamic> providerList = new Map<String,dynamic>.from(providerJson);
    return providerList;
  }
  static List<String> parseFarmArea(placesJson) {
    List<String> placesList = new List<String>.from(placesJson);
    return placesList;
  }
   static List<String> parseAnimalNum(placesJson) {
    List<String> placesList = new List<String>.from(placesJson);
    return placesList;
  }
   static List<String> parseIrrigMethod(placesJson) {
    List<String> placesList = new List<String>.from(placesJson);
    return placesList;
  }
   static List<String> parseSourceIrrig(placesJson) {
    List<String> placesList = new List<String>.from(placesJson);
    return placesList;
  }
   static List<String> parsepowerSource(placesJson) {
    List<String> placesList = new List<String>.from(placesJson);
    return placesList;
  }
   static List<String> parseWorkType(placesJson) {
    List<String> placesList = new List<String>.from(placesJson);
    return placesList;
  }
}