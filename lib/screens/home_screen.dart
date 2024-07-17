import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:we_chat/consts/strings_const.dart';
import 'package:we_chat/screens/auth/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
_signOut()async{
  await FirebaseAuth.instance.signOut();
  await GoogleSignIn().signOut();
}


class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(CupertinoIcons.home),
        title: Text(title),
        actions: [
          IconButton(onPressed: (){}, 
          icon: Icon(Icons.search)),
          IconButton(onPressed: (){}, 
          icon: Icon(Icons.more_vert)),
          IconButton(onPressed: (){
            _signOut();
            Navigator.push(context,
            MaterialPageRoute(builder: (_)=>LoginScreen()));
            print('Logged Out Successfully');
          }, 
          icon: Icon(Icons.run_circle_outlined)),
        ],
      ),

      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom:10.0),
        child: FloatingActionButton(onPressed: (){},
        child: Icon(Icons.add_comment_rounded),),
      ),
    );
    
  }
}
