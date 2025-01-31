import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social/Responsive/responsive_layout.dart';
import 'package:social/Theme/theme_modes.dart';
import 'package:social/Theme/theme_notifier.dart';

void main() {
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
          home: const ResponsiveLayout(),
          themeMode: themeNotifier.themeMode,
        );
      },
    );
  }
}
