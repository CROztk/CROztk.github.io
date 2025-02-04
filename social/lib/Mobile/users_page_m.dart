import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyUsersPageMobile extends StatefulWidget {
  @override
  _MyUsersPageMobileState createState() => _MyUsersPageMobileState();
}

class _MyUsersPageMobileState extends State<MyUsersPageMobile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? currentUser;
  Map<String, bool> followedUsers =
      {}; // To store the follow status for each user

  @override
  void initState() {
    super.initState();
    currentUser = _auth.currentUser;
    _loadFollowedUsers();
  }

  // Load the list of followed users from Firestore
  Future<void> _loadFollowedUsers() async {
    if (currentUser == null) return;

    final docSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser!.email)
        .get();

    final followingList = List<String>.from(docSnapshot['following'] ?? []);

    setState(() {
      followedUsers.clear(); // Clear previous follow status
      for (var user in followingList) {
        followedUsers[user] = true; // Mark users as followed
      }
    });
  }

  // Follow a user and update Firestore
  Future<void> _followUser(String userEmail) async {
    if (currentUser == null) return;

    // Add the user to the current user's 'following' list
    await FirebaseFirestore.instance
        .collection("users")
        .doc(currentUser!.email)
        .update({
      'following': FieldValue.arrayUnion([userEmail]),
    });

    // Add the current user to the followed user's 'followers' list
    await FirebaseFirestore.instance.collection("users").doc(userEmail).update({
      'followers': FieldValue.arrayUnion([currentUser!.email]),
    });

    setState(() {
      followedUsers[userEmail] = true; // Update button to "Following"
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("User followed successfully!")),
    );
  }

  // Unfollow a user and update Firestore
  Future<void> _unfollowUser(String userEmail) async {
    if (currentUser == null) return;

    // Remove the user from the current user's 'following' list
    await FirebaseFirestore.instance
        .collection("users")
        .doc(currentUser!.email)
        .update({
      'following': FieldValue.arrayRemove([userEmail]),
    });

    // Remove the current user from the followed user's 'followers' list
    await FirebaseFirestore.instance.collection("users").doc(userEmail).update({
      'followers': FieldValue.arrayRemove([currentUser!.email]),
    });

    setState(() {
      followedUsers[userEmail] = false; // Update button to "Follow"
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("User unfollowed successfully!")),
    );
  }

  // Show dialog to confirm unfollow action
  void _showUnfollowDialog(String userEmail) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Unfollow $userEmail?"),
          content: const Text("Are you sure you want to unfollow this user?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                _unfollowUser(userEmail);
                Navigator.of(context).pop();
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Users"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('email', isNotEqualTo: currentUser!.email)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error loading users'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No users found'));
          }

          var users = snapshot.data!.docs;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              var userData = users[index];
              String userEmail = userData['email'];

              return ListTile(
                title: Text(userData['name'] ?? 'No Name'),
                subtitle: Text(userEmail),
                trailing: followedUsers[userEmail] == true
                    ? ElevatedButton(
                        onPressed: () {
                          _showUnfollowDialog(
                              userEmail); // Show unfollow dialog
                        },
                        child: const Text("Following"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.blue, // Indicating the user is following
                        ),
                      )
                    : ElevatedButton(
                        onPressed: () {
                          _followUser(userEmail); // Follow the user
                        },
                        child: const Text("Follow"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey, // Default color
                        ),
                      ),
              );
            },
          );
        },
      ),
    );
  }
}
