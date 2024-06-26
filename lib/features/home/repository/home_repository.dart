import 'dart:io';

import 'package:basic_youtube_clone/bottom_bar.dart';
import 'package:basic_youtube_clone/models/post_models.dart';
import 'package:basic_youtube_clone/models/user_models.dart';
import 'package:basic_youtube_clone/utils/snackbar.dart';
import 'package:basic_youtube_clone/utils/upload_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

final anotherUserDataAuthProvider =
    FutureProvider.family<UserModel?, String>((ref, userUid) async {
  return ref.watch(HomeRepositoryProvider).getAnotherUser(userUid);
});

final HomeRepositoryProvider = Provider((ref) => HomeRepository(ref: ref));

class HomeRepository {
  HomeRepository({required this.ref});

  final ProviderRef ref;
  final SupabaseClient supabase = Supabase.instance.client;

  Future<void> saveUserData(
      String name, File photo, BuildContext context) async {
    try {
      String profilePic = await storeFileToStorage(supabase, photo);

      final user = supabase.auth.currentUser;
      if (user != null && user.id != null) {
        final userData = {
          'name': name.trim(),
          'profile_pic': profilePic.trim(),
        };

        final response =
            await supabase.from('users').update(userData).eq('uid', user.id);

        if (response.error != null) {
          debugPrint('Update error: ${response.error!.message}');
        } else {
          debugPrint('User data successfully updated');
          showSnackBar(context: context, content: 'Data updated successfully');
          Navigator.pushNamedAndRemoveUntil(
              context, HomePage.routeName, (route) => false);
        }
      } else {
        debugPrint('User not authenticated or user ID not available');
      }
    } catch (e) {
      debugPrint('Error updating user data: $e');
    }
  }

  Future<bool> isLiked(String postUid) async {
    UserModel? user = await getCurrentUser();
    if (user != null) {
      final response = await supabase
          .from('posts')
          .select('people_who_liked')
          .eq('uid', postUid)
          .single();

      if (response == null) {
        print('Error fetching post: ');
        return false;
      }

      final post = response;
      List<dynamic> peopleWhoLiked = post['people_who_liked'] ?? [];

      return peopleWhoLiked.contains(user.uid);
    } else {
      print('Error: No user found.');
      return false;
    }
  }

  Future<void> likeUpdate(String postUid, bool alreadyLiked) async {
    UserModel? user = await getCurrentUser();
    if (user != null) {
      final response =
          await supabase.from('posts').select().eq('uid', postUid).single();

      final post = response;
      List<dynamic> peopleWhoLiked = post['people_who_liked'] ?? [];

      if (alreadyLiked) {
        peopleWhoLiked.remove(user.uid);
      } else {
        peopleWhoLiked.add(user.uid);
      }

      final updateResponse = await supabase
          .from('posts')
          .update({'people_who_liked': peopleWhoLiked}).eq('uid', postUid);

      if (updateResponse.error != null) {
        print('Error updating likes: ${updateResponse.error!.message}');
      } else {
        print('Post likes updated successfully.');
      }
    } else {
      print('Error: No user found.');
    }
  }

  Future<int> numberOfLikes(String postUid) async {
    final num =
        await supabase.from('posts').select().eq('uid', postUid).single();
    return num.length;
  }

  Future<void> saveUserVideo(
      File file, String description, BuildContext context) async {
    try {
      var uuid = const Uuid();
      String reelUid = uuid.v4(); // Generates a unique ID

      var link = await storeVideoToStorage(supabase, file);

      if (link == null) {
        showSnackBar(context: context, content: 'Oops file was not uploaded ');
        return;
      }
      UserModel? userDetails = await getCurrentUser();
      if (userDetails == null) {
        showSnackBar(context: context, content: 'sonething went wrong');
        return;
      }
      var postModel = PostModel(
        ownerProfilePic: userDetails?.profilePic ?? '',
        ownerUserName: userDetails?.name ?? '',
        uid: reelUid,
        ownerUid: userDetails?.uid ?? '',
        postLink: link,
        numberOfLikes: 0,
        peopleWhoLiked: [],
        description: description,
        uploadedTime: DateTime.now(),
      );

      await supabase.from('posts').insert(postModel.toMap());
      showSnackBar(context: context, content: 'Post Uploaded Successfully');
      Navigator.pushNamed(context, HomePage.routeName);
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  Future<UserModel?> getCurrentUser() async {
    try {
      final user = supabase.auth.currentUser;

      if (user == null) {
        return null;
      }

      final response =
          await supabase.from('users').select().eq('uid', user.id).single();

      if (response == null) {
        throw Exception('Error fetching user data: ${response}');
      }

      return UserModel.fromMap(response);
    } catch (e) {
      //  showSnackBar(context: context, content: e.toString());
      print('error in fetching current user');
      return null;
    }
  }

  Future<UserModel?> getAnotherUser(String anotherUserUid) async {
    try {
      final user = supabase.auth.currentUser;

      if (user == null) {
        return null;
      }

      final response =
          await supabase.from('users').select().eq('uid', user.id).single();

      if (response == null) {
        throw Exception('Error fetching user data: ${response}');
      }

      return UserModel.fromMap(response);
    } catch (e) {
      //  showSnackBar(context: context, content: e.toString());
      print('error in fetching current user');
      return null;
    }
  }
}
