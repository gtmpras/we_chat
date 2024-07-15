import 'package:flutter/material.dart';
import 'package:we_chat/consts/strings_const.dart';
import 'package:we_chat/main.dart';
import 'package:we_chat/screens/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isAnimate = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _isAnimate = true;
      });
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
              right: _isAnimate ? mq.width * .25 : -mq.width * .5,
              width: mq.width * .5,
              duration: Duration(seconds: 1),
              child: Image.asset('images/conversation.png')),
          Positioned(
              top: mq.height * .6,
              left: mq.width * .15,
              width: mq.width * .8,
              height: mq.height * .05,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (_) => HomeScreen()));
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 203, 233, 170),
                    shape: StadiumBorder(),
                    elevation: 1),
                label: RichText(
                    text: TextSpan(
                        style: TextStyle(color: Colors.black, fontSize: 17),
                        children: [
                      TextSpan(text: "Login with"),
                      TextSpan(
                          text: " Google",
                          style: TextStyle(fontWeight: FontWeight.bold))
                    ])),
                icon: Image.asset(
                  'images/search.png',
                  height: mq.height * .03,
                ),
              )),
        ],
      ),
    );
  }
}
