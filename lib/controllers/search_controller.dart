import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../constant.dart';
import '../models/user.dart';

class SearchCtrl extends GetxController {
  final Rx<List<User>> _searchedUsers = Rx<List<User>>([]);

  List<User> get searchedUsers => _searchedUsers.value;

  searchUser(String typedUser) async {
    _searchedUsers.bindStream(firestore
        .collection('users')
        .where('username', isGreaterThanOrEqualTo: typedUser)
        .snapshots()
        .map((QuerySnapshot query) {
      List<User> returnSearchValue = [];
      for (var elem in query.docs) {
        returnSearchValue.add(User.fromSnap(elem));
      }
      return returnSearchValue;
    }));
  }
}