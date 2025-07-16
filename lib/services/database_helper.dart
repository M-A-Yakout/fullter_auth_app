import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';
import '../models/user_model.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'user_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT UNIQUE,
        email TEXT UNIQUE,
        password TEXT,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
    ''');
  }

  // Hash password for secure storage
  String _hashPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }

  // Insert new user
  Future<int> insertUser(User user) async {
    final db = await database;
    // Hash the password before storing
    final hashedUser = User(
      username: user.username,
      email: user.email,
      password: _hashPassword(user.password),
    );
    return await db.insert('users', hashedUser.toMap());
  }

  // Validate user login
  Future<User?> validateUser(String email, String password) async {
    final db = await database;
    final hashedPassword = _hashPassword(password);
    
    List<Map<String, dynamic>> results = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, hashedPassword],
    );

    return results.isNotEmpty ? User.fromMap(results.first) : null;
  }

  // Check if email already exists
  Future<bool> isEmailTaken(String email) async {
    final db = await database;
    List<Map<String, dynamic>> results = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    return results.isNotEmpty;
  }
} 