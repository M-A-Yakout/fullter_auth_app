class Comment {
  final int? id;
  final int userId;
  final int postId;
  final String content;
  final DateTime createdAt;

  Comment({
    this.id,
    required this.userId,
    required this.postId,
    required this.content,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'post_id': postId,
      'content': content,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      id: map['id'],
      userId: map['user_id'],
      postId: map['post_id'],
      content: map['content'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }
}