import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:solarpunk_prototype/controllers/authentication.dart';

// Pages
const pages = [
  Text('Home'),
  Text('Search'),
  Text('Profile'),
  Text('Messages'),
  Text('Add'),
];

// Colors
const backgroundColor = Color(0xFFd6dcd2);
const primaryColor = Color(0xFF968ab5);
const secondaryColor = Color(0xFF7d8293);

// Firebase
var firebaseStorage = FirebaseStorage.instance;
var firebaseAuth = FirebaseAuth.instance;
var firestore = FirebaseFirestore.instance;

//Controller
var authController = Authentication.instance;