import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social/Theme/theme_notifier.dart';
import 'package:social/components/my_appbar.dart';

class MyUsersPageDesktop extends StatelessWidget {
  const MyUsersPageDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final currentLanguage = themeNotifier.currentLanguage;
    return Scaffold(
      appBar: MyAppbar(title: currentLanguage["title"] ?? "s o C I a l"),
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
                  const Icon(Icons.people_alt, size: 120),
                  Text(
                      currentLanguage["something went wrong"] ??
                          "Something went wrong",
                      style: TextStyle(fontSize: 30)),
                ],
              ),
            );
          }
          // success
          if (snapshot.hasData) {
            // extract data
            final users = snapshot.data!.docs;

            return GridView.builder(
              padding: const EdgeInsets.all(30.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // Three columns
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 2,
              ),
              itemCount: users.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: ListTile(
                    title: Text(
                      users[index]["username"],
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      users[index]["email"],
                      style: TextStyle(fontSize: 20),
                    ),
                    leading: const Icon(Icons.person, size: 60),
                    contentPadding: const EdgeInsets.all(10),
                  ),
                );
              },
            );
          }
          // no data
          return Center(
            child: Column(
              children: [
                const Icon(Icons.person, size: 120),
                Text(currentLanguage["no users found"] ?? "No Users Found",
                    style: TextStyle(fontSize: 30)),
              ],
            ),
          );
        },
      ),
    );
  }
}
