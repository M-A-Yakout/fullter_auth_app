import 'package:live_chat/features/posts/models/comment_model.dart';
import 'package:sqflite/sqflite.dart';

class CommentDao {
  final Database _db;

  CommentDao(this._db);

  Future<void> createComment(Comment comment) async {
    await _db.insert(
      'comments',
      {
        'user_id': comment.userId,
        'post_id': comment.postId,
        'content': comment.content,
        'created_at': comment.createdAt.toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Comment>> getCommentsForPost(int postId) async {
    final List<Map<String, dynamic>> maps = await _db.query(
      'comments',
      where: 'post_id = ?',
      whereArgs: [postId],
      orderBy: 'created_at DESC',
    );

    return maps.map((map) => Comment.fromMap(map)).toList();
  }
}