import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
            ),
            child: Column(
              children: [
                Icon(
                  Icons.account_circle,
                  size: 100,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                Text(FirebaseAuth.instance.currentUser?.email ?? ''),
              ],
            ),
          ),
          ListTile(
            title: const Text('Logout'),
            leading: Icon(Icons.logout,
                color: Theme.of(context).colorScheme.onSurface),
            onTap: () {
              Navigator.pop(context);
              FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
    );
  }
}
