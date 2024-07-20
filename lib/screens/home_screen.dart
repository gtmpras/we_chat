import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:we_chat/api/api.dart';
import 'package:we_chat/consts/strings_const.dart';
import 'package:we_chat/main.dart';
import 'package:we_chat/screens/auth/login_screen.dart';
import 'package:we_chat/widgets/chat_user_card.dart';

import '../models/chat_user_models.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
_signOut()async{
  await APIs.auth.signOut();
  await GoogleSignIn().signOut();
}


class _HomeScreenState extends State<HomeScreen> {

  List<ChatUserModel> list = [];
  
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
//fetching data from cloud firestore firebase.
      body: StreamBuilder(
        stream: APIs.firestore.collection('users').snapshots(),
        builder: (context, snapshot){
          switch(snapshot.connectionState){
            //if some time takes exectue this
            case ConnectionState.waiting:
            case ConnectionState.none:
            return Center(
              child: CircularProgressIndicator(),
            );
            //if data is loaded then execute this
          case ConnectionState.active:
          case ConnectionState.done:

         
            final data = snapshot.data?.docs;
            list = data?.map((e)=> ChatUserModel.fromJson(e.data())).toList()??[];
          
          if(list.isNotEmpty){
            
          return ListView.builder(
          padding: EdgeInsets.only(top: mq.height * .01),
          itemCount: list.length,
          physics: BouncingScrollPhysics(),
          itemBuilder: (context,index){
          return ChatUserCard(user: list[index]);
          
        });
          }else{
            return 
            Center(child: Text(emptycolud_store,style:TextStyle(fontSize: 20),));
          }
          }
        }   
      ),
    );
  }
}
