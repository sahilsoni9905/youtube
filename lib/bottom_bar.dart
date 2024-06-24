import 'package:basic_youtube_clone/features/home/screens/add_post_screen.dart';
import 'package:basic_youtube_clone/features/home/screens/feed_screen.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  static const String routeName = 'home-page';
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search',
            border: InputBorder.none,
            prefixIcon: Icon(Icons.search),
            suffixIcon: IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                _searchController.clear();
              },
            ),
          ),
        ),
      ),
      body: FeedScreen(),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(Icons.add_circle),
              onPressed: () {
                Navigator.pushNamed(context, AddPostScreen.routeName);
              },
            ),
            IconButton(
                onPressed: () {
                  //  Navigator.pushNamed(context, UserProfileScreen.routeName);
                },
                icon: Icon(Icons.person))
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
