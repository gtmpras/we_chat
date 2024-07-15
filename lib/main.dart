import 'package:flutter/material.dart';
import 'package:we_chat/firebase_options.dart';
import 'package:we_chat/screens/auth/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

//global object for accessing device screen size.
late Size mq;
void main() {
  _initializFirebase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'We Chat',
      home: LoginScreen(),
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

_initializFirebase() async {
  
await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
}