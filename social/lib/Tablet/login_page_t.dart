import 'package:flutter/material.dart';

class MyLoginPageTablet extends StatelessWidget {
  const MyLoginPageTablet({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("s o C I a l"),
        elevation: 1,
      ),
      body: const Center(
        child: Text('This is the Tablet login page'),
      ),
    );
  }
}
