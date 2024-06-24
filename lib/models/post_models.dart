import 'package:basic_youtube_clone/models/comment_models.dart';

class PostModel {
  final String uid;
  final String ownerUid;
  final String? ownerProfilePic;
  final String ownerUserName;
  final String postLink;
  final int numberOfLikes;
  final List<String> peopleWhoLiked;

  final String description;
  final DateTime uploadedTime;

  PostModel({
    required this.uid,
    required this.ownerUid,
    this.ownerProfilePic,
    required this.ownerUserName,
    required this.postLink,
    required this.numberOfLikes,
    required this.peopleWhoLiked,
    required this.description,
    required this.uploadedTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'owner_uid': ownerUid,
      'owner_profile_pic': ownerProfilePic,
      'owner_user_name': ownerUserName,
      'post_link': postLink,
      'number_of_likes': numberOfLikes,
      'people_who_liked': peopleWhoLiked,
      'description': description,
      'uploaded_time': uploadedTime.toIso8601String(),
    };
  }

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      uid: map['uid'] ?? '',
      ownerUid: map['owner_uid'] ?? '',
      ownerProfilePic: map['owner_profile_pic'],
      ownerUserName: map['owner_user_name'] ?? '',
      postLink: map['post_link'] ?? '',
      numberOfLikes: map['number_of_likes'] ?? 0,
      peopleWhoLiked: List<String>.from(map['people_who_liked'] ?? []),
      description: map['description'] ?? '',
      uploadedTime: DateTime.parse(
          map['uploaded_time'] ?? DateTime.now().toIso8601String()),
    );
  }
}
