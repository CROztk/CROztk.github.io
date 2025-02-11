import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social/Theme/theme_notifier.dart';
import 'package:social/database/storage.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key, this.popDrawer = true});
  final bool popDrawer;

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  final currentUser = FirebaseAuth.instance.currentUser;
  final storage = Storage();
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final currentLanguage = themeNotifier.currentLanguage;
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
                FutureBuilder(
                  future: storage.getImage(
                      "profile_photos/", "${currentUser!.email!}.png"),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return SizedBox(
                          width: 90,
                          height: 90,
                          child: const CircularProgressIndicator());
                    }
                    if (snapshot.hasData) {
                      return CircleAvatar(
                        backgroundImage: NetworkImage(snapshot.data.toString()),
                        radius: 50,
                      );
                    }
                    return const CircleAvatar(
                      radius: 50,
                      child: Icon(
                        Icons.account_circle,
                        size: 100,
                      ),
                    );
                  },
                ),
                Text(currentUser?.email ?? ''),
                SizedBox(height: 10),
              ],
            ),
          ),

          // home tile
          ListTile(
            title: Text(currentLanguage["home"] ?? "Home"),
            leading: Icon(Icons.home,
                color: Theme.of(context).colorScheme.onSurface),
            onTap: () {
              widget.popDrawer ? Navigator.pop(context) : null;
            },
          ),

          // profile tile
          ListTile(
            title: Text(currentLanguage["profile"] ?? "Profile"),
            leading: Icon(Icons.person,
                color: Theme.of(context).colorScheme.onSurface),
            onTap: () {
              // pop drawer
              widget.popDrawer ? Navigator.pop(context) : null;

              // navigate to profile page
              Navigator.pushNamed(context, '/profile');
            },
          ),

          // users tile
          ListTile(
            title: Text(currentLanguage["users"] ?? "Users"),
            leading: Icon(Icons.people,
                color: Theme.of(context).colorScheme.onSurface),
            onTap: () {
              // pop drawer
              widget.popDrawer ? Navigator.pop(context) : null;

              // navigate to users page
              Navigator.pushNamed(context, '/users');
            },
          ),

          // logout tile
          ListTile(
            title: Text(currentLanguage["logout"] ?? "Logout"),
            leading: Icon(Icons.logout,
                color: Theme.of(context).colorScheme.onSurface),
            onTap: () {
              widget.popDrawer ? Navigator.pop(context) : null;
              FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
    );
  }
}
