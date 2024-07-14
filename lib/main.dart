import 'package:flutter/material.dart';
import 'package:we_chat/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'We Chat',
      home: HomeScreen(),
      theme: ThemeData(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        appBarTheme: AppBarTheme(
          centerTitle: true,
          elevation: 1,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
            backgroundColor: Colors.white,
          )
        )
      ),    
    );
  }
}