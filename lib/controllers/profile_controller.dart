import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../constant.dart';

class ProfileController extends GetxController {
  final Rx<Map<String, dynamic>> _user = Rx<Map<String, dynamic>>({});
  Map<String, dynamic> get user => _user.value;
  // you can create a Obx lo listen to the changes in the user object and update the UI
  Rx<String> _uid = "".obs;
  // getter for the private variable _uid and invoke the get method for the logic
  updateUserId(String uid) {
    _uid.value = uid;
    getUserData();
  }

  getUserData() async {
    // data structure for thumbnails retrieved from the firestore
    List<String> thumbnails = [];
    // get the videos from the firestore
    var myVideos = await firestore
        .collection('videos')
        .where('uid', isEqualTo: _uid.value)
        .get();
    // get the thumbnails from the videos and add it to the list
    for (int i = 0; i < myVideos.docs.length; i++) {
      thumbnails.add((myVideos.docs[i].data() as dynamic)['thumbnail']);
    }
    // get the user document from the firestore
    DocumentSnapshot userDoc =
    await firestore.collection('users').doc(_uid.value).get();
    final userData = userDoc.data()! as dynamic;
    // caring for nullable errors on name and image
    String username = userData['username'] ?? 'default';
    String image = userData['image']?? 'default';
    // initialize likes and followers and following
    int likes = 0;
    int followers = 0;
    int following = 0;
    bool isFollowing = false;
    // go through each video and get the likes and add it to the likes variable
    for (var item in myVideos.docs) {
      likes += (item.data()['likes'] as List).length;
    }
    // use sub collection to get the followers and following
    var followerDoc = await firestore
        .collection('users')
        .doc(_uid.value)
        .collection('followers')
        .get();
    var followingDoc = await firestore
        .collection('users')
        .doc(_uid.value)
        .collection('following')
        .get();
    followers = followerDoc.docs.length;
    following = followingDoc.docs.length;
    // check if the current user is following the user
    firestore
        .collection('users')
        .doc(_uid.value)
        .collection('followers')
        .doc(authController.user.uid)
        .get()
        .then((value) {
          // if the document exists, then the user is following
      if (value.exists) {
        isFollowing = true;
          // else the user is not following
      } else {
        isFollowing = false;
      }
    });
    // update the user object with the data
    _user.value = {
      'followers': followers.toString(),
      'following': following.toString(),
      'isFollowing': isFollowing,
      'likes': likes.toString(),
      'image': image,
      'username': username,
      'thumbnails': thumbnails,
    };
    update();
  }

  followUser() async {
    // get the document from the firestore
    var doc = await firestore
        .collection('users')
        .doc(_uid.value)
        .collection('followers')
        .doc(authController.user.uid)
        .get();
    // if the document does not exist, then the user is not following
    if (!doc.exists) {
      // add the document to the firestore
      await firestore
          .collection('users')
          .doc(_uid.value)
          .collection('followers')
          .doc(authController.user.uid)
          .set({});
      await firestore
          .collection('users')
          .doc(authController.user.uid)
          .collection('following')
          .doc(_uid.value)
          .set({});
      // update the followers count and parse the string to int
      _user.value.update(
        'followers',
            (value) => (int.parse(value) + 1).toString(),
      );
    } else {
      await firestore
          .collection('users')
          .doc(_uid.value)
          .collection('followers')
          .doc(authController.user.uid)
          .delete();
      await firestore
          .collection('users')
          .doc(authController.user.uid)
          .collection('following')
          .doc(_uid.value)
          .delete();
      _user.value.update(
        'followers',
            (value) => (int.parse(value) - 1).toString(),
      );
    }
    // update the isFollowing variable
    _user.value.update('isFollowing', (value) => !value);
    update();
  }
}