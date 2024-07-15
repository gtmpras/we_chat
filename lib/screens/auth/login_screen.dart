import 'package:flutter/material.dart';
import 'package:we_chat/consts/strings_const.dart';
import 'package:we_chat/main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(logintitle),
      ),
      body: Stack(
        children: [
          Positioned(
              top: mq.height * .15,
              left: mq.width * .25,
              width: mq.width * .5,
              child: Image.asset('images/conversation.png')),
          Positioned(
              top: mq.height * .6,
              left: mq.width * .15,
              width: mq.width * .8,
              height: mq.height * .05,
              child: ElevatedButton.icon(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 203, 233, 170),
                    shape: StadiumBorder(),
                    elevation: 1),
                label: RichText(
                    text: TextSpan(
                        style: TextStyle(color: Colors.black, fontSize: 17),
                        children: [
                      TextSpan(text: "Sign In with"),
                      TextSpan(
                          text: " Google",
                          style: TextStyle(fontWeight: FontWeight.bold))
                    ])),
                icon: Image.asset('images/search.png',height:mq.height*.03,),
              )),
        ],
      ),
    );
  }
}
