import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social/Theme/theme_notifier.dart';
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
    dob = userDetails["dob"].toString().isEmpty
        ? ""
        : userDetails['dob'].toString().substring(0, 10);
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

    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final currentLanguage = themeNotifier.currentLanguage;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(currentLanguage["profile updated successfully!"] ??
              "Profile updated successfully!")),
    );

    setState(() {
      isEditing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final currentLanguage = themeNotifier.currentLanguage;
    return Scaffold(
      appBar: MyAppbar(title: currentLanguage["profile"] ?? "Profile"),
      body: FutureBuilder(
        future: loadUserDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            print(snapshot.error);
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error, size: 80),
                Text(currentLanguage["something went wrong"] ??
                    "Something went wrong"),
              ],
            );
          }
          if (snapshot.hasData) {
            Map<String, dynamic>? user = snapshot.data!.data();
            nameController.text = user?['username'] ?? '';
            bioController.text = user?['bio'] ?? '';
            dobTimestamp = user?['dob'] ?? Timestamp.now();

            return Center(
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          FutureBuilder(
                            future: storage.getImage("profile_photos/",
                                "${currentUser!.email!}.png"),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      width: 5,
                                    ),
                                  ),
                                  child: CircleAvatar(
                                    radius: 55,
                                    backgroundImage:
                                        NetworkImage(snapshot.data.toString()),
                                  ),
                                );
                              }
                              return const Icon(Icons.face, size: 110);
                            },
                          ),
                          SizedBox(
                            height: 130,
                            width: 130,
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
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize: 32,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                          "@${email.split("@")[0]} 🎈 ${dobTimestamp.toDate().toString().substring(0, 10)}",
                          style: TextStyle(
                              fontSize: 10,
                              color: Theme.of(context).colorScheme.onSurface)),
                      Text(bio,
                          style: TextStyle(
                              fontSize: 18,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withValues(alpha: 0.5))),

                      // Display the number of followed users and followers
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Text(
                                following.length.toString(),
                                style: const TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.bold),
                              ),
                              Text(currentLanguage["following"] ?? "Following",
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withValues(alpha: 0.5))),
                            ],
                          ),
                          Container(
                            height: 30,
                            width: 1,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          Column(
                            children: [
                              Text(followers.length.toString(),
                                  style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold)),
                              Text(currentLanguage["followers"] ?? "Followers",
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withValues(alpha: 0.5))),
                            ],
                          ),
                        ],
                      ),

                      const Divider(),
                      if (!isEditing)
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              isEditing = true;
                            });
                          },
                          child: Text(currentLanguage["edit profile"] ??
                              "Edit Profile"),
                        )
                      else
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              TextButton(
                                  onPressed: () {
                                    showDatePicker(
                                      context: context,
                                      initialDate:
                                          DateTime(DateTime.now().year - 18),
                                      firstDate: DateTime(1900),
                                      lastDate:
                                          DateTime(DateTime.now().year - 18),
                                    ).then((value) {
                                      if (value != null) {
                                        dobTimestamp =
                                            Timestamp.fromDate(value);
                                      }
                                    });
                                  },
                                  child: Text(dobTimestamp
                                      .toDate()
                                      .toString()
                                      .substring(0, 10))),
                              const SizedBox(height: 10),
                              MyTextfield(
                                  text: currentLanguage["edit username"] ??
                                      "Edit Username",
                                  obscureText: false,
                                  controller: nameController),
                              const SizedBox(height: 10),
                              TextFormField(
                                controller: bioController,
                                maxLines: 3,
                                decoration: InputDecoration(
                                  labelText:
                                      currentLanguage['edit bio'] ?? "Edit Bio",
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          isEditing = false;
                                        });
                                      },
                                      child: Text(currentLanguage["cancel"] ??
                                          "Cancel")),
                                  ElevatedButton(
                                    onPressed: _saveProfile,
                                    child: Text(
                                        currentLanguage["save profile"] ??
                                            "Save Profile"),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      const Divider(),

                      StreamBuilder(
                        stream: isTextPostTab
                            ? fireStore.getUserPosts(email)
                            : fireStore.getUserPhotoPosts(email),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          if (snapshot.hasError) {
                            return Column(
                              children: [
                                Icon(Icons.error, size: 80),
                                Text(currentLanguage["something went wrong"] ??
                                    "Something went wrong"),
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
                            children: [
                              Icon(Icons.face_retouching_off, size: 80),
                              Text(currentLanguage["no data"] ?? "No data"),
                            ],
                          );
                        },
                      )
                    ],
                  ), // Text and Image Posts tabs
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () => setState(() => isTextPostTab = true),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: isTextPostTab
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.grey,
                              borderRadius: BorderRadius.horizontal(
                                left: Radius.circular(30),
                              ),
                            ),
                            child: Text(
                                currentLanguage["text posts"] ?? "Text Posts",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white)),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => setState(() => isTextPostTab = false),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: isTextPostTab
                                    ? Colors.grey
                                    : Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.horizontal(
                                  right: Radius.circular(30),
                                )),
                            child: Text(
                                currentLanguage["image posts"] ?? "Image Posts",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.face_retouching_off, size: 80),
              Text(currentLanguage["no data"] ?? "No data"),
            ],
          );
        },
      ),
    );
  }
}
