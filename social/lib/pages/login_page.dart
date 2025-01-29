import 'package:flutter/material.dart';
import 'package:social/components/my_appbar.dart';

class MyLoginPage extends StatelessWidget {
  const MyLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppbar(title: "s o C I a l"),
      body: const Center(
        child: Text('This is the login page'),
      ),
    );
  }
}
