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

  void _followUser(String userEmail) async {
    // Check if user is already following
    final userDoc =
        FirebaseFirestore.instance.collection('users').doc(currentUser!.email);
    final userSnapshot = await userDoc.get();

    List<String> following = List<String>.from(userSnapshot['following'] ?? []);

    if (!following.contains(userEmail)) {
      // Add the user to the "following" list of the current user
      following.add(userEmail);

      // Update the current user's following list
      await userDoc.update({
        'following': following,
      });

      // Add the current user to the "followers" list of the followed user
      final followedUserDoc =
          FirebaseFirestore.instance.collection('users').doc(userEmail);
      final followedUserSnapshot = await followedUserDoc.get();
      List<String> followers =
          List<String>.from(followedUserSnapshot['followers'] ?? []);
      followers.add(currentUser!.email!);

      await followedUserDoc.update({
        'followers': followers,
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("You followed $userEmail")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppbar(title: "s o C I a l"),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("users").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Something went wrong"));
          }

          if (snapshot.hasData) {
            final users = snapshot.data!.docs;

            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final userEmail = users[index]["email"];
                return ListTile(
                  title: Text(users[index]["username"]),
                  subtitle: Text(userEmail),
                  leading: FutureBuilder(
                    future:
                        storage.getImage("profile_photos/", "${userEmail}.png"),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      if (snapshot.hasData) {
                        return CircleAvatar(
                            backgroundImage:
                                NetworkImage(snapshot.data.toString()));
                      }
                      return const Icon(Icons.person, size: 40);
                    },
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.follow_the_signs),
                    onPressed: () => _followUser(userEmail),
                  ),
                );
              },
            );
          }

          return Center(child: Text("No users found"));
        },
      ),
    );
  }
}
