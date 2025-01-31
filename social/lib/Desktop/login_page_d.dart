import 'package:flutter/material.dart';
import 'package:social/components/my_appbar.dart';
import 'package:social/components/my_textfield.dart';

class MyLoginPageDesktop extends StatelessWidget {
  const MyLoginPageDesktop({super.key});

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
              const Text('This is the Desktop login page'),
              SizedBox(
                width: 740,
                child: MyTextfield(
                    text: "Username",
                    obscureText: false,
                    controller: TextEditingController()),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 740,
                child: MyTextfield(
                    text: "Password",
                    obscureText: true,
                    controller: TextEditingController()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
