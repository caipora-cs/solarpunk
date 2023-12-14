import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solarpunk_prototype/constant.dart';
import 'package:solarpunk_prototype/controllers/search_controller.dart';
import 'package:solarpunk_prototype/views/screens/profile_view.dart';

import '../../models/user.dart';

class SearchView extends StatelessWidget {
  SearchView({Key? key}) : super(key: key);
  final defaultProfilePic = '../../assets/images/User.png';
  final SearchCtrl searchController = Get.put(SearchCtrl());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: backgroundColor,
          title: TextFormField(
            decoration: const InputDecoration(
              filled: false,
              hintText: 'Search',
              hintStyle: TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            // when user type in search bar it will call searchUser function
            onFieldSubmitted: (value) => searchController.searchUser(value),
          ),
        ),
        // if searchedUsers list is empty then show empty container
        body: searchController.searchedUsers.isEmpty
            ? const Center(
          child: Text(
            '',
            style: TextStyle(
              fontSize: 25,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
        // else show searchedUsers list
            : ListView.builder(
          itemCount: searchController.searchedUsers.length,
          itemBuilder: (context, index) {
            User user = searchController.searchedUsers[index];
            return InkWell(
              onTap: () =>
              Navigator.of(context).push(
                MaterialPageRoute(
                  // pass uid to a searched user profile
                  builder: (context) => ProfileView(uid: user.uid),
                ),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(
                    user.image ?? defaultProfilePic,
                  ),
                ),
                title: Text(
                  user.username,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ),
            );
          },
        ),
      );
    });
  }
}