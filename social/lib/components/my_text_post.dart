import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social/Responsive/dimensions.dart';
import 'package:social/database/firestore.dart';
import 'package:social/database/storage.dart';

class MyTextPost extends StatefulWidget {
  MyTextPost({super.key, required this.post});
  final post;

  @override
  State<MyTextPost> createState() => _MyTextPostState();
}

class _MyTextPostState extends State<MyTextPost> {
  final fireStore = FireStoreDatabase();

  @override
  Widget build(BuildContext context) {
    final storage = Storage();
    double width = MediaQuery.of(context).size.width;
    double widthMultiplier = width / mobileWidth > tabletWidth / mobileWidth
        ? 1
        : width / mobileWidth;
    Timestamp timestamp = widget.post["timestamp"];
    String username = widget.post["username"];
    String message = widget.post["message"];
    String email = widget.post["email"];
    // liked users
    List<dynamic> likedUsers = widget.post["likedUsers"];
    int likes = likedUsers.length;
    return Container(
      // New code
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.3),
            spreadRadius: 2,
            blurRadius: 3,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(
          color: Theme.of(context).colorScheme.secondary,
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              FutureBuilder(
                future: storage.getImage("profile_photos/", "$email.png"),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  if (snapshot.hasData) {
                    return CircleAvatar(
                      backgroundImage: NetworkImage(snapshot.data.toString()),
                      radius: 20 * widthMultiplier,
                    );
                  }
                  return CircleAvatar(
                    radius: 20 * widthMultiplier,
                    child: Icon(
                      Icons.account_circle,
                      size: 40 * widthMultiplier,
                    ),
                  );
                },
              ),
              SizedBox(width: 10),
              Text(
                username,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.inverseSurface,
                    fontSize: 24 * widthMultiplier,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 5),
              Text(
                "@${email.split("@")[0]}",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 12 * widthMultiplier,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 18 * widthMultiplier,
                  ),
                ),
              ),
              Row(
                children: [
                  Text(likes.toString()),
                  IconButton(
                    icon: Icon(Icons.star,
                        color: likedUsers.contains(fireStore.currentUser!.email)
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey),
                    onPressed: () {
                      fireStore.likePost(widget.post.id);
                      setState(() {});
                    },
                  ),
                  email == fireStore.currentUser!.email
                      ? IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            fireStore.deletePost(widget.post.id);
                            setState(() {});
                          },
                        )
                      : SizedBox()
                ],
              )
            ],
          ),
          Text(
            timestamp.toDate().toString().substring(0, 16),
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontSize: 12 * widthMultiplier,
            ),
          ),
        ],
      ),
    );
    // ListTile(
    //                     title: Text(message),
    //                     subtitle: Row(
    //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                       children: [
    //                         Text(username),
    //                         Text(
    //                             timestamp.toDate().toString().substring(0, 16)),
    //                       ],
    //                     ),
    //                     trailing: email == fireStore.currentUser!.email
    //                         ? IconButton(
    //                             icon: Icon(Icons.delete),
    //                             onPressed: () {
    //                               fireStore.deletePost(posts[index].id);
    //                               setState(() {});
    //                             },
    //                           )
    //                         : null,
    //                   )
  }
}
