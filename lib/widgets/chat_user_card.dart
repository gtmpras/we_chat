import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:we_chat/main.dart';
import 'package:we_chat/models/chat_user_models.dart';
import 'package:we_chat/screens/chat_screen.dart';

class ChatUserCard extends StatefulWidget {
  final ChatUserModel user;
  const ChatUserCard({super.key, required this.user});

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
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (_)=> ChatScreen(user: widget.user)));
          },
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(mq.height * .3),
            child: CachedNetworkImage(
              imageUrl: widget.user.image,
              width: mq.height *.055,
              height: mq.height *.055,
              errorWidget: (context,url,error)=>
              CircleAvatar(child: Icon(CupertinoIcons.person),),
              ),
          ),
          title: Text(widget.user.name),
          subtitle: Text(widget.user.about,maxLines: 1,),
          trailing: Container(
            width: 10,height: 10,
            decoration: BoxDecoration(color: Colors.green,borderRadius: BorderRadius.circular(50)),
             
          ),
    
        ),
      ),
    );
  }
}