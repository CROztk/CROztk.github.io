import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social/components/my_appbar.dart';

class MyProfilePageDesktop extends StatelessWidget {
  MyProfilePageDesktop({super.key});

  // current user
  final currentUser = FirebaseAuth.instance.currentUser;

  // get details of the user
  Future<DocumentSnapshot<Map<String, dynamic>>> getUserDetails() async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser!.email)
        .get();
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
                const Icon(Icons.face_retouching_off, size: 120),
                Text("Something went wrong"),
              ],
            );
          }
          // success
          if (snapshot.hasData) {
            // extract data
            Map<String, dynamic>? user = snapshot.data!.data();

            return Center(
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.face, size: 150),
                    SizedBox(height: 20),
                    Text(
                      user!["username"],
                      style:
                          TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 15),
                    Text(user["email"], style: TextStyle(fontSize: 30)),
                    SizedBox(height: 30),
                    // Add additional user info sections
                    Text(
                      "Followers: 120", // Just an example
                      style: TextStyle(fontSize: 25),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Bio: Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
                      style: TextStyle(fontSize: 25),
                    ),
                  ],
                ),
              ),
            );
          }

          // no data
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.face_retouching_off, size: 120),
              Text("No data"),
            ],
          );
        },
      ),
    );
  }
}
