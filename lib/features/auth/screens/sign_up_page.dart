import 'package:basic_youtube_clone/bottom_bar.dart';
import 'package:basic_youtube_clone/features/auth/repository/auth_repository.dart';
import 'package:basic_youtube_clone/features/auth/screens/profile_setup_screen.dart';
import 'package:basic_youtube_clone/features/auth/screens/sign_in_page.dart';
import 'package:basic_youtube_clone/utils/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignUpPage extends ConsumerWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final SupabaseClient supabase = Supabase.instance.client;

  Future<void> signUp(WidgetRef ref, String email, String password, String name,
      BuildContext context) async {
    if (name.isEmpty) {
      showSnackBar(context: context, content: 'Name cannot be empty');
      return;
    }

    if (email.isEmpty) {
      showSnackBar(context: context, content: 'Enter a valid email address');
      return;
    }

    if (password.isEmpty || password.length < 6) {
      showSnackBar(
          context: context,
          content: 'Password must be at least 6 characters long');
      return;
    }
    ref
        .read(AuthRepositoryProvider)
        .signUP(email: email, password: password, name: name);
    showSnackBar(context: context, content: 'Account Successfully created');
    Navigator.pushNamed(
      context,
      SignInPage.routeName,
    );
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
                'Sign Up',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 40),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              const SizedBox(height: 20),
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
                onPressed: () async {
                  await signUp(ref, emailController.text,
                      passwordController.text, nameController.text, context);
                },
                child: Text('Sign Up'),
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
                  const Text('Already have an account?'),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, SignInPage.routeName);
                    },
                    child: const Text(
                      'Sign In',
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
