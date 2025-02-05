class User {
  final String id;
  final String firstname;
  final String lastname;
  final String phone;
  final DateTime birthdate;
  final String username;
  final String? imageRepository;
  final String? imageFileName;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.phone,
    required this.birthdate,
    required this.username,
    this.imageRepository,
    this.imageFileName,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'].toString(),
      firstname: json['firstname'],
      lastname: json['lastname'],
      phone: json['phone'],
      birthdate: DateTime.parse(json['birth_date']),
      username: json['username'],
      imageRepository: json['image_repository'],
      imageFileName: json['image_file_name'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
  static List<User> listFromJson(List<dynamic> list) {
    return list
        .whereType<Map<String, dynamic>>()
        .map((item) => User.fromJson(item))
        .toList();
  }
}
