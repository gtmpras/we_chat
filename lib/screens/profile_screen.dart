import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:we_chat/api/api.dart';
import 'package:we_chat/consts/strings_const.dart';
import 'package:we_chat/main.dart';
import 'package:we_chat/screens/auth/login_screen.dart';
import '../models/chat_user_models.dart';

class ProfileScreen extends StatefulWidget {
  final ChatUserModel user;
  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

_signOut() async {
  await APIs.auth.signOut();
  await GoogleSignIn().signOut();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(profile_title),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: FloatingActionButton.extended(
          backgroundColor: Colors.red,
          onPressed: () async {
            await APIs.auth.signOut();
            await GoogleSignIn().signOut();
          },
          icon: Icon(Icons.run_circle_outlined),
          label: Text('Logout'),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: mq.width * .05,
        ),
        child: Column(
          children: [
            //for adding some space
            SizedBox(
              width: mq.width,
              height: mq.height * .03,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(mq.height * .1),
              child: CachedNetworkImage(
                imageUrl: widget.user.image,
                width: mq.height * .2,
                height: mq.height * .2,
                fit: BoxFit.fill,
                errorWidget: (context, url, error) => CircleAvatar(
                  child: Icon(CupertinoIcons.person),
                ),
              ),
            ),

            //for adding some space
            SizedBox(
              width: mq.width,
              height: mq.height * .03,
            ),
            Text(
              widget.user.email,
              style: TextStyle(color: Colors.black54, fontSize: 16),
            ),

            //for adding some space
            SizedBox(
              height: mq.height * .05,
            ),

            //name input field
            TextFormField(
              initialValue: widget.user.name,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  prefixIcon: Icon(
                    Icons.person,
                    color: Colors.blue,
                  ),
                  hintText: 'eg. Jane Dake',
                  label: Text('Name')),
            ),

            //for adding some space
            SizedBox(
              height: mq.height * .02,
            ),

            //about field
            TextFormField(
              initialValue: widget.user.about,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  prefixIcon: Icon(
                    Icons.info_outline,
                    color: Colors.blue,
                  ),
                  hintText: 'eg. Feeling Happy',
                  label: Text('About')),
            ),
            SizedBox(
              height: mq.height * .05,
            ),

//Update Profile Button
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  minimumSize: Size(mq.width * .5, mq.height * .05)),
              onPressed: () {},
              label: Text("Update"),
              icon: Icon(Icons.edit),
            ),
          ],
        ),
      ),
    );
  }
}
