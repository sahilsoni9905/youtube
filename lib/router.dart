import 'package:basic_youtube_clone/bottom_bar.dart';
import 'package:basic_youtube_clone/features/auth/screens/profile_setup_screen.dart';
import 'package:basic_youtube_clone/features/auth/screens/sign_in_page.dart';
import 'package:basic_youtube_clone/features/home/screens/add_post_screen.dart';
import 'package:basic_youtube_clone/features/home/screens/profile_screen.dart';
import 'package:basic_youtube_clone/features/home/screens/video_play_screen.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case HomePage.routeName:
      final useruid = settings.arguments as String;
      return MaterialPageRoute(
          builder: (context) => HomePage(
                userUid: useruid,
              ));
    case VideoPlayerScreen.routeName:
      final videoUrl = settings.arguments as String;
      return MaterialPageRoute(
          builder: (context) => VideoPlayerScreen(
                videoUrl: videoUrl,
              ));
    case UserInfoScreen.routeName:
      return MaterialPageRoute(builder: (context) => UserInfoScreen());
    case AddPostScreen.routeName:
      return MaterialPageRoute(builder: (context) => AddPostScreen());
    case AnotherUserProfileScreen.routeName:
      final userUid = settings.arguments as String;
      return MaterialPageRoute(
          builder: (context) => AnotherUserProfileScreen(
                userUid: userUid,
              ));
    case SignInPage.routeName:
      return MaterialPageRoute(builder: (context) => SignInPage());
    default:
      return MaterialPageRoute(
        builder: (context) => Scaffold(
          body: Center(
            child: Text('Something gone wrong'),
          ),
        ),
      );
  }
}
