import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social/components/my_appbar.dart';
import 'package:social/database/firestore.dart';
import 'package:social/database/storage.dart';

class MyProfilePageMobile extends StatefulWidget {
  const MyProfilePageMobile({super.key});

  @override
  State<MyProfilePageMobile> createState() => _MyProfilePageMobileState();
}

class _MyProfilePageMobileState extends State<MyProfilePageMobile> {
  // storage
  final storage = Storage();

  // current user
  final currentUser = FirebaseAuth.instance.currentUser;

  // firestore access
  final FireStoreDatabase fireStore = FireStoreDatabase();

  // get details of the user
  Future<DocumentSnapshot<Map<String, dynamic>>> getUserDetails() async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser!.email)
        .get();
  }

  // image picker to change profile picture
  void _changeProfilePicture() async {
    // show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    // upload image
    await storage.uploadImage("profile_photos/", "${currentUser!.email}");

    // close loading circle
    Navigator.of(context).pop();

    // update UI
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppbar(title: "s o C I a l"),
        body: FutureBuilder(
          future: getUserDetails(),
          builder: (context, snapshot) {
            // loading
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            // error
            if (snapshot.hasError) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.face_retouching_off, size: 80),
                  Text("Something went wrong"),
                ],
              );
            }
            // success
            if (snapshot.hasData) {
              // extract data
              Map<String, dynamic>? user = snapshot.data!.data();

              return Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(alignment: Alignment.center, children: [
                      FutureBuilder(
                          future: storage.getImage(
                              "profile_photos/", "${currentUser!.email!}.png"),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              String url = snapshot.data.toString();
                              return CircleAvatar(
                                radius: 45,
                                backgroundImage: NetworkImage(url),
                              );
                            }
                            return const Icon(Icons.face, size: 80);
                          }),
                      SizedBox(
                        height: 110,
                        width: 110,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              IconButton(
                                  onPressed: _changeProfilePicture,
                                  icon: Icon(Icons.edit))
                            ]),
                      )
                    ]),
                    Text(
                      user!["username"],
                      style:
                          TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                    ),
                    Text(user["email"]),
                    Divider(),
                    // user's posts
                    StreamBuilder(
                      stream: fireStore.getPosts(),
                      builder: (context, snapshot) {
                        // loading
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        // error
                        if (snapshot.hasError) {
                          return Column(
                            children: [
                              const Icon(Icons.error, size: 80),
                              Text("Something went wrong"),
                            ],
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
                                String username = posts[index]["username"];
                                String message = posts[index]["message"];
                                if (user["username"] != username) {
                                  return const SizedBox();
                                }
                                return ListTile(
                                  title: Text(message),
                                  subtitle: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(username),
                                      Text(timestamp
                                          .toDate()
                                          .toString()
                                          .substring(0, 16)),
                                    ],
                                  ),
                                  trailing: IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () {
                                      fireStore.deletePost(posts[index].id);
                                      setState(() {});
                                    },
                                  ),
                                );
                              },
                            ),
                          );
                        }
                        // no data
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.face_retouching_off, size: 80),
                            Text("No data"),
                          ],
                        );
                      },
                    )
                  ],
                ),
              );
            }

            // no data
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.face_retouching_off, size: 80),
                Text("No data"),
              ],
            );
          },
        ));
  }
}
