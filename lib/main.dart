import 'package:cro_website/pages/MyHomePage.dart';
import 'package:cro_website/pages/MyLoginPage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Civan Rıdar Öztekin Form',
      debugShowCheckedModeBanner: false,
      routes: {
        '/home': (context) => const MyHomePage(),
        '/login': (context) => const MyLoginPage(),
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          surface: const Color(0xFFCFE3CB),
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}
