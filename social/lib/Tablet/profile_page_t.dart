import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social/Theme/theme_notifier.dart';
import 'package:social/components/my_appbar.dart';
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
  TextEditingController dobController = TextEditingController();
  bool isEditing = false;

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserDetails() async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser!.email)
        .get();
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
      'dob': dobController.text,
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
      appBar: MyAppbar(title: currentLanguage["title"] ?? "s o C I a l"),
      body: FutureBuilder(
        future: getUserDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
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
            dobController.text = user?['dob'] ?? '';

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
                    user!["username"],
                    style: const TextStyle(
                        fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  Text(user["email"]),
                  Text(user["dob"] ?? "No birth date provided"),
                  Text(user["bio"] ?? "No bio available"),
                  const Divider(),
                  if (!isEditing)
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isEditing = true;
                        });
                      },
                      child: Text(
                          currentLanguage["edit profile"] ?? "Edit Profile"),
                    ),
                  if (isEditing)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: nameController,
                            decoration: InputDecoration(
                              labelText: currentLanguage["edit username"] ??
                                  "Edit Username",
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: dobController,
                            decoration: const InputDecoration(
                              labelText: 'Edit Date of Birth',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            controller: bioController,
                            maxLines: 3,
                            decoration: InputDecoration(
                              labelText:
                                  currentLanguage["edit bio"] ?? "Edit Bio",
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: _saveProfile,
                            child: Text(currentLanguage["save profile"] ??
                                "Save Profile"),
                          ),
                        ],
                      ),
                    ),
                  const Divider(),
                  StreamBuilder(
                    stream: fireStore.getPosts(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
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
                                  icon: const Icon(Icons.delete),
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
