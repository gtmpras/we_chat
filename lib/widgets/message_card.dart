import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:we_chat/api/api.dart';
import 'package:we_chat/main.dart';
import 'package:we_chat/models/message_model.dart';
import 'package:we_chat/utils/my_date_util.dart';

class MessageCard extends StatefulWidget {
  const MessageCard({super.key, required this.message});

  final MessageModel message;

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    return APIs.user.uid == widget.message.fromId
        ? _greyMessage()
        : _blueMessage();
  }

//sender of another user message
  Widget _blueMessage() {
    //update last read message if sender and receiver are different
    if(widget.message.read.isEmpty){
      APIs.updateMessageReadStatus(widget.message);
      log('message read updated');
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //flexible covers only the space consumed by the size of text
        //whereas expanded covers all the remaining size of the box
        Flexible(
          child: Container(
            //message content
            margin: EdgeInsets.symmetric(
                vertical: mq.height * .01, horizontal: mq.width * .04),
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 221, 245, 255),
                border: Border.all(color: Colors.blue),
                //making border curved
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomRight: Radius.circular(30))),
            padding: EdgeInsets.all(mq.width * .04),
            child: Text(
              widget.message.msg,
              style: TextStyle(fontSize: 15, color: Colors.black87),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            right: mq.width * .04,
          ),
          child: Text(
              MyDateUtil.getFormattedTime(context: context, time: widget.message.sent),
              style: TextStyle(fontSize: 13, color: Colors.black54),
            ),
        ),
      ],
    );
  }

//Our or user message
  Widget _greyMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //flexible covers only the space consumed by the size of text
        //whereas expanded covers all the remaining size of the box
        Row(
          children: [
            //for adding some space
            SizedBox(
              width: mq.width * .04,
            ),
            //for double tick blue icon for message read
            if(widget.message.read.isNotEmpty)
             Icon(
              Icons.done_all_rounded,
              color: Colors.blue,
              size: 20,
            ),
            

//adding some space
            SizedBox(
              width: 2,
            ),

            //read time
            Text(
              MyDateUtil.getFormattedTime(context: context, time: widget.message.sent),
              style: TextStyle(fontSize: 13, color: Colors.black54),
            ),
          ],
        ),
        Flexible(
          child: Container(
            //message content
            margin: EdgeInsets.symmetric(
                vertical: mq.height * .01, horizontal: mq.width * .04),
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 219, 217, 217),
                border: Border.all(color: Colors.blue),
                //making border curved
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30))),
            padding: EdgeInsets.all(mq.width * .04),
            child: Text(
              widget.message.msg,
              style: TextStyle(fontSize: 15, color: Colors.black87),
            ),
          ),
        ),
      ],
    );
  }
}
