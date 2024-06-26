import 'dart:io';

import 'package:basic_youtube_clone/bottom_bar.dart';
import 'package:basic_youtube_clone/models/user_models.dart';
import 'package:basic_youtube_clone/utils/snackbar.dart';
import 'package:basic_youtube_clone/utils/upload_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final AuthRepositoryProvider = Provider(
  (ref) => AuthRepository(ref: ref),
);
final userDataAuthProvider = FutureProvider((ref) async {
  return ref.watch(AuthRepositoryProvider).getCurrentUser();
});

class AuthRepository {
  AuthRepository({required this.ref});
  final ProviderRef ref;
  final SupabaseClient supabase = Supabase.instance.client;
  Future<void> signUP(
      {required String email,
      required String password,
      required String name}) async {
    try {
      final response = await supabase.auth.signUp(
        email: email.trim(),
        password: password.trim(),
      );

      if (response.user != null) {
        final user = response.user;
        final userData = UserModel(
          email: email,
          password: password,
          name: name.trim(),
          uid: user!.id,
          profilePic: '',
          postLiked: [],
          postCommented: [],
          subscribedList: [],
          videoUploaded: [],
        );

        final insertResponse =
            await supabase.from('users').insert(userData.toMap());

        if (insertResponse.error != null) {
          debugPrint('Insert error: ${insertResponse.error!.message}');
        } else {
          debugPrint('User data successfully inserted');
        }
      } else {
        debugPrint('Sign-up error: ');
      }
    } on AuthException catch (e) {
      debugPrint('Auth error: ${e.message}');
    }
  }

  Future<void> saveUserData(
      String bio, File photo, BuildContext context) async {
    try {
      String profilePic = await storeFileToStorage(supabase, photo);

      final user = supabase.auth.currentUser;
      if (user != null && user.id != null) {
        final userData = {
          'bio': bio.trim(),
          'profile_pic': profilePic.trim(),
        };

        final response =
            await supabase.from('users').update(userData).eq('uid', user.id);
        print('reached till level 3');

        print('reached till level 4');
        debugPrint('User data successfully updated');
        showSnackBar(context: context, content: 'Data updated successfully');
        Navigator.pushNamedAndRemoveUntil(
            context, HomePage.routeName, (route) => false,
            arguments: user.id);
      } else {
        debugPrint('User not authenticated or user ID not available');
      }
    } catch (e) {
      debugPrint('Error updating user data: $e');
    }
  }

  Future<UserModel?> getCurrentUser() async {
    try {
      print('Checking current user...');
      final user = supabase.auth.currentUser;
      print('Current user: $user'); // Print the current user

      if (user == null) {
        print('jo user hai wo mila hi nhi'); // Print if user is null
        return null;
      }
      print('i am here');
      final response =
          await supabase.from('users').select().eq('uid', user.id).single();

      if (response == null) {
        throw Exception('Error fetching user data: ${response}');
      }
      print('usermodel return ho gya ');
      return UserModel.fromMap(response);
    } catch (e) {
      print('something went wrong while fetching current user data: $e');
      return null;
    }
  }
}
