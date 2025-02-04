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
      "email": currentUser!.email,
      "likedUsers": []
    };

    // save post to the database
    await posts.add(post);
  }

  // like post
  Future<void> likePost(String id) async {
    final post = await posts.doc(id).get();
    final postData = post.data() as Map<String, dynamic>;
    // add user to the liked users
    final likedUsers = postData["likedUsers"] as List<dynamic>;
    if (likedUsers.contains(currentUser!.email)) {
      likedUsers.remove(currentUser!.email);
    } else {
      likedUsers.add(currentUser!.email);
    }
    // update post
    await posts.doc(id).update({"likedUsers": likedUsers});
  }

  // delete post from the database
  Future<void> deletePost(String id) async {
    await posts.doc(id).delete();
  }

  // read posts from the database
  Stream<QuerySnapshot> getPosts() {
    return posts.orderBy("timestamp", descending: true).snapshots();
  }

  // get posts of a specific user
  Stream<QuerySnapshot> getUserPosts(String email) {
    return posts.where("email", isEqualTo: email).snapshots();
  }

  // check if user is owner of the post
  Future<bool> isOwner(String id) async {
    final post = await posts.doc(id).get();
    final postData = post.data() as Map<String, dynamic>;
    final currentUsername = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser!.email)
        .get()
        .then((value) => value.data()!["username"]);
    return postData["username"] == currentUsername;
  }
}
