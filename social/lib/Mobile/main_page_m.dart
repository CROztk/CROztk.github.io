import 'package:flutter/material.dart';
import 'package:social/components/my_appbar.dart';
import 'package:social/components/my_drawer.dart';

class MyMainPageMobile extends StatelessWidget {
  const MyMainPageMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: MyAppbar(title: "s o C I a l"),
      drawer: MyDrawer(),
      body: Center(
        child: Text('Main Page Mobile'),
      ),
    );
  }
}
