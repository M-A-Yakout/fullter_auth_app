import 'package:flutter/foundation.dart';

@immutable
class User {
  final int? id;
  final String username;
  final String email;
  final String passwordHash;
  final String? profilePicture;
  final String? bio;
  final DateTime? createdAt;

  const User({
    this.id,
    required this.username,
    required this.email,
    required this.passwordHash,
    this.profilePicture,
    this.bio,
    this.createdAt,
  });

  // Convert User object to a map for database insertion
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'password_hash': passwordHash,
      'profile_picture': profilePicture,
      'bio': bio,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  // Create a User object from a map (database query result)
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as int?,
      username: map['username'] as String,
      email: map['email'] as String,
      passwordHash: map['password_hash'] as String,
      profilePicture: map['profile_picture'] as String?,
      bio: map['bio'] as String?,
      createdAt: map['created_at'] != null 
        ? DateTime.parse(map['created_at'] as String) 
        : null,
    );
  }

  // Create a copy of the user with optional field updates
  User copyWith({
    int? id,
    String? username,
    String? email,
    String? passwordHash,
    String? profilePicture,
    String? bio,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      passwordHash: passwordHash ?? this.passwordHash,
      profilePicture: profilePicture ?? this.profilePicture,
      bio: bio ?? this.bio,
      createdAt: createdAt ?? this.createdAt,
    );
  }
} 