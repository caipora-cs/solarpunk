import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:video_compress_plus/video_compress_plus.dart';

import '../constant.dart';
import '../models/video.dart';

class VideoUploadController extends GetxController {
  _compressVideo(String videoPath) async {
    final compressedVideo = await VideoCompress.compressVideo(
      videoPath,
      quality: VideoQuality.MediumQuality,
    );
    return compressedVideo!.file;
  }

  Future<String> _uploadVideo(String id, String videoPath) async {
    Reference ref = firebaseStorage.ref().child('videos').child(id);

    UploadTask uploadTask = ref.putFile(await _compressVideo(videoPath));
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  _getThumbnail(String videoPath) async {
    final thumbnail = await VideoCompress.getFileThumbnail(videoPath);
    return thumbnail;
  }

  Future<String> _uploadThumbnail(String id, String videoPath) async {
    Reference ref = firebaseStorage.ref().child('thumbnails').child(id);
    UploadTask uploadTask = ref.putFile(await _getThumbnail(videoPath));
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }


  uploadVideo(String keywords, String caption, String videoPath) async {
    try {
      //get the current user
      String uid = firebaseAuth.currentUser!.uid;
      //get a snapshot of the user document from firestore
      DocumentSnapshot userDoc = await firestore.collection('users').doc(uid).get();
      // get all the videos from the videos collection
      var allVideosCollection = await firestore.collection('videos').get();
      // get the length of the videos collection
      int lengthIndex = allVideosCollection.docs.length;
      // use the lenghtIndex to name the video and thumbnail on firebase storage
      String videoUrl = await _uploadVideo("Video $lengthIndex", videoPath);
      String thumbnail = await _uploadThumbnail("Video $lengthIndex", videoPath);

      // create a video object from model
      Video video = Video(
        username: (userDoc.data()! as Map<String, dynamic>)['username'],
        uid: uid,
        id: "Video $lengthIndex",
        likes: [],
        commentCount: 0,
        shareCount: 0,
        keywords: keywords,
        caption: caption,
        videoUrl: videoUrl,
        profileImage: (userDoc.data()! as Map<String, dynamic>)['image'],
        thumbnail: thumbnail,
      );
      // save the video object to firestore as json document
      await firestore.collection('videos').doc('Video $lengthIndex').set(
        video.toJson(),
      );
      // navigate back to home screen
      Get.back();
    } catch (e) {
      Get.snackbar('Error uploading', e.toString());
    }
  }
}
