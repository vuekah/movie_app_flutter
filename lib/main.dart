import 'package:flutter/material.dart';
import 'package:movie_app_flutter/pages/home.page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          textTheme: const TextTheme(
            bodyMedium: TextStyle(color: Colors.white),
          ),
          appBarTheme: const AppBarTheme(
            surfaceTintColor: Colors.transparent,
            backgroundColor: Color(0xFF242A32),
            centerTitle: true,
            foregroundColor: Colors.white,
            titleTextStyle: TextStyle(
                color: Colors.white,
                fontFamily: "Montserrat",
                fontWeight: FontWeight.w700,
                fontSize: 16),
          ),
          scaffoldBackgroundColor: const Color(0xFF242A32)
          ),
      home: const HomePage(),
    );
  }
}
