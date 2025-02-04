import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social/database/firestore.dart';

class MyPhotoPost extends StatefulWidget {
  const MyPhotoPost({super.key, required this.post});
  final post;

  @override
  State<MyPhotoPost> createState() => _MyPhotoPostState();
}

class _MyPhotoPostState extends State<MyPhotoPost> {
  final firestore = FireStoreDatabase();

  @override
  Widget build(BuildContext context) {
    Timestamp timestamp = widget.post["timestamp"];
    String username = widget.post["username"];
    String message = widget.post["message"];
    String email = widget.post["email"];
    String imageURL = widget.post["imageURL"];
    // liked users
    List<dynamic> likedUsers = widget.post["likedUsers"];
    int likes = likedUsers.length;
    return Container(
      // New code
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.3),
            spreadRadius: 3,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Image.network(imageURL),
          ListTile(
            title: Text(message),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(username),
                Text(timestamp.toDate().toString().substring(0, 16)),
              ],
            ),
            trailing: email == firestore.currentUser!.email
                ? IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      // Delete the post
                      firestore.deletePhotoPost(widget.post.id);
                      setState(() {});
                    },
                  )
                : null,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(Icons.thumb_up,
                    color: likedUsers.contains(firestore.currentUser!.email)
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey),
                onPressed: () {
                  firestore.likePhotoPost(widget.post.id);
                  setState(() {});
                },
              ),
              Text(likes.toString()),
            ],
          )
        ],
      ),
    );
  }
}
