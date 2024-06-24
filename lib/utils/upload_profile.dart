import 'dart:io';
import 'package:supabase/supabase.dart';

Future<String> storeFileToStorage(
    SupabaseClient supabaseClient, File file) async {
  String fileName = file.path.split('/').last;

  String bucket = 'profile_pics';
  String path = 'uploads/$fileName';

  final response = await supabaseClient.storage.from(bucket).upload(path, file);
  final urlResponse =  supabaseClient.storage.from(bucket).getPublicUrl(path);

  if (urlResponse == null) {
    throw Exception('Failed to get public URL: ');
  }

  return urlResponse;
}

Future<String> storeVideoToStorage(
    SupabaseClient supabaseClient, File file) async {
  String fileName = file.path.split('/').last;
  String bucket = 'videoes';
  String path = 'uploads/$fileName';
  print('sahil    1');
  final response = await supabaseClient.storage.from(bucket).upload(path, file);
  final urlResponse = supabaseClient.storage.from(bucket).getPublicUrl(path);
  print('sahil 2');

  if (urlResponse == null) {
    throw Exception('Failed to get public URL: ');
  }

  return urlResponse;
}
