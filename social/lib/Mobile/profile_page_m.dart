import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:social/components/my_appbar.dart';
import 'package:social/components/my_photo_post.dart';
import 'package:social/components/my_text_post.dart';
import 'package:social/components/my_textfield.dart';
import 'package:social/database/firestore.dart';
import 'package:social/database/storage.dart';

class MyProfilePageMobile extends StatefulWidget {
  const MyProfilePageMobile({super.key});

  @override
  State<MyProfilePageMobile> createState() => _MyProfilePageMobileState();
}

class _MyProfilePageMobileState extends State<MyProfilePageMobile> {
  final storage = Storage();
  final currentUser = FirebaseAuth.instance.currentUser;
  final FireStoreDatabase fireStore = FireStoreDatabase();

  TextEditingController bioController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  Timestamp dobTimestamp = Timestamp.now();
  bool isEditing = false;
  bool isTextPostTab = true;

  // all user information fields
  // username, email, dob, bio, following, followers
  String username = '';
  String email = '';
  String dob = '';
  String bio = '';
  List<String> following = [];
  List<String> followers = [];

  // Fetch the user details from Firestore
  Future<DocumentSnapshot<Map<String, dynamic>>> loadUserDetails() async {
    final userDetails = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser!.email)
        .get();
    // set the user details
    username = userDetails['username'];
    email = userDetails['email'];
    dob = userDetails['dob'].toString().substring(0, 10);
    bio = userDetails['bio'];
    following = List<String>.from(userDetails['following'] ?? []);
    followers = List<String>.from(userDetails['followers'] ?? []);
    return userDetails;
  }

  // Fetch the list of users being followed by the current user
  Future<List<String>> getFollowingUsers() async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser!.email)
        .get();
    List<dynamic>? followingList =
        (userDoc.data() as Map<String, dynamic>?)?['following'];
    return followingList != null ? List<String>.from(followingList) : [];
  }

  void _changeProfilePicture() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    await storage.uploadImage("profile_photos/", "${currentUser!.email}");
    Navigator.of(context).pop();
    setState(() {});
  }

  void _saveProfile() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser!.email)
        .update({
      'bio': bioController.text,
      'username': nameController.text,
      'dob': dobTimestamp,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profile updated successfully!")),
    );

    setState(() {
      isEditing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppbar(title: "Profile"),
      body: FutureBuilder(
        future: loadUserDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.error, size: 80),
                Text("Something went wrong"),
              ],
            );
          }
          if (snapshot.hasData) {
            Map<String, dynamic>? user = snapshot.data!.data();
            nameController.text = user?['username'] ?? '';
            bioController.text = user?['bio'] ?? '';
            dobTimestamp = user?['dob'] ?? Timestamp.now();

            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      FutureBuilder(
                        future: storage.getImage(
                            "profile_photos/", "${currentUser!.email!}.png"),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return CircleAvatar(
                              radius: 45,
                              backgroundImage:
                                  NetworkImage(snapshot.data.toString()),
                            );
                          }
                          return const Icon(Icons.face, size: 80);
                        },
                      ),
                      SizedBox(
                        height: 110,
                        width: 110,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            IconButton(
                              onPressed: _changeProfilePicture,
                              icon: const Icon(Icons.edit),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Text(
                    username,
                    style: const TextStyle(
                        fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  Text(email),
                  Text(dobTimestamp.toDate().toString().substring(0, 10)),
                  Text(bio),
                  const Divider(),

                  // Display the list of followed users
                  FutureBuilder<List<String>>(
                    future: getFollowingUsers(),
                    builder: (context, followingSnapshot) {
                      if (followingSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      if (followingSnapshot.hasError) {
                        return const Text("Error fetching followed users.");
                      }
                      if (followingSnapshot.hasData) {
                        return Column(
                          children: [
                            Text(
                                "Following Users: ${following.length}, Followers: ${followers.length}"), // Displaying number of followed users
                          ],
                        );
                      }
                      return const Text("No users followed.");
                    },
                  ),

                  const Divider(),
                  if (!isEditing)
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isEditing = true;
                        });
                      },
                      child: const Text("Edit Profile"),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          MyTextfield(
                              text: "Edit Username",
                              obscureText: false,
                              controller: nameController),
                          const SizedBox(height: 10),
                          TextButton(
                              onPressed: () {
                                showDatePicker(
                                  context: context,
                                  initialDate:
                                      DateTime(DateTime.now().year - 18),
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime(DateTime.now().year - 18),
                                ).then((value) {
                                  if (value != null) {
                                    dobTimestamp = Timestamp.fromDate(value);
                                  }
                                });
                              },
                              child: Text(dobTimestamp
                                  .toDate()
                                  .toString()
                                  .substring(0, 10))),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: bioController,
                            maxLines: 3,
                            decoration: const InputDecoration(
                              labelText: 'Edit Bio',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      isEditing = false;
                                    });
                                  },
                                  child: const Text("Cancel")),
                              ElevatedButton(
                                onPressed: _saveProfile,
                                child: const Text("Save Profile"),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  const Divider(),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => isTextPostTab = true),
                          child: Container(
                            margin: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: isTextPostTab
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.grey,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text("Text Posts",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: isTextPostTab
                                        ? Colors.white
                                        : Colors.black)),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => isTextPostTab = false),
                          child: Container(
                            margin: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: isTextPostTab
                                    ? Colors.grey
                                    : Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(10)),
                            child: Text("Image Posts",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: isTextPostTab
                                        ? Colors.black
                                        : Colors.white)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  StreamBuilder(
                    stream: isTextPostTab
                        ? fireStore.getUserPosts(email)
                        : fireStore.getUserPhotoPosts(email),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Column(
                          children: const [
                            Icon(Icons.error, size: 80),
                            Text("Something went wrong"),
                          ],
                        );
                      }
                      if (snapshot.hasData) {
                        final posts = snapshot.data!.docs;
                        return Expanded(
                          child: ListView.builder(
                            itemCount: posts.length,
                            itemBuilder: (context, index) {
                              return isTextPostTab
                                  ? MyTextPost(
                                      post: posts[index],
                                    )
                                  : MyPhotoPost(
                                      post: posts[index],
                                    );
                            },
                          ),
                        );
                      }
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.face_retouching_off, size: 80),
                          Text("No data"),
                        ],
                      );
                    },
                  )
                ],
              ),
            );
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.face_retouching_off, size: 80),
              Text("No data"),
            ],
          );
        },
      ),
    );
  }
}
