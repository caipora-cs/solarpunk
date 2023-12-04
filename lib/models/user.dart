import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String uid;
  String username;
  String email;
  /*String? bionote;*/
  /*Int? phone;*/
  String? image;

  User({
    required this.uid,
    required this.username,
    required this.email,
    required this.image,
  });

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'username': username,
      'email': email,
      /*'bionote': bionote,*/
      /*'phone': phone,*/
      'image': image,
    };
  }
  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return User(
      email: snapshot['email'],
      image: snapshot['image'],
      uid: snapshot['id'],
      username: snapshot['username'],
    );
  }
}