import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:where_wear/components/my_drawer.dart';
import 'package:where_wear/components/my_list_tile.dart';
import 'package:where_wear/components/my_post_button.dart';
import 'package:where_wear/components/my_textfield.dart';
import 'package:where_wear/database/firestore.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  // firestore access
  final FirestoreDataase database = FirestoreDataase();

  // text controller
  final newPostController = TextEditingController();

  // post message
  void postMessage() {
    if (newPostController.text.isNotEmpty) {
      String message = newPostController.text;
      database.addPost(message);
    }

    newPostController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text('W H E R E   W E A R'),
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
      ),
      drawer: const MyDrawer(),
      body: Column(
        children: [
          // textfield box for user to type
          Padding(
            padding: const EdgeInsets.all(25),
            child: Row(
              children: [
                // textfield
                Expanded(
                  child: MyTextfield(
                    hintText: 'Say something..',
                    obscureText: false,
                    controller: newPostController,
                  ),
                ),

                // post button
                MyPostButton(onTap: postMessage),
              ],
            ),
          ),

          // posts
          StreamBuilder(
            stream: database.getPostsStream(),
            builder: (context, snapshot) {
              // show loading circle
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              // get all posts
              final posts = snapshot.data!.docs;

              // no data?
              if (snapshot.data == null || posts.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(25),
                    child: Text('No posts... Post something!'),
                  ),
                );
              }

              // return as a list
              return Expanded(
                child: ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    // 取得post
                    final post = posts[index];

                    // 取得post資訊
                    String message = post['PostMessage'];
                    String userEmail = post['UserEmail'];
                    Timestamp timestamp = post['TimeStamp'];

                    // return as a list tile
                    return MyListTile(
                      title: message,
                      subTitle: userEmail,
                    );
                  },
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
