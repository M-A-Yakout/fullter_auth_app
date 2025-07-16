class Post {
  final int? id;
  final int userId;
  final String content;
  final String? mediaPath;
  final DateTime createdAt;

  Post({
    this.id,
    required this.userId,
    required this.content,
    this.mediaPath,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'content': content,
      'media_path': mediaPath,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      id: map['id'],
      userId: map['user_id'],
      content: map['content'],
      mediaPath: map['media_path'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }
}