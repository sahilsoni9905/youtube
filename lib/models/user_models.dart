class UserModel {
  final String name;
  final String email;
  final String password;
  final String uid;
  final String profilePic;
  final List<String> postLiked;
  final List<String> postCommented;
  final List<String> subscribedList;
  final List<String> videoUploaded;

  UserModel({
    required this.name,
    required this.email,
    required this.password,
    required this.uid,
    required this.profilePic,
    required this.postLiked,
    required this.postCommented,
    required this.subscribedList,
    required this.videoUploaded,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'uid': uid,
      'profile_pic': profilePic,
      'post_liked': postLiked,
      'post_commented': postCommented,
      'subscribed_list': subscribedList,
      'video_uploaded': videoUploaded,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      uid: map['uid'] ?? '',
      profilePic: map['profile_pic'] ?? '',
      postLiked: List<String>.from(map['post_liked'] ?? []),
      postCommented: List<String>.from(map['post_commented'] ?? []),
      subscribedList: List<String>.from(map['subscribed_list'] ?? []),
      videoUploaded: List<String>.from(map['video_uploaded'] ?? []),
    );
  }
}
