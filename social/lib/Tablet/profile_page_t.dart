import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social/components/my_appbar.dart';

class MyProfilePageTablet extends StatelessWidget {
  MyProfilePageTablet({super.key});

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
                const Icon(Icons.face_retouching_off, size: 100),
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
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.face, size: 120),
                    SizedBox(height: 20),
                    Text(
                      user!["username"],
                      style:
                          TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(user["email"], style: TextStyle(fontSize: 20)),
                    SizedBox(height: 20),
                    // Add more profile details if needed here
                  ],
                ),
              ),
            );
          }

          // no data
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.face_retouching_off, size: 100),
              Text("No data"),
            ],
          );
        },
      ),
    );
  }
}
