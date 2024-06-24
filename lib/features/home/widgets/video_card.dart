import 'package:basic_youtube_clone/features/home/screens/video_play_screen.dart';
import 'package:basic_youtube_clone/models/comment_models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:video_player/video_player.dart';

class VideoCard extends ConsumerStatefulWidget {
  final dynamic snap;

  const VideoCard({Key? key, required this.snap}) : super(key: key);

  @override
  _VideoCardState createState() => _VideoCardState();
}

class _VideoCardState extends ConsumerState<VideoCard> {
  bool isLikedThePost = false;
  late VideoPlayerController _controller;
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.snap['post_link'])
      ..initialize().then((_) {
        setState(() {});
        _controller.pause();
        _controller.setLooping(true);
      });
    //  _initializeLikeStatus();
  }

  // Future<void> _initializeLikeStatus() async {
  //   isLikedThePost =
  //       await ref.read(FeedRepositoryProvider).isLiked(widget.snap['uid']);
  //   setState(() {});
  // }

  // void _likeUpdate() async {
  //   await ref
  //       .read(FeedRepositoryProvider)
  //       .likeUpdate(widget.snap['uid'], isLikedThePost);
  //   setState(() {
  //     isLikedThePost = !isLikedThePost;
  //   });
  // }

  void _showCommentInputDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _commentController,
                  decoration: InputDecoration(
                    hintText: 'Write a comment...',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    if (_commentController.text.isNotEmpty) {
                      // await ref.read(FeedRepositoryProvider).addComment(
                      //       widget.snap['uid'],
                      //       _commentController.text,
                      //   );
                      _commentController.clear();
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // void _showCommentsDialog(BuildContext context, List<CommentModel> comments) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return Dialog(
  //         child: Container(
  //           height: 400,
  //           child: Column(
  //             children: [
  //               Padding(
  //                 padding: const EdgeInsets.all(8.0),
  //                 child: Text(
  //                   'Comments',
  //                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
  //                 ),
  //               ),
  //               Expanded(
  //                 child: ListView.builder(
  //                   itemCount: comments.length,
  //                   itemBuilder: (context, index) {
  //                     return ListTile(
  //                       leading: InkWell(
  //                         onTap: () {
  //                           // Navigator.pushNamed(
  //                           //   context,
  //                           //   AnotherUserProfileScreen.routeName,
  //                           //   arguments: widget.snap['ownerUid'],
  //                           //  );
  //                         },
  //                         child: CircleAvatar(
  //                           radius: 15,
  //                           backgroundImage: NetworkImage(
  //                               comments[index].profilePic.toString()),
  //                         ),
  //                       ),
  //                       title: Text(
  //                         comments[index].name.toString(),
  //                         style: TextStyle(fontWeight: FontWeight.bold),
  //                       ),
  //                       subtitle: Text(comments[index].comment.toString()),
  //                     );
  //                   },
  //                 ),
  //               ),
  //               TextButton(
  //                 onPressed: () {
  //                   Navigator.of(context).pop();
  //                 },
  //                 child: Text('Close'),
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  @override
  void dispose() {
    _controller.dispose();
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          // Header Section
          Container(
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(
                    widget.snap['owner_profile_pic'] ??
                        'https://example.com/placeholder.jpg',
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            // Navigator.pushNamed(
                            //   context,
                            //   AnotherUserProfileScreen.routeName,
                            //   arguments: widget.snap['ownerUid'],
                            // );
                          },
                          child: Text(
                            widget.snap['owner_user_name'] ?? 'Unknown User',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                        Text(
                          widget.snap['uploaded_time'] ?? '',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => Dialog(
                        child: InkWell(
                          onTap: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) =>
                            //         PostDetailsScreen(postDetails: widget.snap),
                            //   ),
                            // );
                          },
                          child: Container(
                            height: 50,
                            alignment: Alignment.center,
                            child: Text(
                              'Post Details',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  icon: Icon(Icons.more_vert),
                ),
              ],
            ),
          ),
          // Video Section
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.35,
            width: double.infinity,
            child: _controller.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                              context, VideoPlayerScreen.routeName,
                              arguments: widget.snap['post_link']);
                        },
                        child: VideoPlayer(_controller)),
                  )
                : Center(child: CircularProgressIndicator()),
          ),
          // Title Section
          Container(
            padding: const EdgeInsets.all(10),
            alignment: Alignment.topLeft,
            child: Text(
              widget.snap['description'] ?? 'Video Title',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black),
            ),
          ),
          // Actions Section
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.thumb_up,
                  color: isLikedThePost ? Colors.blue : Colors.grey,
                ),
              ),
              IconButton(
                onPressed: () {
                  _showCommentInputDialog(context);
                },
                icon: Icon(Icons.comment, color: Colors.grey),
              ),
              Spacer(),
              IconButton(
                onPressed: () {
                  // Add share functionality here
                },
                icon: Icon(Icons.share, color: Colors.grey),
              ),
            ],
          ),
          // Likes and Views Section
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text('${widget.snap['number_of_likes'] ?? '0'} likes'),
                SizedBox(width: 10),
                //   Text('${widget.snap['numberOfViews'] ?? '0'} views'),
              ],
            ),
          ),
          // Description Section
          Container(
            padding: const EdgeInsets.all(10),
            child: RichText(
              text: TextSpan(
                text: widget.snap['description'] ?? 'Description',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
          // View Comments Section
          InkWell(
            onTap: () {
              // List<dynamic> commentsDynamic = widget.snap['comments'];
              // List<CommentModel> comments = commentsDynamic
              //     .map((comment) => CommentModel.fromMap(comment))
              //     .toList();
              // _showCommentsDialog(context, comments);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'View all comments',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
