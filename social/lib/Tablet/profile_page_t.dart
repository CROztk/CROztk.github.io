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

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profile updated successfully!")),
    );

    setState(() {
      isEditing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    bool isTablet = screenWidth > 600;

    return Scaffold(
      appBar: MyAppbar(title: "Profile"),
      body: FutureBuilder(
        future: getUserDetails(),
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
            dobController.text = user?['dob'] ?? '';

            return SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: isTablet ? screenWidth * 0.2 : 16),
                  child: Column(
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
                                return CircleAvatar(
                                  radius: isTablet ? 80 : 45,
                                  backgroundImage:
                                      NetworkImage(snapshot.data.toString()),
                                );
                              }
                              return const Icon(Icons.face, size: 80);
                            },
                          ),
                          SizedBox(
                            height: isTablet ? 140 : 110,
                            width: isTablet ? 140 : 110,
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
                        style: TextStyle(
                          fontSize: isTablet ? 36 : 32,
                          fontWeight: FontWeight.bold,
                        ),
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
                          child: const Text("Edit Profile"),
                        ),
                      if (isEditing)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              TextFormField(
                                controller: nameController,
                                decoration: const InputDecoration(
                                  labelText: 'Edit Name',
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
                              ElevatedButton(
                                onPressed: _saveProfile,
                                child: const Text("Save Profile"),
                              ),
                            ],
                          ),
                        ),
                      const Divider(),
                      StreamBuilder(
                        stream: fireStore.getPosts(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
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
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
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
                                  subtitle: Text(timestamp.toDate().toString()),
                                );
                              },
                            );
                          }
                          return const Text("No data available");
                        },
                      )
                    ],
                  ),
                ),
              ),
            );
          }
          return const Text("No data available");
        },
      ),
    );
  }
}
