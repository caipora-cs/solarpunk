import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solarpunk_prototype/constant.dart';
import 'package:solarpunk_prototype/controllers/search_controller.dart';

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
            onFieldSubmitted: (value) => searchController.searchUser(value),
          ),
        ),
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
            : ListView.builder(
          itemCount: searchController.searchedUsers.length,
          itemBuilder: (context, index) {
            User user = searchController.searchedUsers[index];
            return InkWell(
              onTap: () =>
              print('Profile View'),
              /*Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ProfileView(uid: user.uid),
                ),
              ),*/
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