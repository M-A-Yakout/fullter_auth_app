import 'package:live_chat/features/posts/models/like_model.dart';
import 'package:sqflite/sqflite.dart';

class LikeDao {
  final Database _db;

  LikeDao(this._db);

  Future<void> likePost(Like like) async {
    await _db.insert('likes', {
      'user_id': like.userId,
      'post_id': like.postId,
      'created_at': like.createdAt.toIso8601String(),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> unlikePost(int userId, int postId) async {
    await _db.delete(
      'likes',
      where: 'user_id = ? AND post_id = ?',
      whereArgs: [userId, postId],
    );
  }

  Future<int> getLikesCount(int postId) async {
    final result = await _db.rawQuery(
      'SELECT COUNT(*) FROM likes WHERE post_id = ?',
      [postId],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<bool> isPostLiked(int userId, int postId) async {
    final result = await _db.query(
      'likes',
      where: 'user_id = ? AND post_id = ?',
      whereArgs: [userId, postId],
    );
    return result.isNotEmpty;
  }
}