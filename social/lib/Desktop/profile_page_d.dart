import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social/Theme/theme_notifier.dart';
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
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final currentLanguage = themeNotifier.currentLanguage;
    return Scaffold(
        appBar: MyAppbar(title: currentLanguage["title"] ?? "s o C I a l"),
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
                  const Icon(Icons.face_retouching_off, size: 160),
                  Text(
                      currentLanguage["something went wrong"] ??
                          "Something went wrong",
                      style: TextStyle(fontSize: 32)),
                ],
              );
            }
            // success
            if (snapshot.hasData) {
              // extract data
              Map<String, dynamic>? user = snapshot.data!.data();

              return Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.face, size: 160),
                    Text(
                      user!["username"],
                      style:
                          TextStyle(fontSize: 64, fontWeight: FontWeight.bold),
                    ),
                    Text(user["email"], style: TextStyle(fontSize: 32)),
                  ],
                ),
              );
            }

            // no data
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.face_retouching_off, size: 160),
                Text(currentLanguage["no data"] ?? "No Data",
                    style: TextStyle(fontSize: 32)),
              ],
            );
          },
        ));
  }
}
