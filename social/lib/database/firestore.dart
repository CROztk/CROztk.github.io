/*
  Firestore Database
  Stores user posts in the collection named "posts"

  every post has:
  - a message
  - username
  - timestamp
*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FireStoreDatabase {
  // current user
  User? currentUser = FirebaseAuth.instance.currentUser;

  // get collection of posts
  CollectionReference posts = FirebaseFirestore.instance.collection('posts');

  // add post to the database
  Future<void> addPost(String message) async {
    // get current user's username
    final username = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser!.email)
        .get()
        .then((value) => value.data()!["username"]);
    // create post
    Map<String, dynamic> post = {
      "message": message,
      "username": username,
      "timestamp": Timestamp.now(),
    };

    // save post to the database
    await posts.add(post);
  }

  // delete post from the database

  // read posts from the database
  Stream<QuerySnapshot> getPosts() {
    return posts.orderBy("timestamp", descending: true).snapshots();
  }
}
