import 'package:flutter/material.dart';
import 'package:live_chat/core/database/database_helper.dart';
import 'package:live_chat/features/posts/data/post_dao.dart';
import 'package:live_chat/features/auth/models/user_model.dart';
import 'package:live_chat/features/posts/models/post_model.dart';
import 'package:live_chat/features/posts/screens/create_post_screen.dart';
import 'package:live_chat/features/posts/widgets/post_list.dart';

class PostScreen extends StatefulWidget {
  final User user;

  const PostScreen({super.key, required this.user});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  late PostDao _postDao;
  List<Post> _posts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initDao();
  }

  void _initDao() async {
    final db = await DatabaseHelper.instance.database;
    _postDao = PostDao(db);
    await _loadPosts();
  }

  Future<void> _loadPosts() async {
    try {
      final posts = await _postDao.getPosts();
      if (mounted) {
        setState(() {
          _posts = posts;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      debugPrint('Error loading posts: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: _loadPosts,
              child: _posts.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.post_add_outlined,
                            size: 64,
                            color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No posts yet',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Be the first to share something!',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                          ),
                        ],
                      ),
                    )
                  : PostList(posts: _posts, currentUser: widget.user),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreatePostScreen(user: widget.user),
            ),
          );
          if (result == true) {
            _loadPosts();
          }
        },
        icon: const Icon(Icons.add),
        label: const Text('New Post'),
      ),
    );
  }
}