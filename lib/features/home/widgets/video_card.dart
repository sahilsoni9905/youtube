import 'package:basic_youtube_clone/features/home/repository/home_repository.dart';
import 'package:basic_youtube_clone/features/home/screens/profile_screen.dart';
import 'package:basic_youtube_clone/features/home/screens/video_play_screen.dart';
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
    _initializeLikeStatus();
  }

  Future<void> _initializeLikeStatus() async {
    isLikedThePost =
        await ref.read(HomeRepositoryProvider).isLiked(widget.snap['uid']);
    setState(() {});
  }

  void _likeUpdate() async {
    setState(() {
      isLikedThePost = !isLikedThePost;
    });

    await ref
        .read(HomeRepositoryProvider)
        .likeUpdate(widget.snap['uid'], !isLikedThePost);
  }

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
                      // Add comment logic here
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

  @override
  void dispose() {
    _controller.dispose();
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: Stack(
        children: [
          Column(
            children: [
              // Header Section
              Container(
                padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () {
                                // Navigate to user profile
                              },
                              child: Text(
                                widget.snap['owner_user_name'] ??
                                    'Unknown User',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ),
                            Text(
                              widget.snap['uploaded_time'] ?? '',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        // Show post details dialog or navigate to post details screen
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
                          child: VideoPlayer(_controller),
                        ),
                      )
                    : Center(child: CircularProgressIndicator()),
              ),
              // Title Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                              context, AnotherUserProfileScreen.routeName,
                              arguments: widget.snap['owner_uid'].toString());
                        },
                        child: CircleAvatar(
                          radius: 20,
                          backgroundImage: NetworkImage(
                            widget.snap['owner_profile_pic'] ??
                                'https://example.com/placeholder.jpg',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      flex: 8,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        alignment: Alignment.topLeft,
                        child: Text(
                          widget.snap['description'] != null &&
                                  widget.snap['description'].length > 30
                              ? '${widget.snap['description'].substring(0, 30)}...'
                              : widget.snap['description'] ?? 'Video Title',
                          style: const TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.black,
                          ),
                          maxLines: 1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Actions Section
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      _likeUpdate();
                    },
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
                  TextButton(
                    onPressed: () {
                      // Add subscribe functionality
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 8),
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 255, 66, 52)),
                      child: Text(
                        'Subscribe',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              // Likes and Views Section
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Text(
                        '${widget.snap['people_who_liked'].length ?? '0'} likes'),
                    SizedBox(width: 10),
                    // Text('${widget.snap['numberOfViews'] ?? '0'} views'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
