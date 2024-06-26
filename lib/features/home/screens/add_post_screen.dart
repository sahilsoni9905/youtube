import 'dart:io';
import 'package:basic_youtube_clone/features/home/repository/home_repository.dart';
import 'package:basic_youtube_clone/models/user_models.dart';
import 'package:basic_youtube_clone/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class AddPostScreen extends ConsumerStatefulWidget {
  static const String routeName = 'add-post-screen';
  const AddPostScreen({super.key});

  @override
  ConsumerState<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends ConsumerState<AddPostScreen> {
  File? _file;
  final TextEditingController _descriptionController = TextEditingController();
  UserModel? userDetails;
  VideoPlayerController? _videoPlayerController;
  bool _isLoading = false;

  _selectImage(BuildContext parentContext) async {
    return showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Upload Video'),
          children: <Widget>[
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text('Record Video'),
              onPressed: () async {
                Navigator.pop(context);
                File? file = await pickVideo(context, ImageSource.camera);
                if (file != null) {
                  _videoPlayerController = VideoPlayerController.file(file)
                    ..initialize().then((_) {
                      setState(() {
                        _file = file;
                      });
                      _videoPlayerController?.play();
                    });
                }
              },
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text('Select from Gallery'),
              onPressed: () async {
                Navigator.of(context).pop();
                File? file = await pickVideo(context, ImageSource.gallery);
                if (file != null) {
                  _videoPlayerController = VideoPlayerController.file(file)
                    ..initialize().then((_) {
                      setState(() {
                        _file = file;
                      });
                      _videoPlayerController?.play();
                    });
                }
              },
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  _uploadPost(BuildContext context, String description, String category) async {
    setState(() {
      _isLoading = true;
    });

    try {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Uploading...'),
            content: SizedBox(
              height: 100,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        },
      );
      await ref
          .read(HomeRepositoryProvider)
          .saveUserVideo(_file!, description, context);
      
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    userDetails = await ref.read(HomeRepositoryProvider).getCurrentUser();
    setState(() {});
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _videoPlayerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('Upload Video'),
        actions: [
          TextButton(
            onPressed: () {
              _uploadPost(context, _descriptionController.text, '');
            },
            child: const Text(
              'Post',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ),
        ],
      ),
      body: _file == null
          ? Center(
              child: IconButton(
                onPressed: () => _selectImage(context),
                icon: const Icon(
                  Icons.upload,
                  size: 100,
                  color: Colors.red,
                ),
              ),
            )
          : SingleChildScrollView(
              child: Stack(
                children: [
                  Column(
                    children: <Widget>[
                      const Divider(),
                      if (_videoPlayerController != null &&
                          _videoPlayerController!.value.isInitialized)
                        AspectRatio(
                          aspectRatio:
                              _videoPlayerController!.value.aspectRatio,
                          child: VideoPlayer(_videoPlayerController!),
                        ),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          userDetails != null
                              ? CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(userDetails!.profilePic),
                                )
                              : const CircleAvatar(),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: TextField(
                                controller: _descriptionController,
                                decoration: const InputDecoration(
                                  hintText: "Add a description...",
                                  border: InputBorder.none,
                                ),
                                maxLines: null,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Divider(),
                    ],
                  ),
                  if (_isLoading)
                    const Center(
                      child: CircularProgressIndicator(),
                    ),
                ],
              ),
            ),
    );
  }
}
