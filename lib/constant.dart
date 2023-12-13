import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solarpunk_prototype/controllers/authentication.dart';
import 'package:solarpunk_prototype/views/screens/post_view.dart';
import 'package:solarpunk_prototype/views/screens/profile_view.dart';
import 'package:solarpunk_prototype/views/screens/search_view.dart';
import 'package:solarpunk_prototype/views/screens/video_view.dart';

// Pages
List pages = [
  VideoView(),
  SearchView(),
  const PostView(),
  Text('Messages'),
  ProfileView(),
];

// Colors
const backgroundColor = Color(0xFFd6dcd2);
const primaryColor = Color(0xFF968ab5);
const secondaryColor = Color(0xFF7d8293);
const bannerColor = Color(0xFF76d7c4);
//Fonts
final primaryFont = GoogleFonts.lobsterTwo().fontFamily;

// Firebase
var firebaseStorage = FirebaseStorage.instance;
var firebaseAuth = FirebaseAuth.instance;
var firestore = FirebaseFirestore.instance;

//Controller
var authController = Authentication.instance;