import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social/components/my_appbar.dart';
import 'package:social/database/firestore.dart';

class MyMainPageDesktop extends StatefulWidget {
  const MyMainPageDesktop({super.key});

  @override
  State<MyMainPageDesktop> createState() => _MyMainPageDesktopState();
}

class _MyMainPageDesktopState extends State<MyMainPageDesktop> {
  final TextEditingController postController = TextEditingController();
  final FireStoreDatabase fireStore = FireStoreDatabase();

  void postMessage() {
    fireStore.addPost(postController.text);
    postController.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("s o C I a l"),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text("Home", style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () {},
            child: Text("Profile", style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () {},
            child: Text("Users", style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () {},
            child: Text("Logout", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 50),
            Row(
              children: [
                SizedBox(width: 40),
                Expanded(
                  child: TextField(
                    controller: postController,
                    style: TextStyle(fontSize: 26),
                    decoration: InputDecoration(
                      hintText: "What's on your mind?",
                      hintStyle: TextStyle(fontSize: 24),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                ),
                IconButton(
                  onPressed: postController.text.isEmpty ? null : postMessage,
                  icon: Icon(Icons.send, size: 32),
                ),
                SizedBox(width: 40),
              ],
            ),
            Expanded(
              child: StreamBuilder(
                stream: fireStore.getPosts(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        children: [
                          const Icon(Icons.error, size: 120),
                          Text("Something went wrong",
                              style: TextStyle(fontSize: 26)),
                        ],
                      ),
                    );
                  }
                  if (snapshot.hasData) {
                    final posts = snapshot.data!.docs;
                    return ListView.builder(
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        Timestamp timestamp = posts[index]["timestamp"];
                        return ListTile(
                          title: Text(
                            posts[index]["message"],
                            style: TextStyle(fontSize: 28),
                          ),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(posts[index]["username"],
                                  style: TextStyle(fontSize: 24)),
                              Text(
                                  timestamp
                                      .toDate()
                                      .toString()
                                      .substring(0, 16),
                                  style: TextStyle(fontSize: 22)),
                            ],
                          ),
                        );
                      },
                    );
                  }
                  return Center(
                    child: Column(
                      children: [
                        const Icon(Icons.error, size: 120),
                        Text("No posts found", style: TextStyle(fontSize: 26)),
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
