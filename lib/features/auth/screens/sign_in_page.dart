import 'package:basic_youtube_clone/features/auth/repository/auth_repository.dart';
import 'package:basic_youtube_clone/features/auth/screens/profile_setup_screen.dart';
import 'package:basic_youtube_clone/features/auth/screens/sign_up_page.dart';
import 'package:basic_youtube_clone/models/user_models.dart';
import 'package:basic_youtube_clone/utils/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignInPage extends ConsumerWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final SupabaseClient supabaseClient = Supabase.instance.client;
  static const String routeName = 'sign-in-page';

  void signIn(BuildContext context, WidgetRef ref) async {
    print('Attempting sign-in...');
    try {
      final response = await supabaseClient.auth.signInWithPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (response.user == null) {
        showSnackBar(context: context, content: 'User not found');
      } else {
        Navigator.pushNamedAndRemoveUntil(
          context,
          UserInfoScreen.routeName,
          (Route<dynamic> route) => false,
        );
        print('User signed in successfully');
        try {
          final userProvider = await ref.read(userDataAuthProvider.future);
          UserModel? user = userProvider;
          print('Provider executed, user: $user');

          if (user != null) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              UserInfoScreen.routeName,
              (Route<dynamic> route) => false,
            );
          } else {
            showSnackBar(context: context, content: 'Error fetching user data');
          }
        } catch (providerError) {
          print('Error executing provider: $providerError');
        }
      }
    } catch (error) {
      print('Error signing in: $error');
      showSnackBar(context: context, content: 'Error signing in');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Sign In',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 40),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  signIn(context, ref);
                },
                child: Text('Sign In'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  textStyle: const TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Don\'t have an account?'),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUpPage()),
                      );
                    },
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
