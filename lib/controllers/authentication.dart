import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:solarpunk_prototype/models/user.dart' as model;
import 'package:solarpunk_prototype/constant.dart';

class Authentication extends GetxController {
  static Authentication instance = Get.find();
  // Rx is a type of variable that can be observed for event changes
  late Rx<File?> _pickedImage;
  //getter for the private variable
  File? get profileImage => _pickedImage.value;
  void pickImage() async {
    // pick image
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage!=null) {
      Get.snackbar('Profile Image', 'Sucessfully Picked Image');
    }
    // save image to local storage
    _pickedImage = Rx<File?>(
      File(pickedImage!.path),
    );
  }
  // upload to the storage
  Future<String?> _uploadImage(File image) async {
    if (!image.existsSync()) {
      print('File does not exist');
      return null;
    }
    try {
      Reference ref = firebaseStorage
          .ref()
          .child('profileImages')
          .child(firebaseAuth.currentUser!.uid);

      print ('Reference path: ${ref.fullPath}');
      UploadTask uploadTask = ref.putFile(image);
      TaskSnapshot snap = await uploadTask;
      String downloadUrl = await snap.ref.getDownloadURL();
      return downloadUrl;
    } catch (e, stackTrace) {
      print ('Error Uploading Image: $e, $stackTrace');
      return null;
    }
  }

  // registering user
  void registerUser(String username, String email, String password, File? image) async {
    try {
      if (username.isNotEmpty &&
          email.isNotEmpty &&
          password.isNotEmpty &&
          image != null) {
        // register user
        UserCredential userCredential = await firebaseAuth
            .createUserWithEmailAndPassword(email: email, password: password);
        // upload image
        String? downloadURL = await _uploadImage(image);
        model.User user = model.User(
          uid: userCredential.user!.uid,
          username: username,
          email: email,
          image: downloadURL,
        );
        // save user data to firestore
        await firestore.collection('users').doc(userCredential.user!.uid).set(user.toJson());
        // save user data to local storage
        // navigate to home screen
      } else {
        Get.snackbar(
          'Error',
          'Please fill all the fields',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: secondaryColor,
          colorText: primaryColor,
        );
      }
    } catch (e, stackTrace) {
      print('Error Registering User: $e, $stackTrace');
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: secondaryColor,
        colorText: primaryColor,
      );
    }
  }

}