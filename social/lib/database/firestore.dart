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
import 'package:firebase_storage/firebase_storage.dart';

class FireStoreDatabase {
  // current user
  User? currentUser = FirebaseAuth.instance.currentUser;

  // get collection of posts
  CollectionReference textPosts =
      FirebaseFirestore.instance.collection('posts');
  CollectionReference photoPosts =
      FirebaseFirestore.instance.collection('photoPosts');

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
    await textPosts.add(post);
  }

  // add photo post to the database
  Future<void> addPhotoPost(String message, String imageURL) async {
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
      "likedUsers": [],
      "imageURL": imageURL
    };

    // save post to the database
    await photoPosts.add(post);
  }

  // like photo post
  Future<void> likePhotoPost(String id) async {
    final post = await photoPosts.doc(id).get();
    final postData = post.data() as Map<String, dynamic>;
    // add user to the liked users
    final likedUsers = postData["likedUsers"] as List<dynamic>;
    if (likedUsers.contains(currentUser!.email)) {
      likedUsers.remove(currentUser!.email);
    } else {
      likedUsers.add(currentUser!.email);
    }
    // update post
    await photoPosts.doc(id).update({"likedUsers": likedUsers});
  }

  // delete photo post from the database
  Future<void> deletePhotoPost(String id) async {
    DocumentSnapshot post = await photoPosts.doc(id).get();
    final postData = post.data() as Map<String, dynamic>;
    final imageURL = postData["imageURL"];
    if (imageURL.isNotEmpty) {
      // delete image from storage
      FirebaseStorage.instance.refFromURL(imageURL).delete();
    }
    await photoPosts.doc(id).delete();
  }

  // read photo posts from the database
  Stream<QuerySnapshot> getPhotoPosts() {
    return photoPosts.orderBy("timestamp", descending: true).snapshots();
  }

  // get photo posts of a specific user
  Stream<QuerySnapshot> getUserPhotoPosts(String email) {
    return photoPosts.where("email", isEqualTo: email).snapshots();
  }

  // like post
  Future<void> likePost(String id) async {
    final post = await textPosts.doc(id).get();
    final postData = post.data() as Map<String, dynamic>;
    // add user to the liked users
    final likedUsers = postData["likedUsers"] as List<dynamic>;
    if (likedUsers.contains(currentUser!.email)) {
      likedUsers.remove(currentUser!.email);
    } else {
      likedUsers.add(currentUser!.email);
    }
    // update post
    await textPosts.doc(id).update({"likedUsers": likedUsers});
  }

  // delete post from the database
  Future<void> deletePost(String id) async {
    await textPosts.doc(id).delete();
  }

  // read posts from the database
  Stream<QuerySnapshot> getPosts() {
    return textPosts.orderBy("timestamp", descending: true).snapshots();
  }

  // get posts of a specific user
  Stream<QuerySnapshot> getUserPosts(String email) {
    return textPosts.where("email", isEqualTo: email).snapshots();
  }

  // check if user is owner of the post
  Future<bool> isOwner(String id) async {
    final post = await textPosts.doc(id).get();
    final postData = post.data() as Map<String, dynamic>;
    final currentUsername = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser!.email)
        .get()
        .then((value) => value.data()!["username"]);
    return postData["username"] == currentUsername;
  }
}
