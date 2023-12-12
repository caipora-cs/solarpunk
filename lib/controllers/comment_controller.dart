import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../models/comment.dart';
import '../constant.dart';

class CommentController extends GetxController {
  final Rx<List<Comment>> _comments = Rx<List<Comment>>([]);
  List<Comment> get comments => _comments.value;

  String _postId = "";

  updatePostId(String id) {
    _postId = id;
    getComment();
  }

  // similar to post controller, bind the stream to the firestore collection
  getComment() async {
    _comments.bindStream(
      firestore
          .collection('videos')
          .doc(_postId)
          .collection('comments')
          .snapshots()
          .map(
            (QuerySnapshot query) {
          List<Comment> returnCommentValue = [];
          for (var element in query.docs) {
            returnCommentValue.add(Comment.fromSnap(element));
          }
          return returnCommentValue;
        },
      ),
    );
  }

  // add a comment to the firestore collection
  postComment(String commentText) async {
    try {
      if (commentText.isNotEmpty) {
        DocumentSnapshot userDoc = await firestore
            .collection('users')
            .doc(authController.user.uid)
            .get();
        var allDocs = await firestore
            .collection('videos')
            .doc(_postId)
            .collection('comments')
            .get();
        int len = allDocs.docs.length;
// create a comment object from model and get the data from the user document
        Comment comment = Comment(
          username: (userDoc.data()! as dynamic)['username'],
          comment: commentText.trim(),
          datePublished: DateTime.now(),
          likes: [],
          profileImage: (userDoc.data()! as dynamic)['image'],
          uid: authController.user.uid,
          id: 'Comment $len',
        );
        await firestore
            .collection('videos')
            .doc(_postId)
            .collection('comments')
            .doc('Comment $len')
            .set(
          comment.toJson(),
        );
        // update the comment count on the video document
        DocumentSnapshot doc =
        await firestore.collection('videos').doc(_postId).get();
        await firestore.collection('videos').doc(_postId).update({
          'commentCount': (doc.data()! as dynamic)['commentCount'] + 1,
        });
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
      );
    }
  }

  likeComment(String id) async {
    var uid = authController.user.uid;
    // get the comment document from firestore
    DocumentSnapshot doc = await firestore
        .collection('videos')
        .doc(_postId)
        .collection('comments')
        .doc(id)
        .get();
// check if the user has already liked the comment and toggle the like
    if ((doc.data()! as dynamic)['likes'].contains(uid)) {
      await firestore
          .collection('videos')
          .doc(_postId)
          .collection('comments')
          .doc(id)
          .update({
        'likes': FieldValue.arrayRemove([uid]),
      });
      // if the user has not liked the comment, add the like
    } else {
      await firestore
          .collection('videos')
          .doc(_postId)
          .collection('comments')
          .doc(id)
          .update({
        'likes': FieldValue.arrayUnion([uid]),
      });
    }
  }
}