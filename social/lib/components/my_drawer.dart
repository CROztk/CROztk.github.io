import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          // drawer header
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
                SizedBox(height: 10),
              ],
            ),
          ),

          // home tile
          ListTile(
            title: const Text('H O M E'),
            leading: Icon(Icons.home,
                color: Theme.of(context).colorScheme.onSurface),
            onTap: () {
              Navigator.pop(context);
            },
          ),

          // profile tile
          ListTile(
            title: const Text('P R O F I L E'),
            leading: Icon(Icons.person,
                color: Theme.of(context).colorScheme.onSurface),
            onTap: () {
              // pop drawer
              Navigator.pop(context);

              // navigate to profile page
              Navigator.pushNamed(context, '/profile');
            },
          ),

          // users tile
          ListTile(
            title: const Text('U S E R S'),
            leading: Icon(Icons.person,
                color: Theme.of(context).colorScheme.onSurface),
            onTap: () {
              // pop drawer
              Navigator.pop(context);

              // navigate to users page
              Navigator.pushNamed(context, '/users');
            },
          ),

          // logout tile
          ListTile(
            title: const Text('L O G O U T'),
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
