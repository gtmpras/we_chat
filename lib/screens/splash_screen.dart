import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:we_chat/consts/strings_const.dart';
import 'package:we_chat/main.dart';
import 'package:we_chat/screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      Navigator.push(context,MaterialPageRoute(builder: (_)=>HomeScreen()));
    });
  }

  Widget build(BuildContext context) {
    //initializing media query
    mq = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(logintitle),
      ),
      body: Stack(
        children: [
          AnimatedPositioned(
              top: mq.height * .15,
              right:mq.width * .25,
              width: mq.width * .5,
              duration: Duration(seconds: 1),
              child: Image.asset('images/conversation.png')),
          Positioned(
              top: mq.height * .6,
              width: mq.width,
              child:Text('Created by Prasoon Gautam',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black54,fontSize: 18,
                letterSpacing: .5,
              ),)), 
        ],
      ),
    );
  }
}
