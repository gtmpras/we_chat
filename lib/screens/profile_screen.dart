import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:we_chat/api/api.dart';
import 'package:we_chat/consts/strings_const.dart';
import 'package:we_chat/main.dart';
import 'package:we_chat/screens/auth/login_screen.dart';
import 'package:we_chat/utils/dialogs.dart';
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
  final _formkey = GlobalKey<FormState>();
  String? _image;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //for hiding the keyboard when tapped on screen
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(profile_title),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: FloatingActionButton.extended(
            backgroundColor: Colors.red,
            onPressed: () async {
              Dialogs.ShowProgressBar(context);
              await APIs.auth.signOut().then((value) async {
                await GoogleSignIn().signOut().then((value) {
                  Navigator.pop(context);
                  //for moving to homeScreen because stack remains empty
                  Navigator.pop(context);
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (_) => LoginScreen()));
                });
              });
            },
            icon: Icon(Icons.run_circle_outlined),
            label: Text('Logout'),
          ),
        ),
        body: Form(
          key: _formkey,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: mq.width * .05,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  //for adding some space
                  SizedBox(
                    width: mq.width,
                    height: mq.height * .03,
                  ),
                  Stack(
                    children: [
                      //profile picture
                      _image != null ?

                      //local image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(mq.height * .1),
                        child: Image.file(
                         File(_image!),
                          width: mq.height * .2,
                          height: mq.height * .2,
                          fit: BoxFit.cover,
                          
                        ),
                      )
                      :
                      //image from server
                      ClipRRect(
                        borderRadius: BorderRadius.circular(mq.height * .1),
                        child: CachedNetworkImage(
                          imageUrl: widget.user.image,
                          width: mq.height * .2,
                          height: mq.height * .2,
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) => CircleAvatar(
                            child: Icon(CupertinoIcons.person),
                          ),
                        ),
                      ),


                      //edit image button
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: MaterialButton(
                          elevation: 1,
                          onPressed: () {
                            _showBottomSheet();
                          },
                          shape: CircleBorder(),
                          color: Colors.white,
                          child: Icon(
                            Icons.edit,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
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
                    onSaved: (val) => APIs.me.name = val ?? '',
                    validator: (val) =>
                        val != null && val.isNotEmpty ? null : 'Required Field',
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
                    onSaved: (val) => APIs.me.about = val ?? '',
                    validator: (val) =>
                        val != null && val.isNotEmpty ? null : 'Required Field',
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
                    onPressed: () {
                      if (_formkey.currentState!.validate()) {
                        _formkey.currentState!.save();
                        APIs.updateUserInfo();
                        Dialogs.showSnackbar(context, profile_update);
                      }
                    },
                    label: Text("Update"),
                    icon: Icon(Icons.edit),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showBottomSheet() {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (_) {
          return ListView(
            //only display the size of listView according to the contents in the list

            shrinkWrap: true,
            padding:
                EdgeInsets.only(top: mq.height * .03, bottom: mq.height * .05),
            children: [
              //pick profile picture label
              Text('Pick Profile Picture',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  )),
              SizedBox(
                height: mq.height * .01,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //pick profile picture from gallery
                  ElevatedButton(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        //pickin image from gallery
                        final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                        if(image != null){
                          log('Image Path: ${image.path}-- MimeType: ${image.mimeType}');
                       //for hiding the bottom sheet
                       setState(() {
                         _image = image.path;
                       });
                        Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        fixedSize: Size(mq.width * .3, mq.height * .15),
                        shape: CircleBorder(),
                      ),
                      child: Image.asset('images/gallery.png')),

                  //pick profile picture from camera
                  ElevatedButton(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        //pickin image from camera
                        final XFile? image = await picker.pickImage(source: ImageSource.camera);
                        if(image != null){
                          log('Image Path: ${image.path}');
                       //for hiding the bottom sheet
                       setState(() {
                         _image = image.path;
                       });
                        Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        fixedSize: Size(mq.width * .3, mq.height * .15),
                        shape: CircleBorder(),
                      ),
                      child: Image.asset('images/camera.png')),
                
                ],
              )
            ],
          );
        });
  }
}
