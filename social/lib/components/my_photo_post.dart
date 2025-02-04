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
          Image.network(widget.post["imageURL"]),
          ListTile(
            title: Text(widget.post["message"]),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.post["username"]),
                Text(widget.post["timestamp"]
                    .toDate()
                    .toString()
                    .substring(0, 16)),
              ],
            ),
            trailing: widget.post["email"] == widget.post["email"]
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
        ],
      ),
    );
  }
}
