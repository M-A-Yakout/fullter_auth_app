import 'package:flutter/material.dart';
import 'package:live_chat/core/database/database_helper.dart';
import 'package:live_chat/features/auth/models/user_model.dart';
import 'package:live_chat/features/posts/data/like_dao.dart';
import 'package:live_chat/features/posts/models/like_model.dart';
import 'package:live_chat/features/posts/models/post_model.dart';
import 'package:live_chat/features/posts/screens/comment_screen.dart';

class PostList extends StatelessWidget {
  final List<Post> posts;
  final User currentUser;

  const PostList({super.key, required this.posts, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true, // Add this to prevent unbounded height
      physics: const NeverScrollableScrollPhysics(), // Add this to prevent nested scrolling
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        return PostCard(post: post, currentUser: currentUser);
      },
    );
  }
}

class PostCard extends StatefulWidget {
  final Post post;
  final User currentUser;

  const PostCard({super.key, required this.post, required this.currentUser});

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  late LikeDao _likeDao;
  int _likeCount = 0;
  bool _isLiked = false;

  @override
  void initState() {
    super.initState();
    _initDao();
  }

  void _initDao() async {
    final db = await DatabaseHelper.instance.database;
    _likeDao = LikeDao(db);
    _loadLikeInfo();
  }

  void _loadLikeInfo() async {
    final likeCount = await _likeDao.getLikesCount(widget.post.id!);
    final isLiked = await _likeDao.isPostLiked(widget.currentUser.id!, widget.post.id!);
    setState(() {
      _likeCount = likeCount;
      _isLiked = isLiked;
    });
  }

  void _toggleLike() async {
    if (_isLiked) {
      await _likeDao.unlikePost(widget.currentUser.id!, widget.post.id!);
    } else {
      final newLike = Like(
        userId: widget.currentUser.id!,
        postId: widget.post.id!,
        createdAt: DateTime.now(),
      );
      await _likeDao.likePost(newLike);
    }
    _loadLikeInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Theme.of(context).primaryColor.withOpacity(0.2),
                  child: Text(
                    widget.post.userId.toString()[0].toUpperCase(),
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'User ${widget.post.userId}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      _formatDate(widget.post.createdAt),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              widget.post.content,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                InkWell(
                  onTap: _toggleLike,
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Icon(
                          _isLiked ? Icons.favorite : Icons.favorite_border,
                          color: _isLiked ? Colors.red : Colors.grey,
                          size: 20,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _likeCount.toString(),
                          style: TextStyle(
                            color: _isLiked ? Colors.red : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CommentScreen(
                          postId: widget.post.id!,
                          currentUser: widget.currentUser,
                        ),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          color: Colors.grey,
                          size: 20,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Comment',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 7) {
      return '${date.day}/${date.month}/${date.year}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}