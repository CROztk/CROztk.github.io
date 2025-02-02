import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social/components/my_appbar.dart';
import 'package:social/components/my_drawer.dart';
import 'package:social/database/firestore.dart';

class MyMainPageMobile extends StatefulWidget {
  const MyMainPageMobile({super.key});

  @override
  State<MyMainPageMobile> createState() => _MyMainPageMobileState();
}

class _MyMainPageMobileState extends State<MyMainPageMobile> {
  // text controller for post
  final TextEditingController postController = TextEditingController();

  // firestore access
  final FireStoreDatabase fireStore = FireStoreDatabase();

  // post the message
  void postMessage() {
    // add post to firestore
    fireStore.addPost(postController.text);

    // clear the textfield
    postController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppbar(title: "s o C I a l"),
      drawer: MyDrawer(),
      body: Center(
        child: Column(children: [
          SizedBox(height: 20),
          Row(
            children: [
              SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: postController,
                  decoration: InputDecoration(
                    hintText: "What's on your mind?",
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
              ),
              IconButton(
                  onPressed: postController.text.isEmpty ? null : postMessage,
                  icon: Icon(Icons.send)),
            ],
          ),
          StreamBuilder(
            stream: fireStore.getPosts(),
            builder: (context, snapshot) {
              // loading
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              // error
              if (snapshot.hasError) {
                return Center(
                  child: Column(
                    children: [
                      const Icon(Icons.error, size: 80),
                      Text("Something went wrong"),
                    ],
                  ),
                );
              }
              // success
              if (snapshot.hasData) {
                // extract data
                final posts = snapshot.data!.docs;

                return Expanded(
                  child: ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      Timestamp timestamp = posts[index]["timestamp"];
                      return ListTile(
                        title: Text(posts[index]["message"]),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(posts[index]["username"]),
                            Text(
                                timestamp.toDate().toString().substring(0, 16)),
                          ],
                        ),
                      );
                    },
                  ),
                );
              }
              // no data
              return Center(
                child: Column(
                  children: [
                    const Icon(Icons.error, size: 80),
                    Text("No posts found"),
                  ],
                ),
              );
            },
          )
        ]),
      ),
    );
  }
}
