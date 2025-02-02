import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social/components/my_appbar.dart';
import 'package:social/components/my_drawer.dart';
import 'package:social/database/firestore.dart';

class MyMainPageTablet extends StatefulWidget {
  const MyMainPageTablet({super.key});

  @override
  State<MyMainPageTablet> createState() => _MyMainPageTabletState();
}

class _MyMainPageTabletState extends State<MyMainPageTablet> {
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
      appBar: MyAppbar(title: "s o C I a l"),
      drawer: MyDrawer(),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 40), // Daha fazla boşluk
            Row(
              children: [
                SizedBox(width: 20),
                Expanded(
                  child: TextField(
                    controller: postController,
                    style: TextStyle(fontSize: 22), // Daha büyük metin
                    decoration: InputDecoration(
                      hintText: "What's on your mind?",
                      hintStyle: TextStyle(fontSize: 20),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                ),
                IconButton(
                  onPressed: postController.text.isEmpty ? null : postMessage,
                  icon: Icon(Icons.send, size: 28),
                ),
                SizedBox(width: 20),
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
                          const Icon(Icons.error, size: 100),
                          Text("Something went wrong",
                              style: TextStyle(fontSize: 22)),
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
                            style: TextStyle(fontSize: 24),
                          ),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(posts[index]["username"],
                                  style: TextStyle(fontSize: 20)),
                              Text(
                                  timestamp
                                      .toDate()
                                      .toString()
                                      .substring(0, 16),
                                  style: TextStyle(fontSize: 18)),
                            ],
                          ),
                        );
                      },
                    );
                  }
                  return Center(
                    child: Column(
                      children: [
                        const Icon(Icons.error, size: 100),
                        Text("No posts found", style: TextStyle(fontSize: 22)),
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
