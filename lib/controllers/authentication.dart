import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:solarpunk_prototype/models/user.dart' as model;
import 'package:solarpunk_prototype/constant.dart';
import '../views/screens/home_view.dart';
import '../views/screens/login_view.dart';

class Authentication extends GetxController {
  // singleton class
  static Authentication instance = Get.find();
  // Rx is a type of variable that can be observed for event changes
  late Rx<User?> _firebaseUser;
  late Rx<File?> _pickedImage;
  //getter for the private variable
  File? get profileImage => _pickedImage.value;

  @override
  // onReady is a lifecycle method that is triggered when the widget is ready
  void onReady() {
    super.onReady();
    // bind the firebase auth user to the _firebaseUser variable
    _firebaseUser = Rx<User?>(firebaseAuth.currentUser);
    // bind the user to any state changes in firebase auth
    _firebaseUser.bindStream(firebaseAuth.authStateChanges());
    // the ever method listes to the state of the user and calls the method passed to it
    ever(_firebaseUser, _setLandingPage);
  }

  // if the user is logged in, go to home screen, else go to login screen
  _setLandingPage(User? user) {
    if (user == null) {
      Get.offAll(() => LoginScreen());
    } else {
      Get.offAll(() => const HomeScreen());
    }
  }

  void pickImage() async {
    // pick image from gallery
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage!=null) {
      Get.snackbar('Profile Image', 'Sucessfully Picked Image');
    }
    // convert the picked image to a file and save it to the private variable
    _pickedImage = Rx<File?>(
      File(pickedImage!.path),
    );
  }

  Future<String?> _uploadImage(File image) async {
    // check if image exists
    if (!image.existsSync()) {
      print('File does not exist');
      return null;
    }
    // create a reference to the firebase storage, append the path to the image as profileImages/userId
    try {
      Reference ref = firebaseStorage
          .ref()
          .child('profileImages')
          .child(firebaseAuth.currentUser!.uid);

      print ('Reference path: ${ref.fullPath}');
      UploadTask uploadTask = ref.putFile(image);
      // create a snapshot of the upload task and get the download url for later use
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
        // register user to firebase auth and save it to variable cred
        UserCredential userCredential = await firebaseAuth
            .createUserWithEmailAndPassword(email: email, password: password);
        // use the helper method to upload image to firebase storage and get the download url
        String? downloadURL = await _uploadImage(image);
        model.User user = model.User(
          uid: userCredential.user!.uid,
          username: username,
          email: email,
          image: downloadURL,
        );
        // save user model data to firestore as json
        await firestore.collection('users').doc(userCredential.user!.uid).set(user.toJson());
      } else {
        Get.snackbar(
          'Error on Registering User',
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

  void loginUser(String email, String password) async {
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password);
        print('User Logged In');
      } else {
        Get.snackbar(
          'Error on Login',
          'Please fill all the fields',
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error on Login',
        e.toString(),
      );
    }
  }

}