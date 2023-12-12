import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../constant.dart';
import '../models/video.dart';

class VideoController extends GetxController {
  // List variable to hold the list of videos
  final Rx<List<Video>> _videoList = Rx<List<Video>>([]);
  // getter for the list of videos
  List<Video> get videoList => _videoList.value;

  @override
  // When class is initialized, bind the stream to the firestore collection
  void onInit() {
    super.onInit();
    _videoList.bindStream(
      // map every document in the collection to a video object
        firestore.collection('videos').snapshots().map((QuerySnapshot query) {
          // create a list of videos from the query snapshot
          List<Video> returnQueryValues = [];
          // loop through the query snapshot and add each video to the list
          for (var element in query.docs) {
            returnQueryValues.add(
              Video.fromSnap(element),
            );
          }
          return returnQueryValues;
        }));
  }

  likeVideo(String id) async {
    DocumentSnapshot doc = await firestore.collection('videos').doc(id).get();
    var uid = authController.user.uid;
    // check if the user has already liked the video and toggle the like
    if ((doc.data()! as dynamic)['likes'].contains(uid)) {
      await firestore.collection('videos').doc(id).update({
        'likes': FieldValue.arrayRemove([uid]),
      });
      // if the user has not liked the video, add the like
    } else {
      await firestore.collection('videos').doc(id).update({
        'likes': FieldValue.arrayUnion([uid]),
      });
    }
  }
}