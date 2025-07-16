import 'package:sqflite/sqflite.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

import '../../../core/database/database_helper.dart';
import '../models/user_model.dart';

class UserDao {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  // Hash password using SHA-256
  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  // Create a new user
  Future<User> createUser({
    required String username,
    required String email,
    required String password,
    String? profilePicture,
    String? bio,
  }) async {
    final db = await _databaseHelper.database;
    
    // Hash the password before storing
    final passwordHash = _hashPassword(password);

    final user = User(
      username: username,
      email: email,
      passwordHash: passwordHash,
      profilePicture: profilePicture,
      bio: bio,
      createdAt: DateTime.now(),
    );

    final id = await db.insert('users', user.toMap(), 
      conflictAlgorithm: ConflictAlgorithm.fail);

    return user.copyWith(id: id);
  }

  // Authenticate user
  Future<User?> authenticateUser(String email, String password) async {
    final db = await _databaseHelper.database;
    final passwordHash = _hashPassword(password);

    final results = await db.query(
      'users', 
      where: 'email = ? AND password_hash = ?', 
      whereArgs: [email, passwordHash]
    );

    return results.isNotEmpty ? User.fromMap(results.first) : null;
  }

  // Get user by ID
  Future<User?> getUserById(int userId) async {
    final db = await _databaseHelper.database;
    final results = await db.query(
      'users', 
      where: 'id = ?', 
      whereArgs: [userId]
    );

    return results.isNotEmpty ? User.fromMap(results.first) : null;
  }

  // Update user profile
  Future<User> updateUser(User user) async {
    final db = await _databaseHelper.database;
    await db.update(
      'users', 
      user.toMap(), 
      where: 'id = ?', 
      whereArgs: [user.id]
    );
    return user;
  }

  // Check if username or email already exists
  Future<bool> isUserExists(String username, String email) async {
    final db = await _databaseHelper.database;
    final usernameResults = await db.query(
      'users', 
      where: 'username = ?', 
      whereArgs: [username]
    );
    final emailResults = await db.query(
      'users', 
      where: 'email = ?', 
      whereArgs: [email]
    );

    return usernameResults.isNotEmpty || emailResults.isNotEmpty;
  }

  // Delete user
  Future<void> deleteUser(int userId) async {
    final db = await _databaseHelper.database;
    await db.delete(
      'users', 
      where: 'id = ?', 
      whereArgs: [userId]
    );
  }

  // Search for users
  Future<List<User>> searchUsers(String query) async {
    final db = await _databaseHelper.database;
    final results = await db.query(
      'users',
      where: 'username LIKE ?',
      whereArgs: ['%$query%'],
    );

    return results.map((map) => User.fromMap(map)).toList();
  }
}