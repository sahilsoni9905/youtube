import 'package:basic_youtube_clone/features/home/widgets/video_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FeedScreen extends ConsumerWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SupabaseClient supabaseClient = Supabase.instance.client;

    return Scaffold(
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: supabaseClient
            .from('posts')
            .stream(primaryKey: ['id'])
            .order('uploaded_time', ascending: false)
            .execute(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('An error occurred: ${snapshot.error}'),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No posts available'),
            );
          }

          var posts = snapshot.data!;

          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              var postData = posts[index];
              if (postData == null) {
                return const SizedBox(); // Handle null post data
              }
              return Column(
                children: [
                  VideoCard(snap: postData),
                  Divider(
                    color: Colors.black,
                  )
                ],
              );
            },
          );
        },
      ),
    );
  }
}
