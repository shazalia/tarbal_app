
class Services {
  final int servicesId;
  final String servicesName;

  Services({this.servicesId, this.servicesName});
  factory Services.fromJson(Map<String ,dynamic>json){
    return Services(
      servicesId:json['id'],
      servicesName:json['name'],

    );
  }


}