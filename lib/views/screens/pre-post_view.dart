import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../widgets/textfield.dart';

class PrePostView extends StatefulWidget {
  final File videoFile;
  final String videoPath;

  const PrePostView({
    Key? key,
    required this.videoFile,
    required this.videoPath,
  }) : super(key: key);

  @override
  State<PrePostView> createState() => _PrePostViewState();
}

class _PrePostViewState extends State<PrePostView> {
  late VideoPlayerController controller;
  TextEditingController _keywordsController = TextEditingController();
  TextEditingController _captionController = TextEditingController();

  /*UploadVideoController uploadVideoController =
  Get.put(UploadVideoController());*/

  @override
  // configure video player controller and play video on init
  void initState() {
    super.initState();
    setState(() {
      controller = VideoPlayerController.file(widget.videoFile);
    });
    controller.initialize();
    controller.play();
    controller.setVolume(1);
    controller.setLooping(true);
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 1.5,
              child: VideoPlayer(controller),
            ),
            const SizedBox(
              height: 30,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    width: MediaQuery.of(context).size.width - 20,
                    child: TextInputField(
                      controller: _keywordsController,
                      labelText: 'Keywords',
                      icon: Icons.tag_rounded,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    width: MediaQuery.of(context).size.width - 20,
                    child: TextInputField(
                      controller: _captionController,
                      labelText: 'Caption',
                      icon: Icons.closed_caption,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                      onPressed: () =>  print('post'),
                      /*uploadVideoController.uploadVideo(
                          _keywordsController.text,
                          _captionController.text,
                          widget.videoPath),*/
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Post',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
