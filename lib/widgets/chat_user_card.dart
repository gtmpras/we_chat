import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:we_chat/main.dart';

class ChatUserCard extends StatefulWidget {
  const ChatUserCard({super.key});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: mq.width * 0.04,vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 2,
      child: InkWell(
        child: ListTile(
          onTap: (){},
          leading: CircleAvatar(child: Icon(CupertinoIcons.person),),
          title: Text('Prasoon'),
          subtitle: Text('Active 2hrs ago',maxLines: 1,),
          trailing: Text("2 PM"),
    
        ),
      ),
    );
  }
}