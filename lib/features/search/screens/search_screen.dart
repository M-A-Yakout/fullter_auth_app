import 'package:flutter/material.dart';
import 'package:live_chat/core/database/database_helper.dart';
import 'package:live_chat/features/auth/data/user_dao.dart';
import 'package:live_chat/features/auth/models/user_model.dart';
import 'package:live_chat/features/posts/data/post_dao.dart';
import 'package:live_chat/features/posts/models/post_model.dart';
import 'package:live_chat/features/posts/widgets/post_list.dart';
import 'package:live_chat/features/profile/screens/profile_screen.dart';

class SearchScreen extends StatefulWidget {
  final User currentUser;

  const SearchScreen({super.key, required this.currentUser});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  late UserDao _userDao;
  late PostDao _postDao;
  List<User> _users = [];
  List<Post> _posts = [];

  @override
  void initState() {
    super.initState();
    _initDaos();
  }

  void _initDaos() async {
    final db = await DatabaseHelper.instance.database;
    _userDao = UserDao();
    _postDao = PostDao(db);
  }

  void _search() async {
    final query = _searchController.text;
    if (query.isNotEmpty) {
      final users = await _userDao.searchUsers(query);
      final posts = await _postDao.searchPosts(query);
      setState(() {
        _users = users;
        _posts = posts;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search for users or posts',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _search,
                ),
              ),
              onSubmitted: (_) => _search(),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                if (_users.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Users', style: Theme.of(context).textTheme.titleLarge),
                  ),
                ..._users.map((user) => ListTile(
                      title: Text(user.username),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfileScreen(user: user),
                          ),
                        );
                      },
                    )),
                if (_posts.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Posts', style: Theme.of(context).textTheme.titleLarge),
                  ),
                PostList(posts: _posts, currentUser: widget.currentUser),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}