import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
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
    bool isMe = APIs.user.uid == widget.message.fromId;
    return InkWell(
        onLongPress: () {
          _showBottomSheet(isMe);
        },
        child: isMe ? _greyMessage() : _blueMessage());
  }

//sender of another user message
  Widget _blueMessage() {
    //update last read message if sender and receiver are different
    if (widget.message.read.isEmpty) {
      APIs.updateMessageReadStatus(widget.message);
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
            padding: EdgeInsets.all(widget.message.type == Type.image
                ? mq.width * .04
                : mq.width * .03),
            child: widget.message.type == Type.text
                ?
                //show text
                Text(
                    widget.message.msg,
                    style: TextStyle(fontSize: 15, color: Colors.black87),
                  )
                :
                //show image
                ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: CachedNetworkImage(
                        imageUrl: widget.message.msg,
                        placeholder: (context, url) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            ),
                        errorWidget: (context, url, error) => Icon(
                              Icons.image,
                              size: 70,
                            )),
                  ),
          ),
        ),

        Padding(
          padding: EdgeInsets.only(
            right: mq.width * .04,
          ),
          child: Text(
            MyDateUtil.getFormattedTime(
                context: context, time: widget.message.sent),
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
            if (widget.message.read.isNotEmpty)
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
              MyDateUtil.getFormattedTime(
                  context: context, time: widget.message.sent),
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
            padding: EdgeInsets.all(widget.message.type == Type.image
                ? mq.width * .03
                : mq.width * .04),
            child: widget.message.type == Type.text
                ?
                //show text
                Text(
                    widget.message.msg,
                    style: TextStyle(fontSize: 15, color: Colors.black87),
                  )
                :
                //show image
                ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: CachedNetworkImage(
                        imageUrl: widget.message.msg,
                        placeholder: (context, url) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            ),
                        errorWidget: (context, url, error) => Icon(
                              Icons.image,
                              size: 70,
                            )),
                  ),
          ),
        ),
      ],
    );
  }

//bottom sheet for modifying message details
  void _showBottomSheet(bool isMe) {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (_) {
          return ListView(
            //only display the size of listView according to the contents in the list

            shrinkWrap: true,
            children: [
              Container(
                height: 4,
                margin: EdgeInsets.symmetric(
                    vertical: mq.height * .015, horizontal: mq.width * .4),
                decoration: BoxDecoration(
                    color: Colors.grey, borderRadius: BorderRadius.circular(8)),
              ),
              //copy option
              widget.message.type == Type.text
                  ? _OptionItem(
                      icon: Icon(
                        Icons.copy_rounded,
                        color: Colors.blue,
                        size: 26,
                      ),
                      name: 'Copy Text',
                      onTap: () {})
                  :
                  //save image
                  _OptionItem(
                      icon: Icon(
                        Icons.download_rounded,
                        color: Colors.blue,
                        size: 26,
                      ),
                      name: 'Save Image',
                      onTap: () {}),

              if (isMe)
                Divider(
                  color: Colors.black54,
                  endIndent: mq.width * .04,
                  indent: mq.height * .04,
                ),
              //edit option
              if (widget.message.type == Type.text && isMe)
                _OptionItem(
                    icon: Icon(
                      Icons.edit,
                      color: Colors.blue,
                      size: 26,
                    ),
                    name: 'Edit Message',
                    onTap: () {}),

              //delete option
              if (isMe)
                _OptionItem(
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                      size: 26,
                    ),
                    name: 'Delete Message',
                    onTap: () {}),

              Divider(
                color: Colors.black54,
                endIndent: mq.width * .04,
                indent: mq.height * .04,
              ),
              //sent Time

              _OptionItem(
                  icon: Icon(
                    Icons.remove_red_eye,
                    color: Colors.blue,
                    size: 26,
                  ),
                  name: 'Sent At',
                  onTap: () {}),
              //read At option

              _OptionItem(
                  icon: Icon(
                    Icons.remove_red_eye,
                    color: Colors.green,
                    size: 26,
                  ),
                  name: 'Read At',
                  onTap: () {}),
            ],
          );
        });
  }
}

//custom options card (for copy,edit,delete etc.)
class _OptionItem extends StatelessWidget {
  final Icon icon;
  final String name;
  final VoidCallback onTap;

  const _OptionItem(
      {required this.icon, required this.name, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: Padding(
        padding: EdgeInsets.only(
            left: mq.width * .05, top: mq.height * .015, bottom: .02),
        child: Row(
          children: [
            icon,
            Flexible(
                child: Text(
              '   $name',
              style: TextStyle(
                  fontSize: 15, color: Colors.black54, letterSpacing: 0.5),
            ))
          ],
        ),
      ),
    );
  }
}
