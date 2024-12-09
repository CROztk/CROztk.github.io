import 'package:cro_website/pages/MyHomePage.dart';
import 'package:cro_website/pages/MyLoginPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
