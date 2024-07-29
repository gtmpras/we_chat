import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:we_chat/api/api.dart';
import 'package:we_chat/main.dart';
import 'package:we_chat/models/chat_user_models.dart';
import 'package:we_chat/models/message_model.dart';
import 'package:we_chat/screens/chat_screen.dart';
import 'package:we_chat/utils/my_date_util.dart';
import 'package:we_chat/widgets/message_card.dart';

class ChatUserCard extends StatefulWidget {
  final ChatUserModel user;
  const ChatUserCard({super.key, required this.user});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {

  //last message info (if null -> no message)
  //checking message from MessageModel file
  MessageModel? _message;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: mq.width * 0.04,vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 2,
      child: InkWell(
        child: StreamBuilder(stream: APIs.getLastMessage(widget.user), builder: (context, snapshot){

          final data = snapshot.data?.docs;
          final _list = data?.map((e)=> MessageModel.fromJson(e.data())).toList()??[];
          if(_list.isNotEmpty){
            _message = _list[0];
          }
        return  ListTile(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (_)=> ChatScreen(user: widget.user)));
          },
          //user profile picture
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
          subtitle: Text(_message !=null? _message!.msg : widget.user.about,maxLines: 1,),
          //last message time
          trailing: _message==null 
          ? null
          :_message!.read.isEmpty && _message!.fromId != APIs.user.uid? Container(
            width: 10,height: 10,
            decoration: BoxDecoration(color: Colors.green,borderRadius: BorderRadius.circular(50)),    
          )
          :Text(
           MyDateUtil.getLastMessageTime(context: context, time: _message!.sent),
            style: TextStyle(color: Colors.black),
          ),
    
        );
        })
      ),
    );
  }
}