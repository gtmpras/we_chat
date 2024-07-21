import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:we_chat/api/api.dart';
import 'package:we_chat/consts/strings_const.dart';
import 'package:we_chat/main.dart';
import 'package:we_chat/screens/auth/login_screen.dart';
import 'package:we_chat/screens/profile_screen.dart';
import 'package:we_chat/widgets/chat_user_card.dart';

import '../models/chat_user_models.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

_signOut() async {
  await APIs.auth.signOut();
  await GoogleSignIn().signOut();
}

class _HomeScreenState extends State<HomeScreen> {
  //for storing all users
  List<ChatUserModel> _list = [];
  List<ChatUserModel> _searchList = [];

  //for storing search status
  bool _isSearching = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    APIs.getSelfInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(CupertinoIcons.home),
        title: _isSearching? TextField(
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Name, Email,...',
          ),
          autofocus: true,
          style: TextStyle(fontSize:16,letterSpacing: 0.5),
          onChanged: (val){
            //search logic
          _searchList.clear();
          for (var i in _list){
            if(i.name.contains(val.toLowerCase()) || i.email.contains(val.toLowerCase())){
              _searchList.add(i);
            }
            setState(() {
              _searchList;
            });
          }
          },
        ):Text(title),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  _isSearching = !_isSearching;
                });
              },
              icon: Icon(_isSearching
                  ? CupertinoIcons.clear_circled_solid
                  : Icons.search)),
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ProfileScreen(user: APIs.me)));
              },
              icon: Icon(Icons.more_vert)),
          IconButton(
              onPressed: () {
                _signOut();
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => LoginScreen()));
                print('Logged Out Successfully');
              },
              icon: Icon(Icons.run_circle_outlined)),
        ],
      ),

      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: FloatingActionButton(
          onPressed: () {},
          child: Icon(Icons.add_comment_rounded),
        ),
      ),
//fetching data from cloud firestore firebase.
      body: StreamBuilder(
          stream: APIs.getAllUser(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
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
                _list = data
                        ?.map((e) => ChatUserModel.fromJson(e.data()))
                        .toList() ??
                    [];

                if (_list.isNotEmpty) {
                  return Container(
                    child: ListView.builder(
                        padding: EdgeInsets.only(top: mq.height * .01),
                        itemCount:_isSearching? _searchList.length: _list.length,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return ChatUserCard(user:_isSearching? _searchList[index]: _list[index]);
                        }),
                  );
                } else {
                  return Center(
                      child: Text(
                    emptycolud_store,
                    style: TextStyle(fontSize: 20),
                  ));
                }
            }
          }),
    );
  }
}
