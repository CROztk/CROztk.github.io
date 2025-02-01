import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social/Responsive/responsive_layout_loginout.dart';
import 'package:social/Responsive/responsive_layout_mainmenu.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ResponsiveLayoutMainmenu();
        } else {
          return ResponsiveLayoutLoginout();
        }
      },
    );
  }
}
