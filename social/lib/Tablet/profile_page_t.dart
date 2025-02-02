import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social/components/my_appbar.dart';

class MyProfilePageTablet extends StatelessWidget {
  MyProfilePageTablet({super.key});

  // Current user
  final currentUser = FirebaseAuth.instance.currentUser;

  // Get details of the user
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
          // Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // Error
          if (snapshot.hasError) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.face_retouching_off, size: 80),
                Text("Something went wrong"),
              ],
            );
          }
          // Success
          if (snapshot.hasData) {
            // Extract data
            Map<String, dynamic>? user = snapshot.data!.data();

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Adjusted position and size of the icon
                  SizedBox(height: 40), // Adjusting the position of the icon
                  const Icon(Icons.face, size: 100), // Enlarged icon

                  // Adjusted text size
                  SizedBox(height: 20), // Spacing between the icon and text
                  Text(
                    user!["username"],
                    style: TextStyle(
                        fontSize: 60,
                        fontWeight: FontWeight.bold), // Enlarged text
                  ),
                  Text(
                    user["email"],
                    style: TextStyle(fontSize: 30), // Enlarged email text
                  ),
                ],
              ),
            );
          }

          // No data
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.face_retouching_off, size: 80),
              Text("No data"),
            ],
          );
        },
      ),
    );
  }
}
