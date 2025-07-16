import 'package:flutter/material.dart';
import 'package:live_chat/core/database/database_helper.dart';
import 'package:live_chat/features/auth/models/user_model.dart';
import 'package:live_chat/features/posts/data/post_dao.dart';
import 'package:live_chat/features/posts/models/post_model.dart';


class CreatePostScreen extends StatefulWidget {
  final User user;

  const CreatePostScreen({super.key, required this.user});

  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _contentController = TextEditingController();
  late PostDao _postDao;

  @override
  void initState() {
    super.initState();
    _initDao();
  }

  void _initDao() async {
    final db = await DatabaseHelper.instance.database;
    _postDao = PostDao(db);
  }

  void _submitPost() async {
    final content = _contentController.text;

    if (content.isNotEmpty) {
      final newPost = Post(
        userId: widget.user.id!,
        content: content,
        createdAt: DateTime.now(),
      );
      await _postDao.createPost(newPost);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(
                labelText: 'What\'s on your mind?',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _submitPost,
              child: const Text('Post'),
            ),
          ],
        ),
      ),
    );
  }
}