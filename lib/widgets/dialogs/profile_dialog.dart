import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:we_chat/main.dart';
import 'package:we_chat/models/chat_user_models.dart';
import 'package:we_chat/screens/view_profile_screen.dart';

class ProfileDialog extends StatelessWidget {
  const ProfileDialog({super.key, required this.user});

  final ChatUserModel user;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      backgroundColor: Colors.white.withOpacity(.7),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      content: SizedBox(
        width: mq.width * .6,
        height: mq.height * .35,
        child: Stack(
          children: [
            //user profile picture
            Positioned(
              top: mq.height * .075,
              left: mq.width * .1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(mq.height * .25),
                child: CachedNetworkImage(
                  imageUrl: user.image,
                  width: mq.width * .5,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) => CircleAvatar(
                    child: Icon(CupertinoIcons.person),
                  ),
                ),
              ),
            ),

            Positioned(
              left: mq.width *.04,
              top: mq.height * .02,
              width: mq.width * .55,
              child: Text(
                user.name,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            //user profile picture
            Positioned(
              right: 8,
              top: 4,
              child: Align(
                  alignment: Alignment.topRight,
                  child: MaterialButton(
                      shape: CircleBorder(),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(builder: (_)=>ViewProfileScreen(user: user)));
                      },
                      child: Icon(
                        Icons.info_outline,
                        color: Colors.blue,
                        size: 30,
                      ))),
            )
          ],
        ),
      ),
    );
  }
}
