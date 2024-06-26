import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:basic_youtube_clone/features/home/repository/home_repository.dart';
import 'package:basic_youtube_clone/models/user_models.dart';

class AnotherUserProfileScreen extends ConsumerStatefulWidget {
  static const routeName = 'another-user-profile-screen';
  final String userUid;

  const AnotherUserProfileScreen({Key? key, required this.userUid})
      : super(key: key);

  @override
  ConsumerState<AnotherUserProfileScreen> createState() =>
      _UserProfileScreenState();
}

class _UserProfileScreenState extends ConsumerState<AnotherUserProfileScreen> {
  UserModel? user;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    print('reached till loadUserData');
    user = await ref.read(anotherUserDataAuthProvider(widget.userUid).future);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Profile'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(user!.profilePic),
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    user!.name ?? 'Not found',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    user!.bio ?? 'No bio available',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Divider(height: 1, color: Colors.grey[400]),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String title, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(color: Colors.grey),
        ),
      ],
    );
  }
}
