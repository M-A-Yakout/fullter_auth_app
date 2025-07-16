class User {
  final int? id;
  final String username;
  final String email;
  final String password;

  User({
    this.id,
    required this.username,
    required this.email,
    required this.password,
  });

  // Convert User to Map for database insertion
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'password': password,
    };
  }

  // Create User from Map retrieved from database
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      username: map['username'],
      email: map['email'],
      password: map['password'],
    );
  }
} 