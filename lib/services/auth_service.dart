import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/database_helper.dart';
import '../models/user_model.dart';

class AuthService {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  User? _currentUser;

  User? get currentUser => _currentUser;

  // Validate login credentials
  Future<bool> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      throw 'Email and password cannot be empty';
    }

    final user = await _databaseHelper.validateUser(email, password);
    if (user != null) {
      _currentUser = user;
      return true;
    }
    return false;
  }

  // Register new user
  Future<bool> register(String username, String email, String password) async {
    // Validate inputs
    if (username.length < 3) {
      throw 'Username must be at least 3 characters';
    }

    if (password.length < 6) {
      throw 'Password must be at least 6 characters';
    }

    // Check if email is already taken
    if (await _databaseHelper.isEmailTaken(email)) {
      throw 'Email already in use';
    }

    // Create new user
    final newUser = User(
      username: username,
      email: email,
      password: password,
    );

    try {
      final userId = await _databaseHelper.insertUser(newUser);
      if (userId > 0) {
        _currentUser = newUser;
        return true;
      }
    } catch (e) {
      throw 'Registration failed: ${e.toString()}';
    }

    return false;
  }

  // Logout
  void logout() {
    _currentUser = null;
  }
}

// Riverpod provider for AuthService
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
}); 