class User {
  final String token;
  final int user_id;
  final String username;
  final String email;
  final String name;
  final String name_en;
  final String sections;
  final int category_id;
  final String phone;
  final String facebook;
  final String insta;
  final String snap;
  final String location;
  final String image;

  User({this.token, this.username, this.email, this.name, this.name_en,
      this.sections, this.category_id, this.phone, this.facebook, this.insta,
      this.snap, this.location, this.image,this.user_id});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      user_id: json['id'],
      phone: json['phone_number'],
      email: json['email'],
      name: json['full_name'],
      image: json['image'],

    );
  }

  String getName(){
    return name;
  }
}