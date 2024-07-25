import 'dart:ffi';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:we_chat/main.dart';
import 'package:we_chat/models/chat_user_models.dart';

class ChatScreen extends StatefulWidget {
  final ChatUserModel user;

  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          //removing back button
          automaticallyImplyLeading: false,
          flexibleSpace: _appBar(),
        ),
        body: Column(
          children: [
            _chatInput(),
          ],
        ),
      ),
    );
  }

  Widget _appBar() {
    return InkWell(
      onTap: () {},
      child: Row(
        children: [
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black87,
              )),
          ClipRRect(
            borderRadius: BorderRadius.circular(mq.height * .3),
            child: CachedNetworkImage(
              imageUrl: widget.user.image,
              width: mq.height * .055,
              height: mq.height * .055,
              errorWidget: (context, url, error) => CircleAvatar(
                child: Icon(CupertinoIcons.person),
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.user.name,
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 2,
              ),
              Text(
                'Last seen not availabe',
                style: TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                    fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _chatInput() {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: mq.height * .01, horizontal: mq.width * .023),
      child: Row(
        children: [
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.emoji_emotions,
                      color: Colors.blueAccent,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: 'Type Something...',
                        hintStyle: TextStyle(color: Colors.blue),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.image,
                      color: Colors.blueAccent,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.camera_alt_rounded,
                      color: Colors.blueAccent,
                    ),
                  ),
                  SizedBox(
                    width: mq.width * .02,
                  )
                ],
              ),
            ),
          ),
          MaterialButton(
            onPressed: () {},
            padding: EdgeInsets.only(top: 10, bottom: 10, right: 5, left: 10),
            minWidth: 0,
            shape: CircleBorder(),
            color: Colors.green,
            child: Icon(
              Icons.send,
              color: Colors.white,
              size: 26,
            ),
          )
        ],
      ),
    );
  }
}
