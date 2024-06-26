import 'package:basic_youtube_clone/bottom_bar.dart';
import 'package:basic_youtube_clone/features/auth/repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'features/auth/screens/sign_up_page.dart';

import 'router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://qftpxxinpcmiayaipkas.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFmdHB4eGlucGNtaWF5YWlwa2FzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTkxNDkwNDYsImV4cCI6MjAzNDcyNTA0Nn0.tbTXgDHUPdA--LnHJQ_eFTUYP8kqd9P5Y2z5QWScVtc',
    realtimeClientOptions: const RealtimeClientOptions(
      eventsPerSecond: 1,
    ),
  );

  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      onGenerateRoute: (settings) => generateRoute(settings),
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: ref.watch(userDataAuthProvider).when(
            data: (user) {
              if (user == null) {
                return SignUpPage();
              } else {
                return HomePage(
                  userUid: user.uid.toString(),
                );
              }
            },
            error: (err, trace) {
              return Center(
                child: Text('something went wrong'),
              );
            },
            loading: () => Center(
              child: CircularProgressIndicator(),
            ),
          ),
    );
  }
}
