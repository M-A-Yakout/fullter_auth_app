import 'package:live_chat/features/posts/models/post_model.dart';
import 'package:sqflite/sqflite.dart';

class PostDao {
  final Database _db;

  PostDao(this._db);

  Future<void> createPost(Post post) async {
    await _db.insert(
      'posts',
      {
        'user_id': post.userId,
        'content': post.content,
        'created_at': post.createdAt.toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Post>> getPosts() async {
    final List<Map<String, dynamic>> maps = await _db.query(
      'posts',
      orderBy: 'created_at DESC',
    );

    return maps.map((map) => Post.fromMap(map)).toList();
  }

  Future<List<Post>> getPostsByUser(int userId) async {
    final List<Map<String, dynamic>> maps = await _db.query(
      'posts',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'created_at DESC',
    );

    return maps.map((map) => Post.fromMap(map)).toList();
  }

  Future<List<Post>> searchPosts(String query) async {
    final List<Map<String, dynamic>> maps = await _db.query(
      'posts',
      where: 'content LIKE ?',
      whereArgs: ['%$query%'],
      orderBy: 'created_at DESC',
    );

    return maps.map((map) => Post.fromMap(map)).toList();
  }
}