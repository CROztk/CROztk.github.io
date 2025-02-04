import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social/components/my_appbar.dart';
import 'package:social/database/storage.dart';

class MyUsersPageMobile extends StatefulWidget {
  const MyUsersPageMobile({super.key});

  @override
  State<MyUsersPageMobile> createState() => _MyUsersPageMobileState();
}

class _MyUsersPageMobileState extends State<MyUsersPageMobile> {
  final storage = Storage();
  final currentUser = FirebaseAuth.instance.currentUser;

  // This will hold the following status of users
  Map<String, bool> followedUsers = {};

  // Follow a user by updating Firebase Firestore
  void _followUser(String userEmail) async {
    final userDoc =
        FirebaseFirestore.instance.collection("users").doc(userEmail);

    // Add current user to the followed user's followers list
    await userDoc.update({
      'followers': FieldValue.arrayUnion([currentUser!.email]),
    });

    // Optionally, update the current user's following list as well
    await FirebaseFirestore.instance
        .collection("users")
        .doc(currentUser!.email)
        .update({
      'following': FieldValue.arrayUnion([userEmail]),
    });

    // Update the followed status locally
    setState(() {
      followedUsers[userEmail] = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("User followed successfully!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "s o C I a l",
          style: TextStyle(
              fontSize: 24, color: Colors.amber), // Updated text size and color
        ),
        actions: [
          // Home button (does nothing as per request)
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              // Keeps the user on the current page (no action needed)
            },
          ),
          // Logout button
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(
                  context, '/login'); // Navigate to login page
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("users").snapshots(),
        builder: (context, snapshot) {
          // loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // error
          if (snapshot.hasError) {
            return Center(
              child: Column(
                children: [
                  const Icon(Icons.people_alt, size: 80),
                  Text("Something went wrong"),
                ],
              ),
            );
          }
          // success
          if (snapshot.hasData) {
            // extract data
            final users = snapshot.data!.docs;

            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                String userEmail = users[index]["email"];
                bool isFollowed = followedUsers[userEmail] ?? false;

                return ListTile(
                  title: Text(users[index]["username"]),
                  subtitle: Text(users[index]["email"]),
                  leading: FutureBuilder(
                      future: storage.getImage(
                          "profile_photos/", "${users[index]["email"]}.png"),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }
                        if (snapshot.hasData) {
                          return CircleAvatar(
                            backgroundImage:
                                NetworkImage(snapshot.data.toString()),
                          );
                        }
                        return const Icon(Icons.person, size: 40);
                      }),
                  trailing: ElevatedButton(
                    onPressed: isFollowed
                        ? null // Disable button if already followed
                        : () => _followUser(userEmail),
                    child: Text(isFollowed ? "Following" : "Follow"),
                  ),
                );
              },
            );
          }
          // no data
          return Center(
            child: Column(
              children: [
                const Icon(Icons.person, size: 80),
                Text("No users found"),
              ],
            ),
          );
        },
      ),
    );
  }
}
