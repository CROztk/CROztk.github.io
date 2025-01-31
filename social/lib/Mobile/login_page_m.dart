import 'package:flutter/material.dart';
import 'package:social/components/my_appbar.dart';
import 'package:social/components/my_textfield.dart';

class MyLoginPageMobile extends StatefulWidget {
  const MyLoginPageMobile({super.key});

  @override
  State<MyLoginPageMobile> createState() => _MyLoginPageMobileState();
}

class _MyLoginPageMobileState extends State<MyLoginPageMobile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppbar(title: "s o C I a l"),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('This is the Mobile login page'),
              MyTextfield(
                  text: "Username",
                  obscureText: false,
                  controller: TextEditingController()),
              SizedBox(height: 10),
              MyTextfield(
                  text: "Password",
                  obscureText: true,
                  controller: TextEditingController()),
            ],
          ),
        ),
      ),
    );
  }
}
