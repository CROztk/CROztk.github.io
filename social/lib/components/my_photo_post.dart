import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social/Responsive/dimensions.dart';
import 'package:social/database/firestore.dart';
import 'package:social/database/storage.dart';

class MyPhotoPost extends StatefulWidget {
  const MyPhotoPost({super.key, required this.post, this.isUserAdmin = false});
  final post;
  final bool isUserAdmin;

  @override
  State<MyPhotoPost> createState() => _MyPhotoPostState();
}

class _MyPhotoPostState extends State<MyPhotoPost> {
  final firestore = FireStoreDatabase();
  final storage = Storage();

  @override
  Widget build(BuildContext context) {
    User currentUser = FirebaseAuth.instance.currentUser!;
    double fullWidth = MediaQuery.of(context).size.width;
    double width = fullWidth > tabletWidth ? mobileWidth : fullWidth;
    double widthMultiplier = (width / mobileWidth) > (tabletWidth / mobileWidth)
        ? 1
        : width / mobileWidth;
    Timestamp timestamp = widget.post["timestamp"];
    String username = widget.post["username"];
    String message = widget.post["message"];
    String email = widget.post["email"];
    String imageURL = widget.post["imageURL"];

    // liked users
    List<dynamic> likedUsers = widget.post["likedUsers"];
    int likes = likedUsers.length;
    return GestureDetector(
      onDoubleTap: () {
        firestore.likePhotoPost(widget.post.id);
        setState(() {});
      },
      child: Container(
        // New code
        margin: const EdgeInsets.all(10),
        width: width,
        height: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          color: Theme.of(context).colorScheme.secondary,
          boxShadow: [
            // BoxShadow(
            //   color: Colors.grey.withValues(alpha: 0.3),
            //   spreadRadius: 3,
            //   blurRadius: 5,
            //   offset: const Offset(0, 3),
            // ),
          ],
        ),
        child: Stack(alignment: Alignment.bottomCenter, children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: Image.network(
              imageURL,
              width: width,
              height: width,
              fit: BoxFit.cover,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // post owner's info
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        width: width * 0.5,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(
                            color: Theme.of(context).colorScheme.primary,
                            width: 3,
                          ),
                        ),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
                          child: Row(
                            children: [
                              FutureBuilder(
                                future: storage.getImage(
                                    "profile_photos/", "$email.png"),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const CircularProgressIndicator();
                                  }
                                  if (snapshot.hasData) {
                                    return CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          snapshot.data.toString()),
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
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    username,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24 * widthMultiplier,
                                    ),
                                  ),
                                  Text(
                                    "@${email.split("@")[0]}",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12 * widthMultiplier,
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    (email == currentUser.email || widget.isUserAdmin)
                        ? Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.3),
                                  spreadRadius: 0,
                                  blurRadius: 2,
                                  offset: const Offset(0, 0),
                                ),
                              ],
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                firestore.deletePhotoPost(widget.post.id);
                                setState(() {});
                              },
                            ),
                          )
                        : SizedBox(),
                  ],
                ),
              ),
              Container(
                height: width * 0.2,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      spreadRadius: 0,
                      blurRadius: 2,
                      offset: const Offset(0, 0),
                    ),
                  ],
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(40),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            message,
                            maxLines: 2,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20 * widthMultiplier,
                            ),
                          ),
                          Text(
                            timestamp.toDate().toString().substring(0, 16),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12 * widthMultiplier,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.star,
                            color: likedUsers.contains(currentUser.email)
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.secondary,
                            size: 40 * widthMultiplier,
                          ),
                          onPressed: () {
                            firestore.likePhotoPost(widget.post.id);
                            setState(() {});
                          },
                        ),
                        Text(
                          likes.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24 * widthMultiplier,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          )
        ]),
      ),
    );
  }
}
