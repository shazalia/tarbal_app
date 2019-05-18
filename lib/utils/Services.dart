
class Services {
  final String servicesName;
  final String imageUrl;

  Services({ this.servicesName,this.imageUrl});
  factory Services.fromJson(Map<String ,dynamic>json){
    return Services(
       servicesName:json['name'],
      imageUrl:json['image'],

    );
  }


}