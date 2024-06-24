class CommentModel {
  final String userUid;
  final String name;
  final String profilePic;
  final String comment;

  CommentModel({
    required this.userUid,
    required this.name,
    required this.profilePic,
    required this.comment,
  });

  Map<String, dynamic> toMap() {
    return {
      'user_uid': userUid,
      'name': name,
      'profile_pic': profilePic,
      'comment': comment,
    };
  }

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      userUid: map['user_uid'] ?? '',
      name: map['name'] ?? '',
      profilePic: map['profile_pic'] ?? '',
      comment: map['comment'] ?? '',
    );
  }
}
