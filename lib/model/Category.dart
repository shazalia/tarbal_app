class Category {
    final int id;
  final String name;
 
   Category({this.id, this.name});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
     id: json['id'] as int,
      name: json['name'],
    );
  }
  
 }
 class Provider {
   final Category category;
 
  Provider({this.category});
 
  factory Provider.fromJson(Map<String, dynamic> json) {
    return Provider(
         category: Category.fromJson(
          json['data']['service_providers_category'],
        ));
  }
}