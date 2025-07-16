class Like {
  final int? id;
  final int userId;
  final int postId;
  final DateTime createdAt;

  Like({
    this.id,
    required this.userId,
    required this.postId,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'post_id': postId,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory Like.fromMap(Map<String, dynamic> map) {
    return Like(
      id: map['id'],
      userId: map['user_id'],
      postId: map['post_id'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }
}