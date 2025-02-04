import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social/Responsive/dimensions.dart';
import 'package:social/database/storage.dart';

class MyUserCard extends StatefulWidget {
  const MyUserCard(
      {super.key, required this.userData, required this.followedUsers});
  final QueryDocumentSnapshot<Object?> userData;
  final Map<String, bool> followedUsers;

  @override
  State<MyUserCard> createState() => _MyUserCardState();
}

class _MyUserCardState extends State<MyUserCard> {
  final currentUser = FirebaseAuth.instance.currentUser;
  final storage = Storage();

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
      widget.followedUsers[userEmail] = true; // Update button to "Following"
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
      widget.followedUsers[userEmail] = false; // Update button to "Follow"
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
    // screen width multiplier
    double width = MediaQuery.of(context).size.width;
    double widthMultiplier = MediaQuery.of(context).size.width / 375;
    // all user data fields
    String userEmail = widget.userData['email'];
    String username = widget.userData['username'];
    String bio = widget.userData['bio'];
    String followers = widget.userData['followers'].length.toString();
    String following = widget.userData['following'].length.toString();
    String dob = widget.userData['dob'].toDate().toString().substring(0, 10);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FutureBuilder(
              future: storage.getImage(
                  "profile_photos/", "${widget.userData['email']}.png"),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SizedBox(
                      width: 90 * widthMultiplier,
                      height: 90 * widthMultiplier,
                      child: const CircularProgressIndicator());
                }
                if (snapshot.hasData) {
                  return CircleAvatar(
                    backgroundImage: NetworkImage(snapshot.data.toString()),
                    radius: 50 * widthMultiplier,
                  );
                }
                return CircleAvatar(
                  radius: 50 * widthMultiplier,
                  child: Icon(
                    Icons.account_circle,
                    size: 100 * widthMultiplier,
                  ),
                );
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(username,
                        style: TextStyle(
                            fontSize: 24 * widthMultiplier,
                            fontWeight: FontWeight.bold)),
                    Text(userEmail),
                    Text(bio),
                    Text(" $dob"),
                    width <= mobileWidth
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                      child: Text("Followers: $followers")),
                                  SizedBox(width: 10 * widthMultiplier),
                                  Container(
                                      child: Text("Following: $following")),
                                ],
                              ),
                              SizedBox(height: 10 * widthMultiplier),
                              widget.followedUsers[userEmail] == true
                                  ? ElevatedButton(
                                      onPressed: () {
                                        _showUnfollowDialog(userEmail);
                                      },
                                      child: const Text("Following"),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue,
                                      ),
                                    )
                                  : ElevatedButton(
                                      onPressed: () {
                                        _followUser(userEmail);
                                      },
                                      child: const Text("Follow"),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                      ),
                                    ),
                            ],
                          )
                        : SizedBox()
                  ],
                ),
                SizedBox(width: 20 * widthMultiplier),
                width > mobileWidth
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(child: Text("Followers: $followers")),
                              SizedBox(width: 10 * widthMultiplier),
                              Container(child: Text("Following: $following")),
                            ],
                          ),
                          SizedBox(height: 10 * widthMultiplier),
                          widget.followedUsers[userEmail] == true
                              ? ElevatedButton(
                                  onPressed: () {
                                    _showUnfollowDialog(userEmail);
                                  },
                                  child: const Text("Following"),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                  ),
                                )
                              : ElevatedButton(
                                  onPressed: () {
                                    _followUser(userEmail);
                                  },
                                  child: const Text("Follow"),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                  ),
                                ),
                        ],
                      )
                    : SizedBox(),
              ],
            )
          ],
        ),
      ),
    );
  }
}
