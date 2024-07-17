import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:we_chat/consts/strings_const.dart';
import 'package:we_chat/main.dart';
import 'package:we_chat/screens/home_screen.dart';
import 'dart:developer' as developer;
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

  _handleGoogleBtnClick(){
    _signInWithGoogle().then((user){
      print('\nUser: ${user.user}');
      print('\nUserAdditionalInfo: ${user.additionalUserInfo}');
        Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (_) => HomeScreen()));
                
    });

  }
    // Import dart:developer

// _handleGoogleBtnClick() {
//   _signInWithGoogle().then((user) {
//     developer.log('User: ${user.user}');  // Using log instead of print
//     developer.log('UserAdditionalInfo: ${user.additionalUserInfo}');
    
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (_) => HomeScreen()),
//     );
//   });
// }

  Future<UserCredential> _signInWithGoogle() async {
  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance.signInWithCredential(credential);
}

//signout function
_signOut()async{
  await FirebaseAuth.instance.signOut();
  await GoogleSignIn().signOut();
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
                  _handleGoogleBtnClick();
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
