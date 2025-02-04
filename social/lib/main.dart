import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social/Mobile/main_page_m.dart';
import 'package:social/Mobile/profile_page_m.dart';
import 'package:social/Mobile/users_page_m.dart';
import 'package:social/Theme/theme_modes.dart';
import 'package:social/Theme/theme_notifier.dart';
import 'package:social/auth/auth.dart';
import 'package:social/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(ChangeNotifierProvider(
    create: (context) => ThemeNotifier(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        return MaterialApp(
          title: 's o C I a l',
          debugShowCheckedModeBanner: false,
          theme: lightTheme,
          darkTheme: darkTheme,
          home: const AuthPage(),
          themeMode: themeNotifier.themeMode,
          routes: {
            "/home": (context) => const MyMainPageMobile(),
            "/profile": (context) => MyProfilePageMobile(),
            "/users": (context) => MyUsersPageMobile(),
          },
        );
      },
    );
  }
}
