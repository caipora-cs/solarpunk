import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:solarpunk_prototype/constant.dart';
import 'package:solarpunk_prototype/views/screens/pre-post_view.dart';


class PostView extends StatelessWidget {
  const PostView({Key? key}) : super(key: key);

  pickVideo(ImageSource src, BuildContext context) async {
    // pick video from gallery or camera and navigate to PrePostView
    final video = await ImagePicker().pickVideo(source: src);
    if (video != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => PrePostView(
            videoFile: File(video.path),
            videoPath: video.path,
          ),
        ),
      );
    }
  }

  postOptions(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        children: [
          SimpleDialogOption(
            onPressed: () => pickVideo(ImageSource.gallery, context),
            child: Row(
              children: const [
                Icon(Icons.image),
                Padding(
                  padding: EdgeInsets.all(7.0),
                  child: Text(
                    'Gallery',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
          SimpleDialogOption(
            onPressed: () => pickVideo(ImageSource.camera, context),
            child: Row(
              children: const [
                Icon(Icons.camera_alt),
                Padding(
                  padding: EdgeInsets.all(7.0),
                  child: Text(
                    'Camera',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.of(context).pop(),
            child: Row(
              children: const [
                Icon(Icons.cancel),
                Padding(
                  padding: EdgeInsets.all(7.0),
                  child: Text(
                    'Cancel',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: InkWell(
          onTap: () => postOptions(context),
          child: Container(
            width: 190,
            height: 50,
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                'Post',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontFamily: primaryFont,
                ),
              ),
            ),
          ),
        )
      )
    );
  }
}