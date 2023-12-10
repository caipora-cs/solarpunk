import 'package:cloud_firestore/cloud_firestore.dart';

class Video {
  String username;
  String uid;
  String id;
  List likes;
  int commentCount;
  int shareCount;
  String keywords;
  String caption;
  String videoUrl;
  String thumbnail;
  String profileImage;

  Video({
    required this.username,
    required this.uid,
    required this.id,
    required this.likes,
    required this.commentCount,
    required this.shareCount,
    required this.keywords,
    required this.caption,
    required this.videoUrl,
    required this.profileImage,
    required this.thumbnail,
  });

  Map<String, dynamic> toJson() => {
    "username": username,
    "uid": uid,
    "profilePhoto": profileImage,
    "id": id,
    "likes": likes,
    "commentCount": commentCount,
    "shareCount": shareCount,
    "keywords": keywords,
    "caption": caption,
    "videoUrl": videoUrl,
    "thumbnail": thumbnail,
  };

  static Video fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Video(
      username: snapshot['username'],
      uid: snapshot['uid'],
      id: snapshot['id'],
      likes: snapshot['likes'],
      commentCount: snapshot['commentCount'],
      shareCount: snapshot['shareCount'],
      keywords: snapshot['keywords'],
      caption: snapshot['caption'],
      videoUrl: snapshot['videoUrl'],
      profileImage: snapshot['profileImage'],
      thumbnail: snapshot['thumbnail'],
    );
  }
}