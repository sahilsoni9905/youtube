import 'package:basic_youtube_clone/bottom_bar.dart';
import 'package:basic_youtube_clone/features/auth/screens/profile_setup_screen.dart';
import 'package:basic_youtube_clone/features/home/screens/add_post_screen.dart';
import 'package:basic_youtube_clone/features/home/screens/video_play_screen.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case HomePage.routeName:
      return MaterialPageRoute(builder: (context) => HomePage());
       case VideoPlayerScreen.routeName:
      final videoUrl = settings.arguments as String;
      return MaterialPageRoute(
          builder: (context) => VideoPlayerScreen(videoUrl: videoUrl,));
    case UserInfoScreen.routeName:
      return MaterialPageRoute(builder: (context) => UserInfoScreen());
        case AddPostScreen.routeName:
      return MaterialPageRoute(builder: (context) => AddPostScreen());
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
