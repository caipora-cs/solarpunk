import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeago/timeago.dart' as time;
import '../../constant.dart';
import '../../controllers/comment_controller.dart';

class CommentView extends StatelessWidget {
  // get id from constructor
  final String id;
  CommentView({
    Key? key,
    required this.id,
  }) : super(key: key);

  final TextEditingController _commentController = TextEditingController();
  CommentController commentController = Get.put(CommentController());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    commentController.updatePostId(id);

    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: Column(
            children: [
              Expanded(
                child: Obx(() {
                  return ListView.builder(
                    // return comment list from controller
                      itemCount: commentController.comments.length,
                      itemBuilder: (context, index) {
                        // get comment from list
                        final comment = commentController.comments[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: backgroundColor,
                            backgroundImage: NetworkImage(comment.profileImage),
                          ),
                          title: Row(
                            children: [
                              Text(
                                "${comment.username}  ",
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.green,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                comment.comment,
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          subtitle: Row(
                            children: [
                              Text(
                                time.format(
                                  comment.datePublished.toDate(),
                                ),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                '${comment.likes.length} likes',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                ),
                              )
                            ],
                          ),
                          trailing: InkWell(
                            onTap: () =>
                                commentController.likeComment(comment.id),
                            child: Icon(
                              Icons.favorite,
                              size: 25,
                              color: comment.likes
                                  .contains(authController.user.uid)
                                  ? Colors.green
                                  : Colors.white,
                            ),
                          ),
                        );
                      });
                }),
              ),
              const Divider(),
              ListTile(
                title: TextFormField(
                  controller: _commentController,
                  style:TextStyle(
                    fontSize: 16,
                    fontFamily: GoogleFonts.khand().fontFamily,
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Comment',
                    labelStyle: TextStyle(
                      fontSize: 20,
                      fontFamily: GoogleFonts.khand().fontFamily,
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.green,
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.green,
                      ),
                    ),
                  ),
                ),
                trailing: TextButton(
                  onPressed: () =>
                      commentController.postComment(_commentController.text),
                  child:Text(
                    'Post',
                    style: TextStyle(
                      fontFamily: GoogleFonts.khand().fontFamily,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}