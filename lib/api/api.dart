import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:we_chat/models/chat_user_models.dart';
import 'dart:developer';
class APIs {
  //for authentication
  static FirebaseAuth auth = FirebaseAuth.instance;

  //for accessing cloud firestore database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  //for accessing firebase storage
  static FirebaseStorage storage = FirebaseStorage.instance;

  //for storing self information
  static late ChatUserModel me;

  //to return current user
  static User get user => auth.currentUser!;
  //for checking if user exists or not?
  static Future<bool> userExists() async {
    return (await firestore
            .collection('users')
            .doc(auth.currentUser!.uid)
            .get())
        .exists;
  }
   static Future<void> getSelfInfo() async {
     await firestore
            .collection('users')
            .doc(user.uid)
            .get()
            .then((user)=>{
              if(user.exists){
                me = ChatUserModel.fromJson(user.data()!),
                log('My Data:  ${user.data()}'),
              }else{
                createUser().then((value)=>getSelfInfo())
              }
            });
  }

  //for creating a new user
  static Future<void> createUser() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final chatUser = ChatUserModel(
        image: user.photoURL.toString(),
        about: "Hey, we are using We Chat",
        name: user.displayName.toString(),
        createdAt: time,
        isOnline: false,
        lastActive: time,
        id: user.uid,
        pushToken: '',
        email: user.email.toString());

    return await firestore
            .collection('users')
            .doc(user.uid)
            .set(chatUser.toJson());
  }

//for getting all users from firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUser(){
    //for showing the id of remaining users instead of user's own's id
    return firestore.collection('users').where('id',isNotEqualTo: user.uid).snapshots();
  }
  //for updating user information
  static Future<void> updateUserInfo() async {
     await firestore
            .collection('users')
            .doc(auth.currentUser!.uid)
            .update({
              'name':me.name,
              'about':me.about
              });
  }

  //update profile picture
  static Future<void> updateProfilePicture(File file)async{
    //file extensions
    final ext = file.path.split('.').last;
    log('Extension: $ext');

    //storage file ref with  path
   final ref = storage.ref().child('profile_picture/${user.uid}.$ext');
    await ref.putFile(file, SettableMetadata(contentType: 'image/$ext')).then((p0){
      log('Data Transferred: ${p0.bytesTransferred / 1000}kb');
    });

    //updating image in firestore database
  me.image = await ref.getDownloadURL();
    await firestore.collection('users').doc(user.uid).update({
      'image': me.image
    });
  }
}
